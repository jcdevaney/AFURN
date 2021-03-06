function [GT,vpath1,vpath2]=runLaitzHMM(testData, trainData, pred, priorWeight,useDur)

for i = 1 : length(trainData)
    functions{i}=[trainData{i}{:,3}];
    for j = 1 : length(trainData{i})
        chords{i}{j}=[trainData{i}{j,2}];    
        durations{i}(j)=str2double([trainData{i}{j,1}]);
    end
end

chordTypes = unique([chords{:}]);
chordTypes = [chordTypes 'new'];
% durationTypes = unique([durations{:}]);
% chordTypes = [chordTypes 'new'];
allChordsTMP = [chords{:}];
allFunctionsTMP = [functions{:}];
allDurations = [durations{:}];

if useDur
    num=1;
    for i = 1 : length(allDurations)
        for j = 1 : allDurations(i)
            allChords{num}=allChordsTMP{i};
            allFunctions(num)=allFunctionsTMP(i);
            num=num+1;
        end
    end
else   
    allChords=allChordsTMP;
    allFunctions=allFunctionsTMP;
end

% states: tonic, predominant, dominant
% observations: chords
% observations: chords and inversions
% observations: chords and duration
% observations: chords and inversions and duration
stateOrdSeed = [1 2 3 1];
numStates = 1;
stateOrd = [repmat(stateOrdSeed(1:end-1),1,numStates) stateOrdSeed(end)];

% Structure of transitions
% T to T, T to PD, T to D
% PD to T, PD to PD, PD to D
% D to T, D to PD, D to D
TT = 0;
TP = 0;
TD = 0;
PT = 0;
PP = 0;
PD = 0;
DT = 0;
DP = 0;
DD = 0;

% tally the transitions between states
for i = 1 : length(trainData)
    functions{i}=[trainData{i}{:,3}];
    durations{i}=[trainData{i}{:,1}];
    num=1;
    for j = 1 : length(trainData{i})
        if useDur
            for count = 0 : eval(durations{i}(j))-1
                chords{i}{num}=[trainData{i}{j,2}]; 
                num=num+1;
            end
        else
            chords{i}{j}=[trainData{i}{j,2}]; 
        end
    end
    
% useDur
% sum(durations{i})
% size(size(chords{i}))
% pause

    for j = 1 : length(functions{i})-1
        if functions{i}(j) == 'T' && functions{i}(j+1) == 'T'
            TT = TT + 1;
        end
        if functions{i}(j) == 'T' && functions{i}(j+1) == 'P'
            TP = TP + 1;        
        end
        if functions{i}(j) == 'T' && functions{i}(j+1) == 'D'
            TD = TD + 1;           
        end     
        if functions{i}(j) == 'P' && functions{i}(j+1) == 'T'
            PT = PT + 1;           
        end
        if functions{i}(j) == 'P' && functions{i}(j+1) == 'P'
            PP = PP + 1;          
        end
        if functions{i}(j) == 'P' && functions{i}(j+1) == 'D'
            PD = PD + 1;       
        end 
        if functions{i}(j) == 'D' && functions{i}(j+1) == 'T'
            DT = DT + 1;
        end
        if functions{i}(j) == 'D' && functions{i}(j+1) == 'P'
            DP = DP + 1;           
        end
        if functions{i}(j) == 'D' && functions{i}(j+1) == 'D'
            DD = DD + 1;          
        end         
    end
end

% combine tallies into a transition matrix seed
transValsT = [TT TP TD];
transValsP = [PT PP PD];
transValsD = [DT DP DD];

transMatValsT = transValsT/sum(transValsT);
transMatValsP = transValsP/sum(transValsP);
transMatValsD = transValsD/sum(transValsD);

% {tonic, predominant, dominant}
transseed=zeros(3,3);
transseed(1,1)=transMatValsT(1);
transseed(1,2)=transMatValsT(2);
transseed(1,3)=transMatValsT(3);
transseed(2,1)=transMatValsP(1);
transseed(2,2)=transMatValsP(2);
transseed(2,3)=transMatValsP(3);
transseed(3,1)=transMatValsD(1);
transseed(3,2)=transMatValsD(2);
transseed(3,3)=transMatValsD(3);

% map the functions to the chords and durations
% resulting tables gives the number of time each chord 
% or duration occurs with a function
for j = 1 : 3
    for i = 1 : length(chordTypes)
        chordFunctionMap(i,j)=0;
    end
%     for i = 1 : length(durationTypes)
%         durationFunctionMap(i,j)=0;
%     end
end

for i = 1 : length(chordTypes)
    for j = 1 : length(allChords)
        if strcmp(allChords{j}, chordTypes{i})
            if allFunctions(j) == 'T'
                chordFunctionMap(i,1)=chordFunctionMap(i,1)+1;
            end
            if allFunctions(j) == 'P'
                chordFunctionMap(i,2)=chordFunctionMap(i,2)+1;
            end
            if allFunctions(j) == 'D'
                chordFunctionMap(i,3)=chordFunctionMap(i,3)+1;
            end
        end
    end
end

% for i = 1 : length(durationTypes)
%     for j = 1 : length(allDurations)
%         if strcmp(allDurations(j), durationTypes{i})
%             if allFunctions(j) == 'T'
%                 durationFunctionMap(i,1)=durationFunctionMap(i,1)+1;
%             end
%             if allFunctions(j) == 'P'
%                 durationFunctionMap(i,2)=durationFunctionMap(i,2)+1;
%             end
%             if allFunctions(j) == 'D'
%                 durationFunctionMap(i,3)=durationFunctionMap(i,3)+1;
%             end
%         end
%     end
% end

% initialize starting state
startingState = [1; zeros(3,1)];

%%%%%%%%%%%%%%% RUN HMM %%%%%%%%%%%%%%%%%%%%%%%%%%%

% set up transition matrix
trans = transseed;
trans(1,4)=0;
trans(3,4)=trans(3,1);
trans(3,1)=0;
trans(4,:)=0;
trans(4,4)=1;

% create a matrix of the chord occurances for each state
% normalized so that all of the columns (states) sum to 1
chordCount=chordFunctionMap;
% durCount=durationFunctionMap;
for i = 1 : 3
    chordCount(:,i)=chordCount(:,i)/sum(chordCount(:,i));
%     durCount(:,i)=durCount(:,i)/sum(durCount(:,i));
end
% add an extra column for the closing tonic
chordCount=[chordCount, chordCount(:,1)];
% durCount=[durCount, durCount(:,1)];

for ex = 1 : length(testData)

%     num=1;
    num1=1;
    for i = 1 : length(testData{ex})
%         for j = 1 : eval(testData{ex}{i,1})
            if useDur            
                obsDur{i}=eval(testData{ex}{i,1});
            else
                obsDur{i}=1;
            end
            obsChord(num1:num1+obsDur{i}-1)=repmat(testData{ex}(i,2),1,obsDur{i});
            tmp=testData{ex}(i,3);
            gts(num1:num1+obsDur{i}-1)=repmat(tmp{1}(1),1,obsDur{i});
            prior(num1:num1+obsDur{i}-1)=repmat(pred{ex}(i),1,obsDur{i});
            
%             gts{num}=testData{ex}{i,3};
%             prior{num}=pred{ex}(i);
            
            num1=num1+obsDur{i};
%                 for count = 0 : eval(obsDur{num})-1
%                     obsChord{num1}=testData{ex}{i,2};
%                     num1=num1+1;
%                 end                
%             else
%                 obsChord{num1}=testData{ex}{i,2};
%                 num1=num1+1;
%             end
%             num=num+1;
%         end
    end

    for i = 1 : length(prior)
        if strcmp(prior(i),'T')
            PR{ex}(i) = 1;
        elseif strcmp(prior(i),'P')
            PR{ex}(i) = 2;
        elseif strcmp(prior(i),'D')
            PR{ex}(i) = 3;
        else
            PR{ex}(i) = 1;
        end
    end    
    
    for i = 1 : length(gts)
        if strcmp(gts(i),'T')            
            GT{ex}(i) = 1;
        end
        if strcmp(gts(i),'P')
            GT{ex}(i) = 2;
        end
        if strcmp(gts(i),'D')
            GT{ex}(i) = 3;
        end
    end
        
    for i = 1 : length(obsChord)
        for j = 1 : length(chordTypes)
            if strcmp(obsChord{i},chordTypes(j))
                dataChord{ex}(i) = j;
            end           
        end 
        if length(dataChord{ex}) < i
            dataChord{ex}(i)=length(chordTypes);
        end
        %% need to put in a catch for III
        
%         for j = 1 : length(durationTypes)
%             if strcmp(obsDur{i},durationTypes(j))
%                 dataDur{ex}(i) = j;
%             end
%         end 
    end
    
    alldataChord{ex}=dataChord{ex};  
%     alldataDur{ex}=dataDur{ex};  
    allGT{1}{ex}=GT{ex};
    
    % clean up non entries
%     GT{ex}=GT{ex}(dataChord{ex}~=0);
%     PR{ex}=PR{ex}(dataChord{ex}~=0);    
%     dataChord{ex}=dataChord{ex}(dataChord{ex}~=0);
%     dataDur{ex}=dataDur{ex}(dataChord{ex}~=0);

   
    %calculate the observation likelihood for chords and durations
    chordObsLike = multinomial_prob(dataChord{ex}, chordCount');
%     durObsLike = multinomial_prob(dataDur{ex}, durCount');
    
    % prior
    tmpMat=(zeros(size(chordObsLike)));
    for i = 1 : length(PR{ex})
         tmpMat(PR{ex}(i),i)=priorWeight;
    end
    
    obsMat=chordObsLike+tmpMat;

    %run verterbi on the combination observation likelihood

    vpath1{ex}=viterbi_path(startingState, trans, chordObsLike);%.*durObsLike);
    vpath2{ex}=viterbi_path(startingState, trans, obsMat);%.*durObsLike);
    
    for i = 1 : length(vpath1{ex})
        if vpath1{ex}(i) == 4
           vpath1{ex}(i) = 1;
        end
        if vpath2{ex}(i) == 4
           vpath2{ex}(i) = 1;
        end        
    end    
    
    clear obsChord gts prior tmpMat obsDur;

end

clear data;