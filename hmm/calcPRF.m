function prStruct=calcPRF(prStruct)

%precision: true positive/(true positive + false positive)
%recall: true positive/(true positive + false negative)
%true positive: correct result
%false negative: missing result
%false positive: unexepected results

prStruct.precisionT = prStruct.tpT/(prStruct.tpT + prStruct.fpT);
prStruct.recallT = prStruct.tpT/(prStruct.tpT + prStruct.fnT);
prStruct.precisionP = prStruct.tpP/(prStruct.tpP + prStruct.fpP);
prStruct.recallP = prStruct.tpP/(prStruct.tpP + prStruct.fnP);
prStruct.precisionD = prStruct.tpD/(prStruct.tpD + prStruct.fpD);
prStruct.recallD = prStruct.tpD/(prStruct.tpD + prStruct.fnD);

%f1 score: 2*precision * recall/(precision+recall)
prStruct.fscoreT=2*prStruct.precisionT*prStruct.recallT/(prStruct.precisionT+prStruct.recallT);
prStruct.fscoreD=2*prStruct.precisionD*prStruct.recallD/(prStruct.precisionD+prStruct.recallD);
prStruct.fscoreP=2*prStruct.precisionP*prStruct.recallP/(prStruct.precisionP+prStruct.recallP);