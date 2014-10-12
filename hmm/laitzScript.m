ruleDir='../ruleFiles/';
textDir='../textBook/';
wbDir='../workbook';

ignore=[33 52 53 56  58  59 67 70 103  114  117];
maxFiles=128;
[rules, pred]=readRuleFiles(ruleDir,ignore,maxFiles);

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