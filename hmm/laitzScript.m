ruleDirTB='../ruleFilesTextBook/';
ruleDirTBpme='../ruleFilesTextBookPME/';
ruleDirWB='../ruleFilesWorkbook/';
ruleDirWBpme='../ruleFilesWorkbookPME/';
% textDir='../ruleFilesTextBook/';
% wbDir='../ruleFilesWorkbook';
textDir='../textBook/';
wbDir='../workbook';

% useDur=1;
priorWeight=0.01;
[rulesTB, predTB]=readRuleFiles(ruleDirTB,[],126);
[rulesTBpme, predTBpme]=readRuleFiles(ruleDirTBpme,[],126);
[rulesWB, predWB]=readRuleFiles(ruleDirWB,[],54);
[rulesWBpme, predWBpme]=readRuleFiles(ruleDirWBpme,[],54);

for i = 1 : 5
    % dur
    [HMMvalsTBdur{i}, HMMvalsTBpriordur{i}, HMMvalsWBdur{i}, HMMvalsWBpriordur{i}]=laitz(predTBpme,predWBpme,[i:5:126],textDir, wbDir,priorWeight,1); 
    % no dur
    [HMMvalsTB{i}, HMMvalsTBprior{i}, HMMvalsWB{i}, HMMvalsWBprior{i}]=laitz(predTBpme,predWBpme,[i:5:126],textDir, wbDir,priorWeight,0);     
end

hmmTBdur=PRstruct;
hmmTBpriordur=PRstruct;

hmmTB=PRstruct;
hmmTBprior=PRstruct;


fnames = fieldnames(hmmTB);
for f = 1 : length(fnames)
    for i = 1 : 5
        hmmTBdur.(fnames{f})=hmmTBdur.(fnames{f})+HMMvalsTBdur{i}.(fnames{f});
        hmmTBpriordur.(fnames{f})=hmmTBpriordur.(fnames{f})+HMMvalsTBpriordur{i}.(fnames{f});        
        hmmTB.(fnames{f})=hmmTB.(fnames{f})+HMMvalsTB{i}.(fnames{f});
        hmmTBprior.(fnames{f})=hmmTBprior.(fnames{f})+HMMvalsTBprior{i}.(fnames{f});        
    end
end

hmmTBdur.confusion=HMMvalsTBdur{1}.confusion+HMMvalsTBdur{2}.confusion+HMMvalsTBdur{3}.confusion+HMMvalsTBdur{4}.confusion+HMMvalsTBdur{5}.confusion;
hmmTBpriordur.confusion=HMMvalsTBpriordur{1}.confusion+HMMvalsTBpriordur{2}.confusion+HMMvalsTBpriordur{3}.confusion+HMMvalsTBpriordur{4}.confusion+HMMvalsTBpriordur{5}.confusion;
hmmTB.confusion=HMMvalsTB{1}.confusion+HMMvalsTB{2}.confusion+HMMvalsTB{3}.confusion+HMMvalsTB{4}.confusion+HMMvalsTB{5}.confusion;
hmmTBprior.confusion=HMMvalsTBprior{1}.confusion+HMMvalsTBprior{2}.confusion+HMMvalsTBprior{3}.confusion+HMMvalsTBprior{4}.confusion+HMMvalsTBprior{5}.confusion;

hmmTBdur=calcPRF(hmmTBdur);
hmmTBpriordur=calcPRF(hmmTBpriordur);

hmmTB=calcPRF(hmmTB);
hmmTBprior=calcPRF(hmmTBprior);

hmmWBdur=HMMvalsWBdur{1};
hmmWBpriordur=HMMvalsWBpriordur{1};
hmmWBdur=calcPRF(hmmWBdur);
hmmWBpriordur=calcPRF(hmmWBpriordur);

hmmWB=HMMvalsWB{1};
hmmWBprior=HMMvalsWBprior{1};
hmmWB=calcPRF(hmmWB);
hmmWBprior=calcPRF(hmmWBprior);


% hmm2=calcPRF(hmm);
% hmm1.confusion=HMMvals{1}.confusion+HMMvals{2}.confusion+HMMvals{3}.confusion+HMMvals{4}.confusion+HMMvals{5}.confusion;
% hmm1.confusionPercent=hmm.confusion/sum(sum(hmm.confusion))*100;
% hmm2.confusion=HMMvals{1}.confusion+HMMvals{2}.confusion+HMMvals{3}.confusion+HMMvals{4}.confusion+HMMvals{5}.confusion;
% hmm2.confusionPercent=hmm.confusion/sum(sum(hmm.confusion))*100;
% rules.confusionPercent=rules.confusion/sum(sum(rules.confusion))*100;