function [exptSetup, action]=extractOlfDataStim(filename)
[headerline,schStart, data, textdata] = importOlfFile(filename);
data(1)=[];
textdata(headerline, :)=[];

exptSetup=struct;


% get date time
dateTime=sprintf('%s', textdata{1});
dateTime(1)=[];
dateTime(12)=[];
exptSetup = setfield(exptSetup, 'dateTime', dateTime);
scheduleID=sprintf('%s', textdata{2});
exptSetup = setfield(exptSetup, 'scheduleID', scheduleID);

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
% if ismember(events(i), 'CenterPokeIn') & ismember(events(i-2), 'CenterPokeIn')
% center=[center; i-1; i];
% end
%
% end


toDelete=[];
for i=1:length(newtrial_index)
   if ismember(events(newtrial_index(i)+2), 'NewTrial')||ismember(events(newtrial_index(i)+3), 'NewTrial'); %& ismember(events(newtrial_index(i)+1), 'Success');
        toDelete=[toDelete; newtrial_index(i)+1];
    end
end

toDelete=[toDelete; newtrial_index; finished_index; available_index; nextCue_index; odor];
events([toDelete], :) = [];
events(end,:) = [];
trialno([toDelete], :) = [];
time=zeros(length(events), 1);

for i=1:length(events)
        time(i)=str2num(events{i,2});
end

exptSetup = setfield(exptSetup,'trialNo',trialno);
exptSetup = setfield(exptSetup,'events',events);
exptSetup = setfield(exptSetup,'time',time);

%% get timesamps on relevant events

success=find (ismember(events, 'Success'));
failure=find (ismember(events, 'Failure'));
timeout=find(ismember(events, 'Timeout'));
reward = find(ismember(events, 'Reward'));

centerIn=time(find (ismember(events, 'CenterPokeIn')));
leftIn=time(find (ismember(events, 'LeftPokeIn')));
rightIn=time(find (ismember(events, 'RightPokeIn')));
allCenterOut=find (ismember(events, 'CenterPokeOut'));
centerOut=time(find (ismember(events, 'CenterPokeOut')));
leftOut=time(find (ismember(events, 'LeftPokeOut')));
rightOut=time(find (ismember(events, 'RightPokeOut')));


after=events(allCenterOut+1);
toDelete=[];
for i=1:length(after)
    if ismember(after(i), 'CenterPokeIn')==1||ismember(after(i), 'Abort')
        toDelete=[toDelete; i];
    end
end
    after(toDelete)=[];
centerStart=sum(find(ismember(after, 'TrialStarted')));
centerLeft=sum(find(ismember(after, 'LeftPokeIn')));
centerRight=sum(find(ismember(after, 'RightPokeIn')));
allCenterOut=centerStart+centerLeft+centerRight;
effectiveStart=centerStart/allCenterOut;
leftWaste=centerLeft/allCenterOut;
rightWaste=centerRight/allCenterOut;

    
abort=find(ismember(events, 'Abort'));
% all=[success; failure; timeout];
all=success;
all=sort(all);

successTrials=trialno(success);
failureTrials=trialno(failure);
rewardTrials=trialno(reward);
timeoutTrials=trialno(timeout);
allTrials=trialno(all);


ind=find(diff(rewardTrials)==0);

trialStarted=find(ismember(events, 'TrialStarted'));


% trialno=exptSetup.trialNo(trialStarted);

% make matrices for relevant time periods for each trial (marked by 'TrialStarted')
    

cvalid = zeros(length(allTrials),2);
travelTime=zeros(length(allTrials), 1);
side=zeros(length(allTrials), 2);
trialStartTime=zeros(length(allTrials), 1);
trailAvailTime=zeros(length(allTrials), 1);
rIn=zeros(length(allTrials), 1);
lIn=zeros(length(allTrials), 1);

trialno=exptSetup.trialNo(allTrials);


for i=1:length(all)
    c=[0, 0];
    j=0;
        for j=1:20
      
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
                    c=[c; 0, time(all(i)-j)];
                    continue
                case{'CenterPokeIn'}
                    c=[c; time(all(i)-j), 0];
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
        cvalid(i,1)=length(find(c(:, 1)));
        for t=2:length(c(:, 2))-1
        cvalid(i,2)=cvalid(i, 2)+c(t, 2)-c(t+1, 1);
        end
% travelTime(i)=-c(2, 2)+rIn(i)+lIn(i);
end



score=zeros(length(allTrials), 1);


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

    
exptSetup = setfield(exptSetup, 'trialNo', length(exptSetup.left));

    
toDelete=find(allTrials==length(exptSetup.left));
allTrials(toDelete)=[];
score(toDelete)=[];
cvalid(toDelete)=[];
travelTime(toDelete)=[];
side(toDelete, :)=[];

toDelete=find(rewardTrials==length(exptSetup.left));
action=struct;
action = setfield(action, 'score', score);
action = setfield(action, 'cvalid', cvalid);
action = setfield(action, 'travelTime', travelTime);
action = setfield(action, 'side', side);
action = setfield(action, 'validTrials', allTrials);
action = setfield(action, 'ITI', ITI);
% action = setfield(action, 'validTrialNo', trialno(end));
action = setfield(action, 'centerIn',centerIn);
action = setfield(action, 'leftIn', leftIn);
action = setfield(action, 'rightIn', rightIn);
action = setfield(action, 'allCenterOut', allCenterOut);
action = setfield(action, 'centerOut', centerOut);
action = setfield(action, 'rightOut', rightOut);
action = setfield(action, 'leftOut', leftOut);
action = setfield(action, 'effectiveStart', effectiveStart);
action = setfield(action, 'leftWaste', leftWaste);
action = setfield(action, 'rightWaste', rightWaste);

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
            if tline(1:3)=='#.N'
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