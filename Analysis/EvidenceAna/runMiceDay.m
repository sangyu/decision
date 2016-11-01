function runMiceDay(micetoana, daystoana, startEnd)

cutLeftOff=0;
samplingTimeBinWidth=0.05;
maxSamplingBin=0.8;
minSamplingBin=0;
normalize=0;

[info, D]=readBehaviorDataDirectory;

dateRange=[];

if daystoana==0
    daystoana=sort(unique(info(:, 2)));
end

if micetoana==0
    micetoana=sort(unique(info(:, 1)));
end


for dd=1:length(daystoana)
    for mm=1:length(micetoana)
        try
            dataMouse=[];
            day=daystoana(dd);
            mouse=micetoana(mm);
                    fileLocator=info(intersect(find(info(:, 1)==mouse), find(info(:, 2)==day)), 3);
    %                 for x=1:length(fileLocator)
            for x=1
                filename= D(fileLocator(x)+2).name
                [e, a]=extractOlfDataEvi(filename);
                side=a.side(:, 1);
                dateRun=datenum(e.dateTime(1:11), 'dd-mmm-yyyy');
                abort=side*0;
                abort(unique(a.abortTrials))=1;
                abort=(abort(1:length(side)));
                
                dataMouse=[dataMouse;e.left(a.validTrials), side, a.score(a.validTrials),...
                a.reactionTime, a.reactionTimeIncAbort, a.travelTime, ...
                dateRun*ones(length(a.validTrials), 1), mouse*ones(length(a.validTrials), 1), ...
                e.cueSamplingTime(a.validTrials),e.cueOnTTL(a.validTrials), ...
                a.abortTimesByTrial+1, e.preTrialDelay(1)+a.trialStartTime-a.trialAvailTime+a.reactionTime, ...
                e.centerPokeDelay(a.validTrials),abort, e.secondaryCueDelay(a.validTrials)];
                odorOnset=e.centerPokeDelay(end);
                valveSwitch=e.secondaryCueDelay(end)+e.centerPokeDelay(end);
                qualifying=e.cueSamplingTime(end)+e.centerPokeDelay(end);
                data=dataMouse(startEnd(1):min([startEnd(2), length(dataMouse(:, 1))]), :);

            end

            assignin('base', ['data_', num2str(mouse), '_', num2str(dateRun)], data);
        end
    end
    dateRange(dd)=dateRun;
end
return
