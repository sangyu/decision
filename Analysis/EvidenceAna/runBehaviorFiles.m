
function runBehaviorFiles(micetoana, daystoana, matFileName)

    
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
          files=1;
          if length(fileLocator)>1
            fprintf(['There are ' num2str(length(fileLocator)) ' files for this day: \n'])
              for i=1:length(fileLocator)
              fprintf([D(fileLocator(i)+2).name, '  ---   ' num2str(i), '\n'])
              end
            files=input('which file(s) ');    
          end
            
            for x=files
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
                e.centerPokeDelay(a.validTrials),abort, e.secondaryCueDelay(a.validTrials), e.odor1Valve(a.validTrials)];
                odorOnset=e.centerPokeDelay(end);
                valveSwitch=e.secondaryCueDelay(end)+e.centerPokeDelay(end);
                qualifying=e.cueSamplingTime(end)+e.centerPokeDelay(end);
                for i=1:length(e.events)
                    time(i)=str2num(e.events{i,2})';
                end
                trialAvailTime=[time(ismember(e.events(:, 1), 'TrialAvailable'))', find(ismember(e.events(:, 1), 'TrialAvailable'))];
                centerPokesAvail=[];
                stim=find(dataMouse(:, 10));
                trialno=e.trialNo(1:end-1);
                if a.centerIn(1)>a.centerOut(1)
                    a.centerOut(1)=[];
                end
                for i=1:length(trialAvailTime(:, 1))      
                    try
                        centerInd=intersect(find(a.centerIn>trialAvailTime(i, 1)), find(a.centerIn<trialAvailTime(i, 1)+5));
                        centerInd=centerInd(1);
                        centerPokesAvail=[centerPokesAvail; a.centerOut(centerInd)-a.centerIn(centerInd), ismember(trialno(trialAvailTime(i, 2)), stim), dataMouse(trialno(trialAvailTime(i, 2)), 16), trialno(trialAvailTime(i, 2));];
                    end
                end
            end

            assignin('base', ['data_', num2str(mouse), '_', datestr(dateRun, 'ddmmmyyyy')], dataMouse);
            assignin('base', ['centerPokesAvail_', num2str(mouse), '_', datestr(dateRun, 'ddmmmyyyy')], centerPokesAvail);
            
        end
    end
    dateRange(dd)=dateRun;
end
    
    
    
    a=who;
    ind=[];
    for i=1:length(a)
        if mean(ismember('data_', a{i} ))==1
            ind=[ind; i];
        end
    end
    save(matFileName, a{ind})
return

