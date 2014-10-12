function [res1, res2]=laitz(pred,testing,textList,wbList)

% 5-fold cross-validation on textbook
[fileList, fileData]=getFileList(textList);
res1=PRstruct;
num1 = 1;
num2 = 1;
for i = 1 : length(fileData)
    if sum(i==testing) > 0
        testData{num1} = fileData{i};
        num1=num1+1;
    else
        trainData{num2} = fileData{i};
        num2=num2+1;
    end
end
[res1.GT, res1.vpath,res1.vpath2] = runLaitzHMM(testData,trainData,pred(testing));

res1.predVals=[res1.vpath{:}];
res1.gtVals=[res1.GT{:}];

res1.confusion = confusionMat(res1.predVals,res1.gtVals);

res1=tallyTFPN(res1);

% train on textbook, test on workbook
% [fileList2, fileData2]=getFileList(wbList);
% [res2.GT, res2.vpath,res2.vpath2] = runLaitzHMM(fileData,fileData2,WBpred);