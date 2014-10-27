function res=calcStatsLaitz(vpath,GT)

res=PRstruct;
res.predVals=[vpath{:}];
res.gtVals=[GT{:}];

res.confusion = confusionMat(res.predVals,res.gtVals);

res=tallyTFPN(res);