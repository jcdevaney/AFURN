function [rules, pred]=readRuleFiles(dirName, ignore, maxFiles)

cd(dirName)
directory = dir;
j = 1;
for i = 4 : length(directory)
    fileList{j} = directory(i).name;
    j = j + 1;
end

score=0;
scoreT=0;
scoreD=0;

% Put data in three column format
% Duration - Chord - Function
for file = 1 : length(fileList)
    fileID=fopen(fileList{file});
    ta = {}; 
    line = fgetl(fileID); 
    while line ~= -1
        ta{end+1} = line; 
        line = fgetl(fileID); 
    end

    j = 1; 
    for i = 7 : size(ta,2)-1
        vals{j} = ta{i};
        j = j+1; 
    end

    j = 1;
    for i = 1 : size(vals,2)
        if regexp(vals{i},'=')
            ;
        else
            vals1{j} = vals{i};
            j = j + 1;
        end       
    end
   for i = 1 : size(vals1,2)
        delimiter = sprintf('\t');
        delimIdx = find(vals1{i} == delimiter);
        fileData{file}{i,1}=vals1{i}(1:delimIdx(1)-1);
        if length(delimIdx)<2
            fileData{file}{i,2}=vals1{i}(delimIdx(1)+1:end);
        else
            fileData{file}{i,2}=vals1{i}(delimIdx(1)+1:delimIdx(2)-1);
            fileData{file}{i,3}=vals1{i}(delimIdx(2)+1);
        end
    end

    for i = 1 : size(fileData{file},1)
%         if ~strcmp(fileData{file}{1,2},'.')
%             func = fileData{file}{i,2};
%             fileData{file}{i,3} = func;
%             fileData{file}{i,2}=fileData{file}{i,1}(2:end);
%             fileData{file}{i,1}=fileData{file}{i,1}(1);
%         else
%             fileData{file}{i,3} = func;
%             fileData{file}{i,2}=fileData{file}{i,1}(2:end);
%             fileData{file}{i,1}=fileData{file}{i,1}(1);        
%         end     
                
        for j = 1 : length(fileData{file})
            delimiter2 = sprintf(' ');
            delimIdx2 = find(fileData{file}{j,2} == delimiter2);
            if delimIdx2
                fileData{file}{j,2}=fileData{file}{j,2}(1:delimIdx2-1);
            end            
            if strcmp(fileData{file}{j,3},'PD')
               fileData{file}{j,3} = 'P';
            end
            gt{file}(j)=fileData{file}{j,2}(end);
            if fileData{file}{j,3}
                pred{file}(j)=fileData{file}{j,3};
            else
                pred{file}(j)=' ';
            end
            score = score + ~strcmp(gt{file}(j), pred{file}(j));
            if strcmp(gt{file}(j),'T')
                scoreT = scoreT + ~strcmp(gt{file}(j), pred{file}(j));
            end
            if strcmp(gt{file}(j),'D')
                scoreD = scoreD + ~strcmp(gt{file}(j), pred{file}(j));
            end
        end  
        
    end
    
    fclose(fileID);
     clear vals vals1 line    
end

list1=setdiff(1:maxFiles,unique(ignore));

gtVals=[gt{list1}];
predVals=[pred{list1}];

predVals(predVals==' ')='T';

rules=PRstruct;

% modify confusionMat to handle this
confusion = zeros(3);
funcs=['T' 'P' 'D'];
for k = 1:3
    for k2 = 1:3
        confusion(k, k2) = confusion(k, k2) + sum((predVals == funcs(k)) .* (gtVals == funcs(k2)));
    end
end
 

for i = 1 : length(gtVals)
    if strcmp('T',gtVals(i))
        if strcmp(gtVals(i), predVals(i))
            rules.tpT = rules.tpT+1;
        elseif strcmp(predVals(i),'P')
            rules.fnT = rules.fnT+1;
            rules.fpP = rules.fpP+1;
        elseif strcmp(predVals(i),'D')
            rules.fnT = rules.fnT+1;
            rules.fpD = rules.fpD+1;
        end
    end
    if strcmp('P',gtVals(i))
        if strcmp(gtVals(i), predVals(i))
            rules.tpP = rules.tpP+1;
        elseif strcmp(predVals(i),'T')
            rules.fnP = rules.fnP+1;
            rules.fpT = rules.fpT+1;
        elseif strcmp(predVals(i),'D')
            rules.fnP = rules.fnP+1;
            rules.fpD = rules.fpD+1;        
        end          
    end
    if strcmp('D',gtVals(i))
        if strcmp(gtVals(i), predVals(i))
            rules.tpD = rules.tpD+1;
        elseif strcmp(predVals(i),'T')
            rules.fnD = rules.fnD+1;
            rules.fpT = rules.fpT+1;
        elseif strcmp(predVals(i),'P')
            rules.fnD = rules.fnD+1;
            rules.fpP = rules.fpP+1;
        end            
    end    
end

rules=calcPRF(rules);