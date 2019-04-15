library(xgboost)
library(DMwR)

# settings
folder = "./data"
tissues = c("Meso","VM","SM")

#load training data
mesotab8 = read.delim( file.path(folder, "CAD4DmelEnhancers.txt"), comment.char="", quote="", sep="\t",header=T )
train_data = data.matrix(mesotab8[,c(12:25)]) #Dmel ChIP for 14 TF:TP conditions

#load sample testing data
ChIP=read.table("./data/DmelOrthChIP.txt",header=T)

Dmel = ChIP[,1:14]
Dmel = Dmel[,c(12:14,10:11,6:9,5,1,3:4,2)]

Dvir = ChIP[,15:28]
Dvir = Dvir[,c(12:14,10:11,7:9,5:6,1,4,2:3)]

###For each activity class, train a predictor
for (ti in tissues){
labels_train = as.factor(mesotab8[,ti])
smoted_data = SMOTE(labels_train~., data.frame(train_data, labels_train),k=5,perc.over=50,perc.under=0)
syn_data = smoted_data[!rownames(smoted_data)%in%(rownames(train_data)[labels_train==1]),]
rownames(train_data)=paste(rownames(train_data),"cad",sep="_")
all_train_data = rbind(train_data,syn_data[,1:14])
all_labels_train = c(labels_train, syn_data[,15])-1

train_temp <- xgb.DMatrix(data = data.matrix(all_train_data), label = as.numeric(all_labels_train)) # make appropriate input for xgboost
gc() # garbage collect to clear memory leaks
set.seed(11111) # fix seed for reproducible results


activity_model <- xgboost(data = train_temp, # call cross-validated xgboost
                        nthread = 2,
                        nrounds = 50, # a large enough amount of iterations because xgboost stops itself thanks to early_stopping_rounds
                        max_depth = 4, # the maximum depth of each tree (lower it if the validation metric is giving a too large value)
                        eta = 0.2, # the shrinkage of each tree, 0.2 is good for tinkering (on not big datasets) and you can do 0.1 or lower if you need maximum performance
                        subsample = 0.9, # tune it only once you fixed the depth
                        colsample_bytree = 0.8, # tune it only once you fixed the depth
                        booster = "gbtree", 
                        early_stopping_rounds = 5, # if the validation performance goes up for 25 times in a row, xgboost will stop and tell you the best performance for how the best amount of rounds - use early.stop.round if not xgboost version 0.6
                        objective = "binary:logistic",
                        prediction = T) # print pred

##Predicted Activity
DmelAct = predict(activity_model, data.matrix(Dmel))
DvirAct = predict(activity_model, data.matrix(Dvir))
}


