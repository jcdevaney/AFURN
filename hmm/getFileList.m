function [fileList fileData]=getFileList(dirList)


% Read files from project directory 
cd(dirList)
directory = dir(dirList);
j = 1;
for i = 4 : length(directory)
    fileList{j} = directory(i).name;
    j = j + 1;
end

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
    % ignore header
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
        fileData{file}{i,1}=vals1{i}(1:delimIdx-1);
        fileData{file}{i,2}=vals1{i}(delimIdx+1:end);
    end
    
    for i = 1 : size(vals1,2)
        for j = 1 : 2
            if fileData{file}{i,j}(1:2) == '16'% eighth note
                vals2{i,1}='1';
                vals2{i,1+j} = fileData{file}{i,j}(3:end);
            elseif fileData{file}{i,j}(1:2) == '1.'% whole note
                vals2{i,1}='8';
                vals2{i,1+j} = fileData{file}{i,j}(3:end);
            elseif fileData{file}{i,j}(1) == '1'% whole note
                vals2{i,1}='8';
                vals2{i,1+j} = fileData{file}{i,j}(2:end);
            elseif fileData{file}{i,j}(1:2) == '2.' % dotted half note
                vals2{i,1}='6';
                vals2{i,1+j} = fileData{file}{i,j}(3:end);
            elseif fileData{file}{i,j}(1) == '2' % half note
                vals2{i,1}='4';
                vals2{i,1+j} = fileData{file}{i,j}(2:end);
            elseif fileData{file}{i,j}(1:2) == '4.' % dotted quarter note
                vals2{i,1}='3';
                vals2{i,1+j} = fileData{file}{i,j}(3:end);
            elseif fileData{file}{i,j}(1) == '4'% quarter note
                vals2{i,1}='2';
                vals2{i,1+j} = fileData{file}{i,j}(2:end);
            elseif fileData{file}{i,j}(1:2) == '8.'% dotted eigth note
                vals2{i,1}='1';
                vals2{i,1+j} = fileData{file}{i,j}(3:end);
            elseif fileData{file}{i,j}(1) == '8'% eighth note
                vals2{i,1}='1';
                vals2{i,1+j} = fileData{file}{i,j}(2:end);
            end
        end
    end
    
    fileData{file}=vals2;
    
% Clean up files
%     for file = 1 : length(fileList)
        for j = 1 : length(fileData{file}(:,2))
            if strcmp(fileData{file}{j,2},'ac')
               fileData{file}{j,2} = fileData{file}{j+1,2};
            end
            if strcmp(fileData{file}{j,2},'I53')
               fileData{file}{j,2} = 'I';
            end  
            if strcmp(fileData{file}{j,2},'III63')
               fileData{file}{j,2} = 'III';
            end            
            if strcmp(fileData{file}{j,2},'V53')
               fileData{file}{j,2} = 'V';
            end
            if strcmp(fileData{file}{j,2},'V8')
               fileData{file}{j,2} = 'V';
            end   
            if strcmp(fileData{file}{j,2},'V75')
               fileData{file}{j,2} = 'V7';
            end             
            if strcmp(fileData{file}{j,2},'i53')
               fileData{file}{j,2} = 'i';
            end             
        end 
%     end  
    
    fclose(fileID);
    clear vals vals1 vals2 line
end

