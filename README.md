# Enhancer-Activity-Predictor
`Enhancer Activity Predictor` is an R script that uses combinatorial TF ChIP scores as input to predict enhancer activity. 

## Getting Started
In order to download `Enhancer Activity Predictor`, clone the repository via the following commands

```
git clone https://github.com/UIUCSinhaLab/Enhancer-Activity-Predictor
cd Enhancer-Activity-Predictor
```

## Requirements 
R >= 3.3.0

R packages: xgboost, DMwR

## Files in Data Directory
`CAD4DmelEnhancers.txt` has 232 D. melanogaster enhancers. Columns are putative enhancer coordinates and ID, experimentally verified enhancer coordiates and ID, Mesoderm activity, Visceral Muscle activity, Somatic Muscle activity, and 14 D. melanogaster ChIP scores at specific TF:Time_Point condition.    

`DmelOrthChIP.txt` is a sample input file for enhancer activity prediction. Columns 1-14 are TF-ChIP scores for D. melanogaster, and columns 15-28 are TF-ChIP scores for D. virilis. 

## Citation
If you use the R script or the enhancer activity data, please cite.

