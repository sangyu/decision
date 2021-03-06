clear;
close all;
close all hidden;
global strongRed weakRed blue green gray purple lookback lookforward

strongRed=[    0.7522    0.0329    0.2];
weakRed=strongRed+0.2;
lookback=10;
lookforward=40;
blue=[0 .5 .8];
green=[0 .7 .4];
gray=[0.8, 0.8, 0.8];
purple=[0.5 0 .8];


datapath=input('data path?', 's')

cd (datapath)
try
mkdir('new data');
catch me
end

folderlist=dir;
for i=1:length(dir)
    if length(folderlist(i).name)>15
       movefile([datapath, '/', folderlist(i).name], [datapath, '/new data']);
    end
end


for i=1:length(dir)
    if strcmp(folderlist(i).name, '.DS_Store')==1
        delete ('.DS_Store');
    end
end

cd ([datapath '/new data'])
newFolderlist=dir;

for i=1:length(newFolderlist)
    if length(newFolderlist(i).name)>=3
        mouseName{i-2}=newFolderlist(i).name(4:6);
        mkdir ([datapath, '/', mouseName{i-2}]);
        movefile([datapath, '/new data/', newFolderlist(i).name], [datapath, '/', mouseName{i-2}]);
    end
end
slash=find(datapath=='/');
slash=slash(end);
batchname=datapath(slash+1:end);

datenow=datestr(now);
mkdir( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/' batchname,datenow '_mat/exptSetup/' ])
mkdir( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/'  batchname,datenow '_mat/summary/' ])
mkdir( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/'  batchname,datenow '_fig' ])
mkdir(['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/'  batchname,datenow '_mat/analysis/'])

for n=1:length(folderlist)-2
   if strcmp(folderlist(n+2).name, 'new data')==0 
       folderlist(n+2).name
    [exptSetup, action, summary]=runAllFolders([datapath,'/', folderlist(n+2).name]);
    save( ['mat/' exptSetup(end).mouseID,' ' exptSetup(end).dateTime 'exptSetup-action-summary'], 'action',  'exptSetup', 'summary');
    save( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/'  batchname,datenow '_mat/exptSetup/', exptSetup(end).mouseID,'_',exptSetup(end).dateTime 'exptSetup-action-summary'], 'action', 'exptSetup', 'summary')
   end
end







mkdir (['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/ScatterPlots/']);
mkdir (['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/',exptSetup(1).mouseID]);
mkdir (['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/ScatterPlots/' batchname, datenow]);
mkdir (['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/'  batchname,datenow '_fig', '/',  exptSetup(1).mouseID]);




% run the .mat files
cd( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/'  batchname,datenow '_mat/exptSetup']);

%%
f=dir;
figure
for i=3:length(f)
file=f(i).name;
    load (file)
    w=15;
    aveSide=zeros(length(summary.side)-w,1);
    trial=[summary.cumValidTrials(w+1:end)];
    for i=w+1:length(summary.side)
        aveSide(i-w)=mean(summary.side(i-w:i));
    end
   
    try
    
    subplot(211)
    hold on
    plot(summary.cumValidTrials,summary.leftRewardSizeTotal(summary.cumValidTrials)*100, 'Color', green, 'LineWidth', 1.5)
    plot(summary.cumValidTrials,summary.rightRewardSizeTotal(summary.cumValidTrials)*100, 'Color', blue, 'LineWidth', 1.5)
    legend('Left Number', 'Right Number','Location','SouthEast')
    for i=1:length(summary.validTrialNo)
        day=sum(summary.validTrialNo(1:i));
        line([day, day], [0 8], 'Color',gray)
    end
    ylim([0 8])
    subplot(212)
    hold on
    plot(summary.cumValidTrials, summary.side, 'x', 'Color', weakRed)
%     plot((summary.leftRewardSizeTotal(summary.cumValidTrials)+summary.rightRewardSizeTotal(summary.cumValidTrials))*20, 'Color', purple)
%     plot((-summary.leftRewardSizeTotal(summary.cumValidTrials)+summary.rightRewardSizeTotal(summary.cumValidTrials))*20, 'Color', green)
    plot(summary.cumValidTrials,summary.leftRewardDelay(summary.cumValidTrials)/2, 'Color', green, 'LineWidth', 1.5)
    plot(summary.cumValidTrials,summary.rightRewardDelay(summary.cumValidTrials)/2, 'Color', blue, 'LineWidth', 1.5)
    
    plot(trial, aveSide)
    line([0 length(summary.rightRewardSizeTotal(summary.cumValidTrials))], [0 0], 'Color',gray)
    title(file(1:3))
    for i=1:length(summary.validTrialNo)
        day=sum(summary.validTrialNo(1:i));
        line([day, day], [-2 3], 'Color',gray)
    end
    ylim([-2 3])
    catch me
    end
    
    pause
clf
end
%%










popLongTrend=[];
popBigTrend=[];
trialByTrial=[];
travelTime=[];
cvalid=[];
folderlist=dir;
perf=[];
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

nLongT=[];
nShortT=[];
nBigT=[];
nSmallT=[];

nLongS=[];
nShortS=[];
nBigS=[];
nSmallS=[];
mouseID=[];
id1=[];
waitTime=[];
rewardAmount=[];

activityC=[];
activityL=[];
activityR=[];


ttAP=[];
stAP=[];

longTrend=[];
bigTrend=[];

perfind=[];

perfdim=20;
performance=zeros(20, 1);


% ccvalid=[];
% icvalid=[];
mccvalid=zeros(20, 1);
micvalid=zeros(20, 1);

% try

for n=3:length(folderlist)
    load (folderlist(n).name)
    summary=summarizeData(exptSetup, action);
    save( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/'  batchname,datenow '_mat/summary/', exptSetup(end).mouseID,'_',exptSetup(end).dateTime 'summary'], 'action', 'exptSetup', 'summary')

%      try
% % plotForDay(action(end), exptSetup(end))
% % saveas(figure(1), ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/ScatterPlots/', datenow, '/', exptSetup(1).mouseID, '_General'],'fig') 
% % saveas(figure(1), ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/', datenow '_fig', '/' ,  exptSetup(1).mouseID, '_General'],'fig') 
% % close all
% plotComposite(exptSetup, summary)
% saveas(figure(1), ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/ScatterPlots/',  batchname,datenow, '/' , exptSetup(1).mouseID, '_Overall_Scatter Plots'],'fig') 
% saveas(figure(1), ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/',  batchname,datenow '_fig',  '/' , exptSetup(1).mouseID, '_Overall_Scatter Plots'],'fig') 
% %pause
% close all
%     catch ME
%      end
popLongTrend=[popLongTrend, summary.meanLongTrend];
popBigTrend=[popBigTrend, summary.meanBigTrend];
longTrend=[longTrend, summary.longTrend];
bigTrend=[bigTrend, summary.bigTrend];


    if perfdim>length(summary.allPerf)
    perfdim=length(summary.allPerf);
    end
performance=[performance( 1:perfdim,:), summary.allPerf(1:perfdim)];
mccvalid=[mccvalid( 1:perfdim,:), summary.mccvalid(1:perfdim)];
micvalid=[micvalid( 1:perfdim,:), summary.micvalid(1:perfdim)];
% 
% ccvalid=[ccvalid; summary.ccvalid];
% icvalid=[icvalid; summary.icvalid];

 perf=[perf; summary.allPerf(end)]
 a=find(summary.allPerf==summary.allPerf(end));
 perfind=[perfind, a(end)];
 
    trialByTrial=[trialByTrial; summary.trialByTrialScore ];
    longTT=[longTT;mean(summary.longTT), std(summary.longTT)];
    shortTT=[shortTT;mean(summary.shortTT), std(summary.shortTT)];
    bigTT=[bigTT;mean(summary.bigTT), std(summary.bigTT)];
    smallTT=[smallTT;mean(summary.smallTT), std(summary.smallTT)];

    longST=[longST;mean(summary.longST), std(summary.longST)];
    shortST=[shortST;mean(summary.shortST), std(summary.shortST)];
    bigST=[bigST;mean(summary.bigST), std(summary.bigST)];
    smallST=[smallST;mean(summary.smallST), std(summary.smallST)];
    
nLongT=[nLongT; summary.longTT];
nShortT=[nShortT; summary.shortTT];
nBigT=[nBigT; summary.bigTT];
nSmallT=[nSmallT; summary.smallTT];

nLongS=[nLongS; summary.longST];
nShortS=[nShortS; summary.shortST];
nBigS=[nBigS; summary.bigST];
nSmallS=[nSmallS; summary.smallST];
if length(activityC)>1
    if length(summary.activityC)>length(activityC(:, end))
        activityC=[activityC; zeros(length(summary.activityC)-length(activityC), 1)];
        activityL=[activityL; zeros(length(summary.activityL)-length(activityL), 1)];
        activityR=[activityR; zeros(length(summary.activityR)-length(activityR),1 )];
        activityC=[activityC, summary.activityC];
        activityL=[activityL, summary.activityL];
        activityR=[activityR, summary.activityR];
    elseif  length(summary.activityC)<=length(activityC(:, end))
        activityC=[activityC, [summary.activityC; zeros(-length(summary.activityC)+length(activityC), 1)]];
        activityL=[activityL, [summary.activityL; zeros(-length(summary.activityL)+length(activityL), 1)]];
        activityR=[activityR, [summary.activityR; zeros(-length(summary.activityR)+length(activityR), 1)]];

    end
else
     activityC=[activityC, summary.activityC];
        activityL=[activityL, summary.activityL];
        activityR=[activityR, summary.activityR];
end 


    
    
longPerf=[longPerf; mean(summary.longPerf)];
shortPerf=[shortPerf; mean(summary.shortPerf)];
smallPerf=[smallPerf; mean(summary.smallPerf)];
bigPerf=[bigPerf; mean(summary.bigPerf)];



% 
% waitTime=[ waitTime, summary.meanWaitTime];
% rewardAmount=[rewardAmount, summary.meanRewardAmount];
% 
% ttAP=[ttAP, summary.ttArdPartition];
% stAP=[stAP, summary.stArdPartition];


mouseID=[mouseID , exptSetup(end).mouseID ', '];

id1=[id1; str2num(exptSetup(end).mouseID)];
end

anaperf=[id1, perf,longPerf,shortPerf,smallPerf,bigPerf];
anatime=[longTT,shortTT,bigTT,smallTT,longST,shortST,bigST,smallST];
anafreq=[activityC, activityL, activityR];
save( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/'  batchname,datenow '_mat/analysis/ana'], 'anaperf', 'anatime', 'anafreq')

% catch ME
% end
performance(:, 1)=[];
mccvalid(:, 1)=[];
micvalid(:, 1)=[];

%% performance plots
figure
subplot(121)
for i=1:length(perf)
hold on
plot(i, perf(i)*100, 'o', 'MarkerSize', perfind(i));

end
ylim([0 100])
axis square
grid on

subplot(122)

hold on
for i=1:length(performance(1, :))
    plot([1:length(performance(:,1)) perfind(i)],[ performance(:,i)*100; perf(i)*100], '-o', 'Color', gray)
    text(perfind(i)+0.2, perf(i)*100+5, num2str(i))

end
plot([1:length(performance(:,1)) mean(perfind,2)], [mean(performance*100, 2); mean(perf*100,2)], '-o','Color',  blue)
plot(perfind, perf*100,'o', 'Color', green)
axis square
ylim([0 100])
grid on


%%
cd( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/' batchname, datenow '_mat/summary']);
x=1500;
folderlist=dir;
    slide=struct;
    slide = setfield(slide, 'c', []);
    slide = setfield(slide, 's', []);
    slide = setfield(slide, 'h', []);
    slide = setfield(slide, 'id', []);
    slide = setfield(slide, 'sp', []);
    slide = setfield(slide, 'tt', []);    
    slide = setfield(slide, 'samp', []);
    slide = setfield(slide, 'trav', []);
    slide = setfield(slide, 'days', []);
for n=3:length(folderlist)
    id=folderlist(n).name
    load (id)
    days=summary.noOfTrials;
    a=summary.trialByTrialScore;
    choice=a(:,2);
    score=a(:, 3);
    results=a(:, 4);
    sampling=a(:, 7);
    travel=a(:, 8);
    
    stimulus= a(:, 1);
    choice(find(choice==2))=1;
    choice(find(choice==5))=0;
    score(find(score==2))=1;
    score(find(score==5))=0;
    stimulus(find(stimulus))=1;
    
odor=a(:, 1);
    
    w=30;
    c=zeros(1, length(choice-2*w+1));
    s=zeros(1, length(choice-2*w+1));
    h=zeros(1, length(choice-2*w+1));
    sp=zeros(1, length(choice-2*w+1));
    tt=zeros(1, length(choice-2*w+1));
    for i=1:length(choice)-w+1;
        c(i)=mean(choice(i:i+w-1));
        r=results(i:i+w-1);
        s(i)=(length(find(r==2))+length(find(r==3)))/length(find(odor(i:i+w-1)~=2));
%         s(i)=mean(score(i:i+w-1));
        h(i)=mean(stimulus(i:i+w-1));
        sp(i)=mean(sampling(i:i+w-1));
        tt(i)=mean(travel(i:i+w-1));
    end
    
    c(end-30:end)=[];
    s(end-30:end)=[];
    h(end-30:end)=[];
    sp(end-30:end)=[];
    tt(end-30:end)=[];
     
    for i=2:length(days)
       days(i)=days(i)+days(i-1);    
    end
    sl=struct;
    sl = setfield(sl, 'c', c);
    sl = setfield(sl, 's', s);
    sl = setfield(sl, 'h', h);
    sl = setfield(sl, 'id', id);
    sl = setfield(sl, 'sp', sp);
    sl = setfield(sl, 'tt', tt);
    sl = setfield(sl, 'samp', sampling);
    sl = setfield(sl, 'trav', travel);
    sl = setfield(sl, 'days', days);

    slide(n-2)=sl;

end
save(['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/', batchname, datenow '_mat',  '/analysis/slide'], 'slide') 
%%
figure
for n=1:length(slide)
    subplot(8,3, 3*n-2)
    title(slide(n).id(1:end-4))
    hold on

    for i=1:length(slide(n).c)-w+1;
        plot(i, slide(n).h(i), '.', 'Color', gray, 'MarkerSize', 4.5)
        plot(i, slide(n).c(i), '.', 'Color', [1-slide(n).s(i), slide(n).s(i), 0], 'MarkerSize', 4.5)
    end
   
    
    for i=1:length(slide(n).days)-1
        l1=line([slide(n).days(i), slide(n).days(i)], [0 1]);  
        set(l1, 'Color', gray);
    end
        l2=line([0 x], [.75 .75]);
        set(l2, 'Color', gray);
        l3=line([0 x], [.25 .25]);
        set(l3, 'Color', gray);
        xlim([0 x])
    
        subplot(8,3, 3*n-1)
        hold on
        
    plot(abs(slide(n).c-slide(n).h), 'Color', blue)
    plot(slide(n).s(1:end), 'color', strongRed)
    plot(slide(n).c(1:end), 'color', green)
    if n==1
        legend('deviance', 'score', 'choice')
    end
     for i=1:length(slide(n).days)-1
        l1=line([slide(n).days(i), slide(n).days(i)], [0 1]);  
        set(l1, 'Color', gray);
    end
        l2=line([0 x], [.7 .7]);
        set(l2, 'Color', gray);
        l3=line([0 x], [.3 .3]);
        set(l3, 'Color', gray);
        xlim([0 x])
    xlim([0 x])
    
    
    
    subplot(8,3, 3*n)
        hold on
    plot(slide(n).s(1:end), 'color', blue)
    plot(slide(n).sp(1:end), 'color', strongRed)
    plot(slide(n).tt(1:end), 'color', green)
    if n==1
        legend('score', 'sampling time', 'travel time')
    end
     for i=1:length(slide(n).days)-1
        l1=line([slide(n).days(i), slide(n).days(i)], [0 1]);  
        set(l1, 'Color', gray);
    end
        l2=line([0 x], [.7 .7]);
        set(l2, 'Color', gray);
        l3=line([0 x], [.3 .3]);
        set(l3, 'Color', gray);
        xlim([0 x])
    xlim([0 x])
end
saveas(figure(1), ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/', batchname, datenow '_mat/analysis/slide'],'fig') 

%%
criS=zeros(1, 8);
criC=zeros(1, 8);
for n=1:length(slide)
   try
    criS(n)=find(slide(n).s>0.9, 1)
   catch ME
   end
   try
    criC(n)=find(slide(n).c<0.25|slide(n).c>0.75, 1)
   catch ME
   end
   
 
end
M=0;
ind1=find(criS==0);
criS(ind1)=[];
criC(ind1)=[];
ind2=find(criC==0);
criS(ind2)=[];
criC(ind2)=[];
drug=[0, 1, 0, 1, 1, 1, 0];

figure
hold on
M=max([max(criS),max(criC)])+150;
for i=1:length(criC)
    plot(criC(i), criS(i), '.', 'Color', [drug(i),0, 0], 'MarkerSize', 12 )
end
for i=1:length(criC)
    text(criC(i)+15, criS(i), num2str(i+145))
end

legend('veh', 'citalopram')
[r, p]=corrcoef(criS, criC)
text(M-400, M-300, ['r=', num2str(round(r(2)*100)/100)])
text(M-400, M-350, ['p=', num2str(round(p(2)*1000)/1000)])


linear=polyfit(criC, criS, 1)
l=line([0 M], [linear(2), M*linear(1)+linear(2)])
set (l, 'Color', gray)

text(M-400, M-450, 'regresssion line:')
text(M-400, M-500, ['y= x + ', num2str(round(linear(2)))])
 
axis('square')
xlim([0, M])
ylim([0, M])
xlabel('No of Trials to reach 25% Bias on Either Side')
ylabel('No of Trials to reach 90% Performance')
cri=struct;
cri=setfield(cri, 'criS', criS);
cri=setfield(cri, 'criC', criC);
cri=setfield(cri, 'linear', linear);

%saveas(figure(1), ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/', datenow '_mat/analysis/scatter'],'fig') 
save(['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/',  batchname,datenow '_mat',  '/analysis/cri'], 'cri') 

%%
figure
hold on
% for i=[3, 5, 6, 7]
%     plot(mean(slide(i).sp), mean(slide(i).tt), 'r.');
% end
% for i=[1, 2, 4, 8]
%     plot(mean(slide(i).sp), mean(slide(i).tt), 'ko');
% end
figure
for n=1:length(slide)
    subplot(2, 4, n)
    hold on
    sp=slide(n).sp;
    tt=slide(n).tt;
   N=length(sp);
    for i=1:N
    plot(sp(i), tt(i), '.', 'Color', [i, i, N-i]/N)
    end
    axis('square')
    xlim([0 1])
    ylim([0 2.5])
    text(0.8, 2.4, num2str(id1(n)))
    text(0.8, 2.1, num2str(criS(n)))    
    text(0.8, 1.8, num2str(perf(n)))
    
end

figure
hold on
for i=1:10
plot(i, 1, '.', 'Color', [i, i, 10-i]/10, 'MarkerSize', 30)
end

%% n-back analysis

%% time correlation
R=zeros(16);
P=zeros(16);

for m=1:16
    for n=1:16
    [r p]=corrcoef(anatime(:,m), anatime(:,n));
    R(m, n)=r(2);
    P(m, n)=p(2);
    
    end
end
R=abs(R);
P=abs(P);




%% corr coef
figure

subplot(121)
hold on
for m=1:16
    for n=1:16
        plot(m, n, '.' , 'Color', [1-R(m, n), R(m, n), 1-R(m, n)], 'MarkerSize', 30)
    end
end
axis('square')

ruler=[1:16]/16;
for n=1:16
plot(18, n ,'.', 'Color', [1-ruler(n), ruler(n), 1-ruler(n)], 'MarkerSize', 30)
end
title('correlation')


% pvalue
subplot(122)
hold on
for m=1:16
    for n=1:16
        plot(m, n, '.' , 'Color', [1-P(m, n), P(m, n), 1-P(m, n)], 'MarkerSize', 30)
    end
end
axis('square')

ruler=[1:16]/16;
for n=1:16
plot(18, n ,'.', 'Color', [1-ruler(n), ruler(n), 1-ruler(n)], 'MarkerSize', 30)
end
title('p-value')

%%





longPerf(isnan(longPerf))=[];
shortPerf(isnan(shortPerf))=[];
smallPerf(isnan(smallPerf))=[];
bigPerf(isnan(bigPerf))=[];

meanlt=longTT(:,1);
meanst=shortTT(:,1);
meanbt=bigTT(:,1);
meansmt=smallTT(:,1);
meanls=longST(:,1);
meanss=shortST(:,1);
meanbs=bigST(:,1);
meansms=smallST(:,1);
meanTT=[mean(meanst), mean(meanlt), mean(meanbt), mean(meansmt)];
meanST=[mean(meanss), mean(meanls), mean(meanbs), mean(meansms)];

stdTT=[std(meanst), std(meanlt), std(meanbt), std(meansmt)];
stdST=[std(meanss), std(meanls), std(meanbs), std(meansms)];


% 
meanPopLongTrend=mean(popLongTrend, 2);
meanPopBigTrend=mean(popBigTrend, 2);
stdPopLongTrend=std(popLongTrend,1, 2);
stdPopBigTrend=std(popBigTrend, 1, 2);


meanLongTrend=zeros(lookforward+lookback+1, 1);
meanBigTrend=zeros(lookforward+lookback+1, 1);


try
    
    for a=1:length(longTrend(:,1))
        meanLongTrend(a)=length(find(longTrend(a,:)==1))/length(find(longTrend(a,:)));
    end
    
    for a=1:length(bigTrend(:,1))
        meanBigTrend(a)=length(find(bigTrend(a,:)==1))/length(find(bigTrend(a,:)));
    end
    catch ME
    end
    
    meanLongTrend(isnan(meanLongTrend))=0;
    meanBigTrend(isnan(meanBigTrend))=0;
    
    
    
% choice=trialByTrial(:,6);
% choiceLong=find(choice==1);
% choiceShort=find(choice==2);
% choiceSmall=find(choice==3);
% choiceBig=find(choice==4);
% 
% meanLongTravelTime=mean(travelTime(choiceLong));
% stdLongTravelTime=std(travelTime(choiceLong));
% 
% meanShortTravelTime=mean(travelTime(choiceShort));
% stdShortTravelTime=std(travelTime(choiceShort));
% 
% meanSmallTravelTime=mean(travelTime(choiceSmall));
% stdSmallTravelTime=std(travelTime(choiceSmall));
% 
% meanBigTravelTime=mean(travelTime(choiceBig));
% stdBigTravelTime=std(travelTime(choiceBig));

meanLongPerf=mean(longPerf);
meanShortPerf=mean(shortPerf);
meanSmallPerf=mean(smallPerf);
meanBigPerf=mean(bigPerf);


stdLongPerf=std(longPerf);
stdShortPerf=std(shortPerf);
stdSmallPerf=std(smallPerf);
stdBigPerf=std(bigPerf);



% figure
% hold on
% bar(meanTT)
% for i=1:7
% line([1, 2], [meanst(i), meanlt(i)])
% line([3, 4], [meanbt(i), meansmt(i)])
% end
% plot(ones(7, 1), meanst, 'g.')
% plot(ones(7, 1)*2, meanlt, 'g.')
% plot(ones(7, 1)*3, meanbt, 'g.')
% plot(ones(7, 1)*4, meansmt, 'g.')
% 
% % 
% meanTravelTime=[ meanShortTravelTime ;meanLongTravelTime; meanBigTravelTime; meanSmallTravelTime];
% stdTravelTime=[ stdShortTravelTime ;stdLongTravelTime; stdBigTravelTime; stdSmallTravelTime];
% 
meanPerf= [meanLongPerf;meanShortPerf; meanSmallPerf;meanBigPerf];
stdPerf=[stdLongPerf;stdShortPerf;stdSmallPerf;stdBigPerf];

population=struct;

% 
% 
% figure
% hold on
% for i=1:7
% plot(1, meanst(i,1), 'ro', 'MarkerSize', meanst(i, 2)*10)
% plot(2, meanlt(i,1), 'ro', 'MarkerSize', meanlt(i, 2)*10)
% xlim([0 3])
% end
% 
%% population summary plot


figure ('OuterPosition', [0 0 1500 1200])
suptitle(mouseID);

subplot(241)
set(gca, 'FontSize', 12)
hold on
plot([-lookback: lookforward],meanPopLongTrend(1:lookback+lookforward+1)*100, '.-', 'LineWidth',1,'Color',strongRed )
plot([-lookback: lookforward],meanPopLongTrend(1:lookback+lookforward+1)*100+stdPopLongTrend(1:lookback+lookforward+1)*100, '-', 'Color',weakRed )
plot([-lookback: lookforward],meanPopLongTrend(1:lookback+lookforward+1)*100-stdPopLongTrend(1:lookback+lookforward+1)*100, '-', 'Color',weakRed )
l1=line([0, 0], [0, 100]);
set(l1, 'Color', blue);
l2=line([-lookback lookforward], [50, 50]);
set(l2, 'Color', green);xlim([-lookback lookforward])
xlim([-lookback lookforward])
ylim([0,100])
%title('Population average choosing the initially short reward')
xlabel('No. of Trials')
ylabel('Percentage choosing the initially short reward by animal')
axis square 
% grid on
hold off


subplot(245)
set(gca, 'FontSize', 12)
hold on
plot([-lookback: lookforward],meanPopBigTrend(1:lookback+lookforward+1)*100, '.-', 'LineWidth',1,'Color',strongRed )
plot([-lookback: lookforward],meanPopBigTrend(1:lookback+lookforward+1)*100+stdPopBigTrend(1:lookback+lookforward+1)*100, '-', 'Color',weakRed )
plot([-lookback: lookforward],meanPopBigTrend(1:lookback+lookforward+1)*100-stdPopBigTrend(1:lookback+lookforward+1)*100, '-', 'Color',weakRed )
line([0, 0], [-100, 100])
l1=line([0, 0], [0, 100]);
set(l1, 'Color', blue);
l2=line([-lookback lookforward], [50, 50]);
set(l2, 'Color', green);xlim([-lookback lookforward])
xlim([-lookback lookforward])
ylim([0,100])
%title('Population average choosing the initially big reward')
xlabel('No. of Trials')
ylabel('Percentage choosing the initially big reward by animal')
axis square 
% grid on
hold off

subplot(242)
set(gca, 'FontSize', 12)
hold on
for i=1:length(popLongTrend(1, :))
    plot([-lookback: lookforward],popLongTrend(1:lookback+lookforward+1, i)*100, 'o', 'LineWidth',1,'Color',gray )
end

l1=line([0, 0], [0, 100]);
set(l1, 'Color', blue);
l2=line([-lookback lookforward], [50, 50]);
set(l2, 'Color', green);
plot([-lookback: lookforward],meanLongTrend(1:lookback+lookforward+1)*100, '.-', 'LineWidth',1,'Color',strongRed )


xlim([-lookback lookforward])
ylim([0,100])
%title('Population average choosing the initially short reward')
xlabel('No. of Trials')
ylabel('Percentage choosing the initially short reward total pool')
axis square 
% grid on
hold off

try
subplot(246)
set(gca, 'FontSize', 12)
hold on
for i=1:length(popLongTrend(1, :))
    plot([-lookback: lookforward],popBigTrend(1:lookback+lookforward+1, i)*100, 'o', 'LineWidth',1,'Color',gray )
end

l1=line([0, 0], [0, 100]);
set(l1, 'Color', blue);
l2=line([-lookback lookforward], [50, 50]);
set(l2, 'Color', green);xlim([-lookback lookforward])
plot([-lookback: lookforward],meanBigTrend(1:lookback+lookforward+1)*100, '.-', 'LineWidth',1,'Color',strongRed )

ylim([0,100])
%title('Population average choosing the initially big reward')
xlabel('No. of Trials')
ylabel('Percentage choosing the initially big reward total pool')
axis square 
% grid on
hold off

catch ME
end


subplot(243)
set(gca, 'FontSize', 12)
hold on
bar(meanPerf(1:2)*100+stdPerf(1:2)*100, 0.02)
h=bar(meanPerf(1:2)*100, 0.6)
set(h(1), 'facecolor', strongRed)

xlim([0 3])

ylim([70 100])
axis square 

ylabel('Percent Correct')
%title('Performance Long and Short')
hold off


subplot(244)
set(gca, 'FontSize', 12)
hold on
bar(meanPerf(3:4)*100+stdPerf(3:4)*100, 0.02)
h=bar(meanPerf(3:4)*100, 0.6)
set(h(1), 'facecolor', strongRed)

ylim([70 100])
xlim([0 3])
ylabel('Percent Correct')
axis square 

%title('Performance Small and Big')

hold off






subplot(247)
set(gca, 'FontSize', 8)
hold on
plot((1:length(waitTime(:, 1))), mean(waitTime, 2)*100, '.-', 'LineWidth',1,'Color', blue )
% plot((1:length(waitTime(:, 1))), mean(waitTime, 2)+std(waitTime, 2), '-', 'LineWidth',1,'Color',[0 .5 .8] )
% plot((1:length(waitTime(:, 1))), mean(waitTime, 2)-std(waitTime, 2), '-', 'LineWidth',1,'Color',[0 .5 .8] )

% line([0, length(waitTime(:, 1))], [summary.expectedRewardDelay(1), summary.expectedRewardDelay(1)])
% line([0, length(waitTime(:, 1))], [summary.minRewardDelay(1), summary.minRewardDelay(1)])
% line([0, length(waitTime(:, 1))], [summary.maxRewardDelay(1), summary.maxRewardDelay(1)])
 line([0, length(waitTime(:, 1))], [100, 100])

ylim([0 200])
xlim([1 length(waitTime(:, 1))])
title('Optimization of Delay in Free Choice Trials')
xlabel('Day')
ylabel('Average Normalized Delay to Reward  per Trial')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off

meanRA=zeros(length(rewardAmount(:,1)), 1);
for i=1:length(rewardAmount(:, 1))
    a=rewardAmount(i, :);
    a(isnan(a))=[];
    meanRA(i)=mean(a);
end

subplot(248)
set(gca, 'FontSize', 8)
hold on
plot((1:length(rewardAmount(:, 1))), meanRA*100, '.-', 'LineWidth',1,'Color',green )
% plot((1:length(rewardAmount(:, 1))), mean(rewardAmount, 2)+std(rewardAmount, 2), '-', 'LineWidth',1,'Color',[0 .5 .8] )
% plot((1:length(rewardAmount(:, 1))), mean(rewardAmount, 2)-std(rewardAmount, 2), '-', 'LineWidth',1,'Color',[0 .5 .8] )
% 
% 
% line([0, length(rewardAmount(:, 1))], [summary.expectedValveDuration(1), summary.expectedValveDuration(1)])
% line([0, length(rewardAmount(:, 1))], [summary.maxValveDuration(1), summary.maxValveDuration(1)])
% line([0, length(rewardAmount(:, 1))], [summary.minValveDuration(1), summary.minValveDuration(1)])
 line([0, length(waitTime(:, 1))], [100, 100])

ylim([0 200])
xlim([1 length(rewardAmount(:, 1))])
title('Optimization of Reward Duration in Free Choice Trials')
xlabel('Day')
ylabel('Average Reward Duration per Trial/s')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off


saveas(figure(1), ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/',  batchname,datenow '_fig',  '/' , exptSetup(1).mouseID,  'Population Summary'],'fig') 

%% summary time plot

figure ('OuterPosition', [0 0 1600 1000])
suptitle(mouseID);


subplot(241)
set(gca, 'FontSize', 12)
hold on
bar(meanTT(1:2)+stdTT(1:2), 0.02)
h=bar(meanTT(1:2), 0.6)
set(h(1), 'facecolor', strongRed)
xlim([0 3])
ylim([0.3 0.9])
for i=1:length(meanst)
line([1, 2], [meanst(i), meanlt(i)])
text(2.3, meanlt(i), num2str(i) )

end

plot(ones(length(meanst), 1), meanst, 'bo', 'MarkerSize', 6)
plot(ones(length(meanst), 1)*2, meanlt, 'bo', 'MarkerSize', 6)
axis square 


ylabel('Travel Time/s')
title('Travel Time Short and Long')
hold off


subplot(245)
set(gca, 'FontSize', 12)
hold on
bar(meanTT(3:4)+stdTT(3:4), 0.02)
h=bar(meanTT(3:4), 0.6);
set(h(1), 'facecolor', strongRed)
xlim([0 3])
ylim([0.3 0.9])

for i=1:length(meanst)
line([1, 2], [meanbt(i), meansmt(i)])
text(2.3, meansmt(i), num2str(i) )
end

plot(ones(length(meanst), 1)*1, meanbt, 'bo', 'MarkerSize', 6)
plot(ones(length(meanst), 1)*2, meansmt, 'bo', 'MarkerSize', 6)
axis square 

ylabel('Travel Time/s')
title('Travel Time Big and Small')
hold off





subplot(243)
set(gca, 'FontSize', 12)
hold on
bar(meanST(1:2)+stdST(1:2), 0.02)
h=bar(meanST(1:2), 0.6);
set(h(1), 'facecolor', strongRed)
xlim([0 3])
ylim([0.25 0.35])

for i=1:length(meanst)
line([1, 2], [meanss(i), meanls(i)])
text(2.3, meanls(i), num2str(i) )

end
plot(ones(length(meanst), 1), meanss, 'bo', 'MarkerSize', 6)
plot(ones(length(meanst), 1)*2, meanls, 'bo', 'MarkerSize', 6)
axis square 


ylabel('Cue Sampling Time/s')
title('Cue Sampling Time Short and Long')
hold off


subplot(247)
set(gca, 'FontSize', 12)
hold on
bar(meanST(3:4)+stdST(3:4), 0.02)
h=bar(meanST(3:4), 0.6)
set(h(1), 'facecolor', strongRed)
xlim([0 3])
ylim([0.25 0.35])

for i=1:length(meanst)
line([1, 2], [meanbs(i), meansms(i)])
text(2.3, meansms(i), num2str(i) )

end

plot(ones(length(meanst), 1)*1, meanbs, 'bo', 'MarkerSize', 6)
plot(ones(length(meanst), 1)*2, meansms, 'bo', 'MarkerSize', 6)
axis square 


ylabel('Cue Sampling Time/s')
title('Cue Sampling Time Big and Small')
hold off


subplot(242)
set(gca, 'FontSize', 12)
hold on
plothist(nShortT, 0.02, 'r')
plothist(nLongT, 0.02, blue)
xlim([0 6])
t=text(4, 150, 'short');
set(t, 'Color', 'r')
t=text(4, 140, 'long');
set(t, 'Color', blue)
title('distribution of travel time by delay')
xlabel('time/s')
ylabel('count')
axis square 
grid on
hold off

subplot(246)
set(gca, 'FontSize', 12)
hold on
plothist(nBigT, 0.02, 'r')
plothist(nSmallT, 0.02, blue)
t=text(4, 150, 'big');
set(t, 'Color', 'r')
t=text(4, 140, 'small');
set(t, 'Color', blue)
title('distribution of travel time by size')
xlim([0 6])

xlabel('time/s')
ylabel('count')
axis square 
grid on
hold off


subplot(244)
set(gca, 'FontSize', 12)
hold on
plothist(nShortS, 0.02, 'r')
plothist(nLongS, 0.02, blue)
xlim([0 2])
t=text(1.5, 150, 'short');
set(t, 'Color', 'r')
t=text(1.5, 140, 'long');
set(t, 'Color', blue)
title('distribution of sampling time by delay')
xlabel('time/s')
ylabel('count')
axis square 
grid on
hold off

subplot(248)
set(gca, 'FontSize', 12)
hold on
plothist(nBigS, 0.02, 'r')
plothist(nSmallS, 0.02, blue)
t=text(1.5, 150, 'big');
set(t, 'Color', 'r')
t=text(1.5, 140, 'small');
set(t, 'Color', blue)
title('distribution of sampling time by size')
xlim([0 2])

xlabel('time/s')
ylabel('count')
axis square 
grid on
hold off
saveas(figure(2), ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/', batchname, datenow '_fig',  '/' , exptSetup(1).mouseID,  'Population Summary Time'],'fig') 




%%
figure
for n=[1 2 3 4 5 6 7]
    
    subplot(2,4, n)
    hold on
    plot([-lookback: lookforward], popLongTrend(1:lookback+lookforward+1, n)*100, '-', 'Color', blue )
    l1=line([0, 0], [0, 100]);
    set(l1, 'Color', blue);
    l2=line([-lookback lookforward], [50, 50]);
    set(l2, 'Color', green);
    xlim([-lookback lookforward])
    ylim([0 100])
        title(mouseID(5*(n-1)+1:5*n-2))
end
suptitle('Long Trend')

figure
for n=[1 2 3 4 5 6 7]
    
    subplot(2,4, n)
    hold on
    plot([-lookback: lookforward],popBigTrend(1:lookback+lookforward+1,n)*100, '-', 'Color', green )
    l1=line([0, 0], [0, 100]);
    set(l1, 'Color', blue);
    l2=line([-lookback lookforward], [50, 50]);
    set(l2, 'Color', green);
        title(mouseID(5*(n-1)+1:5*n-2))

    xlim([-lookback lookforward])
    ylim([0 100])
end

suptitle('Big Trend')



%%
N=length(popLongTrend(:, 1));
n=ones(N, 10);
h=ones(N, 10);
x=i*ones(N, 10);
for i=1:N
x(i, :)=i*x(1);
end
for i=1:N
[n(i, :) h(i, :)]=hist(popLongTrend(i, :))
end

plot3(x, h, n, 'o')















% %% learning curve
% learning=[];
% for i=1:length(performance)
% learning(:,i)=performance{i}(1:14);
% end
% 
% for i=1:length(learning(1,:))
%     ind=(find(learning(:, i)>=0.90));
%     try
%         learning((ind(1)+1):10, i)=NaN;
%     catch ME
%     end
% 
% end
% 
% meanLearning=[];
% 
% for i=1:length(learning(:, 1))
%     day=learning(i, :);
%     ind=find(day>0);
%     meanLearning(i)=mean(day(ind))
% end
% 
% 
% figure
% hold on
% plot(meanLearning*100, 'LineWidth', 2, 'Color', [.5 .8 .8])
% legend('Mean Learning Curve')
% title('Learning Curve')
% xlabel('Sessions')
% ylabel('Percentage Correct on Forced Choice')
% for i=1:length(learning(1,:))
%     plot(learning(:, i)*100, 'Color', [.8 .8 .8])
% end
% hold off
% 
% 
% %% around first partition
% 
% 
% 
% 
% %%victory
% 
% x=imread('/Applications/MATLAB_R2008a/randomshit/randompic/all.jpg');
% imshow(x);
% 
% 
% disp('i am done running');
% importfile('/Applications/MATLAB_R2008a/randomshit/randomsound/looney.wav');
% sound(data, fs);
% 
% 

