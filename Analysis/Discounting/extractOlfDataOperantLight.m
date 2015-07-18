



%% ++++++++ Extraction+++++++ 
function [exptSetup, action, events]=extractOlfDataOperantLight(filename)
    
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
trainingSchedule=sprintf('%s', textdata{2});
mouseID=sprintf('%s', textdata{4});
rightLEDLine=sprintf('%s', textdata{20});

% mouseID(1:10)=[];
exptSetup = setfield(exptSetup, 'mouseID', mouseID);
exptSetup = setfield(exptSetup, 'trainingSchedule', trainingSchedule);
exptSetup = setfield(exptSetup, 'rightLEDLine', str2num(rightLEDLine(16:end)));

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
    catch me;
    end
    try
        entry=schedule{i};
        markers = [ find(entry =='.', 1), find(entry == ':')];
        varname= sprintf('%s', entry(markers(1)+1:markers(2)-1));
        exptSetup = setfield(exptSetup,varname,str2num(entry(markers(2)+2:end)));
    catch me;
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
nullsuccess_index = find(ismember(events, 'NullSuccess'));
nullfailure_index = find(ismember(events, 'NullFailure'));
punishmentinterval_index = find(ismember(events, 'PunishmentInterval'));
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

toDelete=[toDelete; newtrial_index; finished_index;  nextCue_index; odor; nullsuccess_index; nullfailure_index;punishmentinterval_index];
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
abort =find(ismember(events, 'Abort'));
reward_time=time(reward)
leftIn=time(find (ismember(events, 'LeftPokeIn')));
leftOut=time(find (ismember(events, 'LeftPokeOut')));
trialStartTime=time(find(ismember(events, 'TrialStarted')))
all=[success; failure; timeout];
% all=success;
all=sort(all);

successTrials=trialno(success);
failureTrials=trialno(failure);
rewardTrials=trialno(reward);
timeoutTrials=trialno(timeout);
allTrials=trialno(all);


action=struct;
action = setfield(action, 'trialStartTime', trialStartTime);
action = setfield(action, 'rewardTime', reward_time);
action = setfield(action, 'leftIn', leftIn);
action = setfield(action, 'leftOut', leftOut);

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

