ruleDir='../ruleFilesTextBook/';
ruleDir2='../ruleFilesTextBookPME/';
textDir='../textBook/';
wbDir='../workbook';

ignore=[33 52 53 56  58  59 67 70 103  114  117];
maxFiles=128;
[rules, pred]=readRuleFiles(ruleDir,ignore,maxFiles);
[rules2, pred2]=readRuleFiles(ruleDir2,ignore,maxFiles);

hmm=PRstruct;

for i = 1 : 5
    HMMvals{i}=laitz(pred,[i:5:128],textDir, wbDir); 
end

fnames = fieldnames(hmm);

for i = 1 : 5
    for f = 1 : length(fnames)
        hmm.(fnames{f})=hmm.(fnames{f})+HMMvals{i}.(fnames{f});
    end
end

hmm=calcPRF(hmm);
hmm.confusion=HMMvals{1}.confusion+HMMvals{2}.confusion+HMMvals{3}.confusion+HMMvals{4}.confusion+HMMvals{5}.confusion;
hmm.confusionPercent=hmm.confusion/sum(sum(hmm.confusion))*100;
rules.confusionPercent=rules.confusion/sum(sum(rules.confusion))*100;