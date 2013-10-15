



%% ++++++++ Extraction+++++++ 
function [exptSetup, action]=extractOlfData(filename)
    
[headerline,schStart, data, textdata] = importOlfFile(filename);
data(1)=[];
textdata(headerline, :)=[];

exptSetup=struct;


% get date time
dateTime=sprintf('%s', textdata{1});
dateTime(1)=[];
dateTime(12)=[];
exptSetup = setfield(exptSetup, 'dateTime', dateTime);

%get mouseID
mouseID=sprintf('%s', textdata{4});
% mouseID(1:10)=[];
exptSetup = setfield(exptSetup, 'mouseID', mouseID);

% Clean up data 
% scheduleData
schedule = textdata(schStart:headerline-4, :);
schedule = schedule(:,1);
schedule = cellstr(schedule);

% evaluate the input numbers for all trials, store them into various
% scheduleData.parameters



for i=1:length(schedule)
    try
        entry=schedule{i};
        markers =[];
        markers = [ find(entry =='.', 1), find(entry == ':'), find(entry == '['), find(entry== ']')];
        varname= sprintf('%s', entry(markers(1)+1:markers(2)-1));
        exptSetup = setfield(exptSetup,varname,eval(entry(markers(3):markers(4))));
    catch me
    end
    try
        entry=schedule{i};
        markers = [ find(entry =='.', 1), find(entry == ':')];
        varname= sprintf('%s', entry(markers(1)+1:markers(2)-1));
        exptSetup = setfield(exptSetup,varname,str2num(entry(markers(2)+2:end)));
    catch me
    end
end
        l=exptSetup.leftValveDuration;
        r=exptSetup.rightValveDuration;
        leftRewardSizeTotal=sum(l, 2);
        rightRewardSizeTotal=sum(r, 2);

        exptSetup = setfield(exptSetup, 'rightRewardSizeTotal', rightRewardSizeTotal);
        exptSetup = setfield(exptSetup, 'leftRewardSizeTotal', leftRewardSizeTotal);

%so there's a string array of events called "events" and a
%trialno array called "trialno" with corresponding indices

events = textdata(headerline:end, :);
%convert cell array into an array of strings and get rid of NewTrials
cellstr(events);

trialno = [1; data];
events(:,3) = [];
newtrial_index = find (ismember(events, 'NewTrial'));
nextCue_index = find(ismember(events, 'NextCue'));
finished_index = find(ismember(events, 'TrialFinished'));
available_index = find(ismember(events, 'TrialAvailable'));
if max(available_index)>length(trialno)
    available_index(end)=[];
end
odor=[];
for i=1:length(events)
    if length(char(events(i, 2)))>10
    odor=[odor; i];
    end
end
% 
% center=[];
% %events([newtrial_index], :) = [];
% for i=3:length(events)
%     if ismember(events(i), 'CenterPokeIn') & ismember(events(i-2), 'CenterPokeIn')
%         center=[center; i-1; i];
%     end
% 
% end


toDelete=[];
for i=1:length(newtrial_index)
   if ismember(events(newtrial_index(i)+2), 'NewTrial')||ismember(events(newtrial_index(i)+3), 'NewTrial'); %& ismember(events(newtrial_index(i)+1), 'Success');
        toDelete=[toDelete; newtrial_index(i)+1];
    end
end

toDelete=[toDelete; newtrial_index; finished_index;  nextCue_index; odor];
events([toDelete], :) = [];
events(end,:) = [];
if length(trialno)<toDelete(end)
    toDelete(end)=[];
end

trialno([toDelete], :) = [];
time=zeros(length(events), 1);

for i=1:length(events)
        time(i)=str2num(events{i,2});
end

exptSetup = setfield(exptSetup,'trialNo',trialno);
exptSetup = setfield(exptSetup,'events',events);
exptSetup = setfield(exptSetup,'time',time);

%% get timesamps on relevant events

success=find(ismember(events, 'Success'));
failure=find(ismember(events, 'Failure'));
timeout=find(ismember(events, 'Timeout'));
reward =find(ismember(events, 'Reward'));

centerIn=time(find (ismember(events, 'CenterPokeIn')));
leftIn=time(find (ismember(events, 'LeftPokeIn')));
rightIn=time(find (ismember(events, 'RightPokeIn')));
centerOut=find (ismember(events, 'CenterPokeOut'));
afterC=events(centerOut+1);
toDelete=[];
for i=1:length(afterC)
    if ismember(afterC(i), 'CenterPokeIn')==1||ismember(afterC(i), 'Abort')
        toDelete=[toDelete; i];
    end
end
    afterC(toDelete)=[];
afterR=events(reward+1);
beforeS=events(success-1);
compareRS=zeros(1, length(beforeS));
for i=1:length(afterR)
    aR=char(afterR(i));
    bS=char(beforeS(i));
    if aR(1)==bS(1)
        compareRS(i)=1;
    end
end
rewardLeftOut=length(find(ismember(afterR, 'LeftPokeOut')));

rewardRightOut=length(find(ismember(afterR, 'RightPokeOut')));

rewardCollected=mean(compareRS);
rewardPokeOut=(rewardLeftOut+rewardRightOut)/length(reward);

centerStart=length(find(ismember(afterC, 'TrialStarted'))); 
centerLeft=length(find(ismember(afterC, 'LeftPokeIn'))); 
centerRight=length(find(ismember(afterC, 'RightPokeIn'))); 
allCenterOut=centerStart+centerLeft+centerRight;
effectiveStart=centerStart/allCenterOut;
leftWaste=centerLeft/allCenterOut;
rightWaste=centerRight/allCenterOut;

    
abort=find(ismember(events, 'Abort'));
all=[success; failure; timeout];
% all=success;
all=sort(all);

successTrials=trialno(success);
failureTrials=trialno(failure);
rewardTrials=trialno(reward);
timeoutTrials=trialno(timeout);
allTrials=trialno(all);

ind=find(diff(rewardTrials)==0);
rewardTrials(ind+1)=rewardTrials(ind)+1;
rewardTrials=rewardTrials-1;
rewardTrials(1)=1;

timeMatrix=zeros(max(trialno)-1, 2);
timeMatrix(successTrials, 1)=time(success);

timeMatrix(rewardTrials, 2)=time(reward);
timeMatrix(find(timeMatrix(:, 2)==0), 1)=0;

timeMatrix(find(timeMatrix(:, 2)==0), :)=[];

rewardDelay=timeMatrix(:, 2)-timeMatrix(:, 1);

trialStarted=find(ismember(events, 'TrialStarted'));
trialAvailable=find(ismember(events, 'TrialAvailable'));


% trialno=exptSetup.trialNo(trialStarted);

% make matrices for relevant time periods for each trial (marked by 'TrialStarted')
    

cvalid = zeros(length(allTrials),2);
travelTime=zeros(length(allTrials), 1);
reactionTime=zeros(length(allTrials), 1);
side=zeros(length(allTrials), 2);
trialStartTime=zeros(length(allTrials), 1);
trialAvailTime=zeros(length(allTrials), 1);
rIn=zeros(length(allTrials), 1);
lIn=zeros(length(allTrials), 1);

trialno=exptSetup.trialNo(allTrials);


for i=1:length(all)
    c=[];
        for j=1:25
      
            try
            event=events{all(i)-j, 1};
                switch event 
                case{'LeftPokeIn'}
                   if j<3
                    side(i, 1)= 1;
                    lIn(i)=time(all(i)-j);
                   end
                    continue 
                case{'RightPokeIn'}
                    if j<3
                    side(i, 2)=1;
                    rIn(i)=time(all(i)-j);
                    end
                    continue
                case{'CenterPokeOut'}
                    cVout=time(all(i)-j);
                    continue
                case{'CenterPokeIn'}
                    cVin=time(all(i)-j);
                    c=[cVin, cVout; c];
                    continue
                 case {'TrialStarted'}
                    trialStartTime(i)=time(all(i)-j);                    
                   continue
                 case{'TrialAvailable'}
                    trialAvailTime(i)=time(all(i)-j);                                         
                    break
                end    
            catch ME
            end
        end
        cvalid(i, 1)=length(c(:, 1));
        cvalid(i, 2)=sum(diff(c, 1, 2));
        travelTime(i)=-c(end)+rIn(i)+lIn(i);
        reactionTime(i)= c(end)-max(trialAvailTime(i), c(1));
end



score=zeros(length(allTrials), 1);
score(successTrials)=1;
score(failureTrials)=0;
score(timeoutTrials)=-1;




if length(score)<length(trialno)
   side(end)=[];
   travelTime(end)=[];
   cvalid(end)=[];
            
end

trialStartTime=time(trialStarted);
ITI=diff(trialStartTime);

% ++++++++++ Lookup Table++++++++++++++++++
% Sides: left(-1), right(1)
% score: Success (1), Failure (0)
% exptSetup.left: Odor1(1), Odor2 (0), odor3(2)
% ++++++++++ Lookup Table++++++++++++++++++

rewardDelay=round(rewardDelay*100)/100;
    
exptSetup = setfield(exptSetup, 'trialNo', length(exptSetup.left));

    
toDelete=find(allTrials==length(exptSetup.left));
allTrials(toDelete)=[];
score(toDelete)=[];
cvalid(toDelete)=[];
travelTime(toDelete)=[];
side(toDelete, :)=[];

travelTime(timeoutTrials)=0;
reactionTime(timeoutTrials)=0;
toDelete=find(rewardTrials==length(exptSetup.left));
rewardTrials(toDelete)=[];
rewardDelay(length(rewardTrials)+1:end)=[];

action=struct;
action = setfield(action, 'score', score);
action = setfield(action, 'cvalid', cvalid);
action = setfield(action, 'travelTime', travelTime);
action = setfield(action, 'reactionTime', reactionTime);
action = setfield(action, 'trialAvailTime', trialAvailTime);
action = setfield(action, 'trialStartTime', trialStartTime);
action = setfield(action, 'side', side);
action = setfield(action, 'validTrials', allTrials);
action = setfield(action, 'rewardTrials', rewardTrials);
action = setfield(action, 'rewardDelay', rewardDelay);
action = setfield(action, 'ITI', ITI);
% action = setfield(action, 'validTrialNo', trialno(end));
action = setfield(action, 'centerIn',centerIn);
action = setfield(action, 'leftIn', leftIn);
action = setfield(action, 'rightIn', rightIn);
action = setfield(action, 'allCenterOut', allCenterOut);
action = setfield(action, 'effectiveStart', effectiveStart);
action = setfield(action, 'leftWaste', leftWaste);
action = setfield(action, 'rightWaste', rightWaste);
action = setfield(action, 'rewardCollected', rewardCollected);
action = setfield(action, 'rewardPokeOut', rewardPokeOut);


end








function [headerline,schStart, data, textdata] = importOlfFile(filename)
        fid=fopen(filename);
        headerline=1;
        pound=1;
        schStart=0;
        while pound==1
            tline=fgets(fid);
            pound = tline(1)=='#';
            headerline=headerline+1;
            try
            if tline(1:4)=='#.LR'
            schStart=headerline;
            end
            catch me
            end
        end

        newdata = importdata(filename, ',', headerline);
        schStart=schStart(find(schStart));
        % Create new variables in the base workspace from those fields.
        vars = fieldnames(newdata);
        for i = 1:length(vars)
            assignin('caller', vars{i}, newdata.(vars{i}));
        end
            data=newdata.data;
            textdata=newdata.textdata;
fclose('all');
            return
    end

