function [res1, res2, res3, res4]=laitz(pred1,pred2,testing,textList,wbList,priorWeight)

% 5-fold cross-validation on textbook
[fileList, fileData]=getFileList(textList);
num1 = 1;
num2 = 1;
for i = 1 : length(fileData)
    if sum(i==testing) > 0
        testData{num1} = fileData{i};
        testList{num1} = fileList{i};
        num1=num1+1;
    else
        trainData{num2} = fileData{i};
        trainList{num2} = fileList{i};
        num2=num2+1;
    end
end
[GT,vpath,vpath2] = runLaitzHMM(testData,trainData,pred1(testing),priorWeight);

res1=calcStatsLaitz(vpath,GT);
res2=calcStatsLaitz(vpath2,GT);

% train on textbook, test on workbook
[WBfileList, WBfileData]=getFileList(wbList);
[WBGT,WBvpath,WBvpath2] = runLaitzHMM(WBfileData,fileData,pred2,priorWeight);

res3=calcStatsLaitz(WBvpath,WBGT);
res4=calcStatsLaitz(WBvpath2,WBGT);

% train on textbook, test on workbook
% [fileList2, fileData2]=getFileList(wbList);
% [res2.GT, res2.vpath,res2.vpath2] = runLaitzHMM(fileData,fileData2,WBpred);