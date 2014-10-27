ruleDirTB='../ruleFilesTextBook/';
ruleDirTBpme='../ruleFilesTextBookPME/';
ruleDirWB='../ruleFilesWorkbook/';
ruleDirWBpme='../ruleFilesWorkbookPME/';
textDir='../textBook/';
wbDir='../workbook';

priorWeight=0.01;
[rulesTB, predTB]=readRuleFiles(ruleDirTB,[],127);
[rulesTBpme, predTBpme]=readRuleFiles(ruleDirTBpme,[],127);
[rulesWB, predWB]=readRuleFiles(ruleDirWB,[],54);
[rulesWBpme, predWBpme]=readRuleFiles(ruleDirWBpme,[],54);

for i = 1 : 5
    [HMMvalsTB{i}, HMMvalsTBprior{i}, HMMvalsWB{i}, HMMvalsWBprior{i}]=laitz(predTBpme,predWBpme,[i:5:127],textDir, wbDir,priorWeight); 
end

hmmTB=PRstruct;
hmmTBprior=PRstruct;

fnames = fieldnames(hmmTB);
for f = 1 : length(fnames)
    for i = 1 : 5
        hmmTB.(fnames{f})=hmmTB.(fnames{f})+HMMvalsTB{i}.(fnames{f});
        hmmTBprior.(fnames{f})=hmmTBprior.(fnames{f})+HMMvalsTBprior{i}.(fnames{f});        
    end
end

hmmWB=HMMvalsWB{1};
hmmWBprior=HMMvalsWBprior{1};

hmmTB=calcPRF(hmmTB);
hmmTBprior=calcPRF(hmmTBprior);
hmmWB=calcPRF(hmmWB);
hmmWBprior=calcPRF(hmmWBprior);
% hmm2=calcPRF(hmm);
% hmm1.confusion=HMMvals{1}.confusion+HMMvals{2}.confusion+HMMvals{3}.confusion+HMMvals{4}.confusion+HMMvals{5}.confusion;
% hmm1.confusionPercent=hmm.confusion/sum(sum(hmm.confusion))*100;
% hmm2.confusion=HMMvals{1}.confusion+HMMvals{2}.confusion+HMMvals{3}.confusion+HMMvals{4}.confusion+HMMvals{5}.confusion;
% hmm2.confusionPercent=hmm.confusion/sum(sum(hmm.confusion))*100;
% rules.confusionPercent=rules.confusion/sum(sum(rules.confusion))*100;