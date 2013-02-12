
function [summary]=summarizeData(path)
folderlist= dir;

Odor1Perf=[];
Odor2Perf=[];
FreePref = [];
TimeOut = [];
NumberOfTrials=[];
MeanWaitTime = [];
MeanRewardAmount = [];
ExpectedRewardDelay =[];
ExpectedValveDuration=[];
maxValveDuration =[];
minValveDuration=[];
maxRewardDelay=[];
minRewardDelay=[];
longTrend=[];
bigTrend=[];
TrialByTrialScore=[];
longPerf=[];
shortPerf=[];
smallPerf=[];
bigPerf=[];
longTT=[];
shortTT=[];
bigTT=[];
smallTT=[];

longST=[];
shortST=[];
bigST=[];
smallST=[];


for n=1:length(folderlist)-2
    if length(folderlist(n+2).name)>3
    filename=folderlist(n+2).name
       try
        importfile(filename, 67);
       catch ME
           importfile(filename, 71);
       end
    [exptSetup(n)]=extractOlfData(textdata, data);
    action(n)  = computeTime(exptSetup(n));
    
    
    Odor1Perf=[Odor1Perf, length(find(action(n).results==3))./length(find(action(n).validOdors==1))];
    Odor2Perf=[Odor2Perf, length(find(action(n).results==2))./length(find(action(n).validOdors==0))];
    
    
    
    
    score = action(n).score;
    choice=action(n).choice;
    travelTime=action(n).travelTime;
    cvalid=action(n).cvalid;
    
    
    longPerf=[longPerf, length(find(score(find(choice==1))==2))/length(find(choice==1))];
    shortPerf=[shortPerf, length(find(score(find(choice==2))==2))/length(find(choice==2))];
    smallPerf=[smallPerf,  length(find(score(find(choice==3))==2))/length(find(choice==3))];
    bigPerf=[bigPerf,  length(find(score(find(choice==4))==2))/length(find(choice==4))];
    
    longTT=[longTT; travelTime(find(choice==1))];
    shortTT=[shortTT; travelTime(find(choice==2))];
    bigTT=[bigTT; travelTime(find(choice==4))];
    smallTT=[smallTT; travelTime(find(choice==3))];

    
    longST=[longST; cvalid(find(choice==1))];
    shortST=[shortST; cvalid(find(choice==2))];
    bigST=[bigST; cvalid(find(choice==4))];
    smallST=[smallST; cvalid(find(choice==3))];

    
    FreePref =[FreePref, length(find(action(n).sidedOdor==4))./(length(find(action(n).sidedOdor==4))+ length(find(action(n).sidedOdor==7)))];
    TimeOut =[TimeOut, length(action(n).timeout)./length(action(n).score)];
    AllPerf = (Odor1Perf+Odor2Perf)/2;
    TrialByTrialScore = [TrialByTrialScore; exptSetup(n).odor1Valve(action(n).validTrials), action(n).side, action(n).score, action(n).results, action(n).sidedOdor, action(n).choice];
   
    NumberOfTrials=[NumberOfTrials, length(action(n).score)];
    MeanWaitTime = [MeanWaitTime, mean(action(n).waitTime)];
    MeanRewardAmount = [MeanRewardAmount,  mean(action(n).rewardAmount)];
    ExpectedRewardDelay = [ExpectedRewardDelay, action(n).expectedRewardDelay];
    ExpectedValveDuration = [ExpectedValveDuration, action(n).expectedValveDuration];
    maxValveDuration = [maxValveDuration, action(n).maxValveDuration];
    minValveDuration = [minValveDuration, action(n).minValveDuration];
    maxRewardDelay = [maxRewardDelay, action(n).maxRewardDelay];
    minRewardDelay = [minRewardDelay, action(n).minRewardDelay];
    travelTime=[travelTime; action(n).travelTime];

    
    longTrend=[longTrend, action(n).longAroundPartition];
    bigTrend=[bigTrend,  action(n).bigAroundPartition];
    meanLongTrend=mean(longTrend, 2);
    meanBigTrend=mean(bigTrend, 2);
    stdDayLongTrend = std(longTrend, 1, 2);
    stdDayBigTrend = std(bigTrend, 1, 2);

    summary=struct;
    summary = setfield(summary, 'odor1Perf', Odor1Perf);
    summary = setfield(summary, 'odor2Perf', Odor2Perf);
    summary = setfield(summary, 'allPerf', AllPerf);
    summary = setfield(summary, 'freePref', FreePref);
    summary = setfield(summary, 'trialByTrialScore', TrialByTrialScore);
    summary = setfield(summary, 'timeOut', TimeOut);
    summary = setfield(summary, 'numberOfTrials', NumberOfTrials);
    summary = setfield(summary, 'meanWaitTime', MeanWaitTime);
    summary = setfield(summary, 'meanRewardAmount', MeanRewardAmount);
    summary = setfield(summary, 'expectedRewardDelay', ExpectedRewardDelay);
    summary = setfield(summary, 'expectedValveDuration', ExpectedValveDuration);
    summary = setfield(summary, 'maxValveDuration', maxValveDuration);
    summary = setfield(summary, 'minValveDuration', minValveDuration);
    summary = setfield(summary, 'maxRewardDelay', maxRewardDelay);
    summary = setfield(summary, 'minRewardDelay', minRewardDelay);
   
    
    summary = setfield(summary, 'bigTrend', bigTrend);   
    summary = setfield(summary, 'longTrend', longTrend);
    summary = setfield(summary, 'meanBigTrend', meanBigTrend);   
    summary = setfield(summary, 'meanLongTrend', meanLongTrend);
    summary = setfield(summary, 'stdDayLongTrend', stdDayLongTrend);   
    summary = setfield(summary, 'stdDayBigTrend', stdDayBigTrend);
   
    
    summary = setfield(summary, 'longPerf', longPerf);
    summary = setfield(summary, 'shortPerf', shortPerf);   
    summary = setfield(summary, 'smallPerf', smallPerf);
    summary = setfield(summary, 'bigPerf', bigPerf);
    
    summary = setfield(summary, 'longTT', longTT);
    summary = setfield(summary, 'shortTT', shortTT);
    summary = setfield(summary, 'bigTT', bigTT);
    summary = setfield(summary, 'smallTT', smallTT);
 
    summary = setfield(summary, 'longST', longST);
    summary = setfield(summary, 'shortST', shortST);
    summary = setfield(summary, 'bigST', bigST);
    summary = setfield(summary, 'smallST', smallST);

 
    end

    
end
end