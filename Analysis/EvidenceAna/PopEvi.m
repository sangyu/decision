

load('C:\Users\user\Documents\Evidence\DataMatrices\genotype.mat')

matFileName=['C:\Users\user\Documents\Evidence\DataMatrices\DataMats\Data', datestr(now, 'mm-dd-yy'), '.mat']

runBehaviorFiles(0, 19, matFileName);
% runBehaviorFiles(micetoana, daystoana, matFileName)

%%
a=whos('-regexp','data_4' );
b=whos('-regexp','centerPokesAvail_' );
startEnd=[11 60 200];
imagepath='C:\Users\user\Documents\Evidence\images\dailyPlots\Morph\'
mkdir(imagepath)
totalData=[];
for i=1:length(a)
    data=eval(a(i).name);
    startEnd(3)=min([startEnd(2), length(data(:, 1))]);
    data=data(startEnd(1):startEnd(3), :);
    totalData=[totalData; data];
    centerPokesAvail=eval(b(i).name);
    centerPokesAvail=centerPokesAvail(intersect(find(centerPokesAvail(:, 4)<=startEnd(3)), find(centerPokesAvail(:, 4)>=startEnd(1))), :);
    valveValues=sort(unique(data(:, 16)));
    try
    for valve=1:length(valveValues)
        plotDailyEviAccum(data,startEnd, valveValues(valve), 0, 0, geno, [imagepath, '\valve', num2str(valveValues(valve)*1000)])
    close all
    end
    
    plotDailySampling(data, centerPokesAvail, startEnd, 0, 0, geno, [imagepath, '\samplingtimes'])  
    close all
    end
end
%%
% clear
matFileName=['C:\Users\user\Documents\Evidence\DataMatrices\DataMats\Data', datestr(now, 'mm-dd-yy'), '.mat']
load(matFileName)
list=who;
data0=eval(list{1});
valveValues=sort(unique(data0(:, 16)));

%%

%Short sessions
imagepath='C:\Users\user\Documents\Evidence\images\groupAnalysis\Short\';
mkdir(imagepath)
valveValues=[0.1]
micetoana=[  422, 429,423, 427]
micetoana=[  409, 415, 416, 417, 418, 424, 428, 432]
% micetoana=[  412, 413, 414, 419, 420, 425, 426, 430]
% micetoana=[   409, 415, 416, 417, 418, 424, 428, 432, 412, 413, 414, 419, 420, 425, 426, 430]
odorConstrast='100';
sessionstoana={'S1', 'S2', 'S3'};
chooseSecondary=0;
yUpper=[500, 450, 100, 100];
yLower=[300, 300, 50, 20];
%%

%Long Sessions
imagepath='C:\Users\user\Documents\Evidence\images\groupAnalysis\Long\';
mkdir(imagepath)

valveValues=[0.1]
micetoana=[  422, 429,423, 427]
micetoana=[  409, 415, 416, 417, 418, 424, 428, 432]
micetoana=[  411, 412, 413, 414, 419, 420, 425, 426, 430]
% micetoana=[ 409, 415, 416, 417, 418, 424, 428, 432, 411, 412, 413, 414, 419, 420, 425, 426, 430]

odorConstrast='100';
sessionstoana={'L1', 'L2', 'L3'};
chooseSecondary=0;
yUpper=[600, 550, 100, 100];
yLower=[400, 350, 50, 20];
    

%%
% Variable Sessions
imagepath='C:\Users\user\Documents\Evidence\images\groupAnalysis\Variable\';
mkdir(imagepath)

valveValues=[0.1, 0.3]
micetoana=[409,  416, 417, 418, 424,  432]
% micetoana=[  422, 429,423, 427]
% micetoana=[411, 412, 413, 414, 419, 420, 426, 430 ]
odorConstrast='Delay';
sessionstoana={'V1', 'V2', 'V3', 'V4'};
yUpper=[600, 550, 105, 100];
yLower=[400, 350, 50, 20];
% micetoana=[409,  416, 417, 418, 424,  432, 411,  412, 413, 414, 419, 420, 426, 430, 422, 429,423, 427]
% %%

styling;
Notes=[];
individualPoints=1;
names=0;
removeStickyTrials=0;
startEnd=[1 50 200];
% % sessionstoana={'V1', 'V2'};
% sessionstoana={'V1'};
% sessionstoana={'V2'};
% sessionstoana={'V3'};
% sessionstoana={'V4'};

% 
% sessionstoana={'S1', 'S2', 'S3'};
% sessionstoana={'L1', 'L2', 'L3'};
% % sessionstoana={'S2'};
% sessionstoana={'L2'};
% 

load(['C:\Users\user\Documents\Evidence\DataMatrices\protocol', odorConstrast, '.mat'])
protocol=eval(['protocol', num2str(odorConstrast)]);
load('C:\Users\user\Documents\Evidence\DataMatrices\genotype.mat')

opsinType=geno(find(geno(:, 1)==micetoana(1)), 2);
opsinNames=geno(find(geno(:, 1)==micetoana(1)), 2);
switch opsinType
    case 2
    opsin=green;
    case 1
    opsin=blue;
    case 0
    opsin=lightPurple;   
end
opsinName=['Ctrl'; 'ChR2'; 'Arch'];
lightOpsin=rgb2hsv(opsin);
lightOpsin=[lightOpsin(1), lightOpsin(2)*0.4,lightOpsin(3)];
lightOpsin=hsv2rgb(lightOpsin);
lightGray=[.5, .5, .5];
lightGray=[.5, .5, .5];
lightPurple=[.8, .8, .8];


% %%   
    
numberOfSubplots=4;


f1=figure(micetoana(1)*2)
set(f1, 'Position', [0, 0, 280*length(valveValues),  300*numberOfSubplots])
    totalCenterPoke=[];
    totalData=[];

for valve=1:length(valveValues)
    sampTimeOn=[];
    sampTimeOff=[];
    transitTimeOn=[];
    transitTimeOff=[];
    sampleSize=length(micetoana);
    noTimeOut=[];
    percentQualifiedOn=[];
    percentQualifiedOff=[];
    attemtsToQualifyOn=[];
    attemtsToQualifyOff=[];
    accuracyOn=[];
    accuracyOff=[];
    qualifiedTrialsOff=[];
    qualifiedTrialsOn=[];
    dates=cell(1);
    allCenterPokesOn=[];
    allCenterPokesOff=[];
    
    listofmice=[];
    for i=2:length(protocol(:, 1))
    listofmice(i, 1)=protocol{i, 1};
    end

    for mouse=1:length(micetoana)
        mouseData=[];
        dates{mouse, 1}=num2str(micetoana(mouse));
        mouseInd=find(listofmice==micetoana(mouse));
        for day=1:length(sessionstoana)
            sessionInd=find(ismember(protocol(1, :), sessionstoana(day)));

            date=datenum(protocol(mouseInd, sessionInd));
            dates(mouse, day+1)=protocol(mouseInd, sessionInd);
            data=eval(['data_', num2str(micetoana(mouse)), '_', num2str(date)]);
            centerPokesAvail=eval(['centerPokesAvail_', num2str(micetoana(mouse)), '_', num2str(date)]);
            data(:, 4)=data(:, 4)*1000;
            data(:, 6)=data(:, 6)*1000;
            centerPokesAvail(:, 1)=centerPokesAvail(:, 1)*1000;
            startEnd(3)=min([startEnd(2), length(data(:, 1))]);
            data=data(startEnd(1):startEnd(3), :);
            %exclude timeout trials
            data=data(find(data(:, 3)~=-1), :)
            if chooseSecondary==1
                  centerPokesAvail=centerPokesAvail(centerPokesAvail(:, 3)==valveValues(valve), :)
                  data=data(find(data(:, 16)==valveValues(valve)), :);
            end
            centerPokesAvail=centerPokesAvail(intersect(find(centerPokesAvail(:, 4)<=startEnd(3)), find(centerPokesAvail(:, 4)>=startEnd(1))), :);

    %         data=data(find(data(:, 1)==1), :);
    %         data=data(startEndTrials, :);
            if removeStickyTrials==1
                        data=data(find(data(:, 4)>0.4), :);
            end
            noTimeOut(day, mouse)=length(find(data(:, 3)<0));
            stimOnTrials=find(data(:, 10)==1);
            stimOffTrials=find(data(:, 10)==0);
            sampTimeOn(day, mouse)=mean(data(stimOnTrials, 4));
            sampTimeOff(day, mouse)=mean(data(stimOffTrials, 4));
            transitTimeOn(day, mouse)=mean(data(stimOnTrials, 6));
            transitTimeOff(day, mouse)=mean(data(stimOffTrials, 6));
            percentQualifiedOn(day, mouse)=length(data(stimOnTrials, 12))/sum(data(stimOnTrials, 12));
            percentQualifiedOff(day, mouse)=length(data(stimOffTrials, 12))/sum(data(stimOffTrials, 12));
            attemtsToQualifyOn(day, mouse)=mean(data(stimOnTrials, 12));
            attemtsToQualifyOff(day, mouse)=mean(data(stimOffTrials, 12));
            accuracyOn(day, mouse)=mean(data(stimOnTrials, 3));
            accuracyOff(day, mouse)=mean(data(stimOffTrials, 3));
            qualifiedTrialsOff(day, mouse)=(1-mean(data(stimOffTrials, 15)))*100;
            qualifiedTrialsOn(day, mouse)=(1-mean(data(stimOnTrials, 15)))*100;
            mouseData=[mouseData; data];
            allCenterPokesOn(day, mouse)=mean(centerPokesAvail(find(centerPokesAvail(:,2)==1), 1));
            allCenterPokesOff(day, mouse)=mean(centerPokesAvail(find(centerPokesAvail(:,2)==0), 1));
            
        end
        assignin('base', ['mouseData_', num2str(1000*valveValues(valve)), 'ms_Switch_',num2str(micetoana(mouse))], mouseData);
        dates{mouse, length(sessionstoana)+2}=num2str(length(mouseData(:, 1)));
        totalData=[totalData;mouseData];
        totalCenterPoke=[totalCenterPoke;centerPokesAvail];
    end

    assignin('base', ['sampTimeOn', num2str(1000*valveValues(valve)), 'ms_Switch'], sampTimeOn);
    assignin('base', ['sampTimeOff', num2str(1000*valveValues(valve)), 'ms_Switch'], sampTimeOff);
    assignin('base', ['allCenterPokesOn', num2str(1000*valveValues(valve)), 'ms_Switch'], allCenterPokesOn);
    assignin('base', ['allCenterPokesOff', num2str(1000*valveValues(valve)), 'ms_Switch'], allCenterPokesOff);
    assignin('base', ['qualifiedTrialsOn', num2str(1000*valveValues(valve)), 'ms_Switch'], qualifiedTrialsOn);
    assignin('base', ['qualifiedTrialsOff', num2str(1000*valveValues(valve)), 'ms_Switch'], qualifiedTrialsOff);
    assignin('base', ['accuracyOn', num2str(1000*valveValues(valve)), 'ms_Switch'], accuracyOn);
    assignin('base', ['accuracyOff', num2str(1000*valveValues(valve)), 'ms_Switch'], accuracyOff);


    header=[{'Mouse'}, sessionstoana, 'No. of Trials'];
    dates=[header; dates]
    assignin('base', ['dates',num2str(micetoana(1)), 'to', num2str(micetoana(mouse))], dates);
    
    % %%
%     vartoPrint=[]
    nowDate=datestr(now);
    nowDate=nowDate(1:11);
    fid = fopen( [imagepath, opsinName(opsinNames+1, :),num2str(micetoana(1)), 'to', ...
        num2str(micetoana(mouse)), '_', num2str(sessionstoana{1}), 'to', ...
        num2str(sessionstoana{end}), '_', nowDate, '.txt'], 'wt' );
    formatSpec='%s \t %s \t \r\n';
    for s=1:length(sessionstoana)
        formatSpec=['%s \t ', formatSpec];
    end
    [nrows,ncols] = size(dates);
    for row = 1:nrows
        fprintf(fid,formatSpec,dates{row,:});
    end
    
    fclose(fid);
    % %%
    minimumSamplingTime=(data(end, 14)+data(end, 9))*1000;


    subplot(numberOfSubplots, length(valveValues),  0*length(valveValues)+valve)
    [pw, hw, pt, ht, t]=barPlot2(mean(sampTimeOff, 1), mean(sampTimeOn, 1), micetoana, opsin, individualPoints, names)
    ylabel('Qualified Samp Time (ms)')
    ylim([yLower(1), yUpper(1)])
    if length(valveValues)>1
    title(['Cue onset at ' num2str(1000*valveValues(valve)) 'ms'])
    end
    try
    set(t, 'Position', [1.5, yLower(1)+(yUpper(1)-yLower(1))*0.95, 0])
    end
%     set(t, )
    subplot(numberOfSubplots, length(valveValues), 1*length(valveValues)+valve)
    [pw, hw, pt, ht, t]=barPlot2(mean(allCenterPokesOff, 1), mean(allCenterPokesOn, 1), micetoana, opsin, individualPoints, names)
    ylabel('All Samp Time (ms)')    
    ylim([yLower(2), yUpper(2)])
    try
    set(t, 'Position', [1.5, yLower(2)+(yUpper(2)-yLower(2))*0.95, 0])
    end
    
%     
%     subplot(length(valveValues), numberOfSubplots, 3+(valve-1)*numberOfSubplots)
%     barPlot2(mean(transitTimeOff, 1), mean(transitTimeOn, 1), micetoana, opsin, individualPoints, names)
%     ylabel('Reaction Time (ms)')


%     subplot(length(valveValues), numberOfSubplots, 2*length(valveValues)-valve)
%     barPlot2(mean(percentQualifiedOff*100, 1), mean(percentQualifiedOn*100, 1), micetoana, opsin, individualPoints, names)
%     ylabel('Percent CPoke Attempt Qualified')
%     xlabel(['Switch at ', num2str(valveValues(valve)*1000), 'ms'])
%     
    
    subplot(numberOfSubplots, length(valveValues), 2*length(valveValues)+valve)
    [pw, hw, pt, ht, t]=barPlot2(mean(accuracyOff*100, 1), mean(accuracyOn*100, 1), micetoana, opsin, individualPoints, names)
    ylabel('Accuracy')

    ylim([yLower(3), yUpper(3)])
if opsinType==0 && valve==1
    ylim([60, 100])
end
    try
    set(t, 'Position', [1.5, yLower(3)+(yUpper(3)-yLower(3))*0.95, 0])
    end
    
    subplot(numberOfSubplots, length(valveValues),  3*length(valveValues)+valve)
    [pw, hw, pt, ht, t]=barPlot2(mean(qualifiedTrialsOff, 1), mean(qualifiedTrialsOn, 1), micetoana, opsin, individualPoints, names)
    ylabel('Percent Trials Qualified')
    ylim([yLower(4), yUpper(4)])
    try
    set(t, 'Position', [1.5, yLower(4)+(yUpper(4)-yLower(4))*0.95, 0])
    end
end
        totalData(:, 4)=totalData(:, 4)/1000;
        totalCenterPoke(:, 1)=totalCenterPoke(:, 1)/1000;

suptitle([opsinName(opsinNames+1, :),', ' num2str(sessionstoana{1}), ' to ', ...
    num2str(sessionstoana{end}), ' , n = ', num2str(length(micetoana)), Notes])
% 
% suptitle(['mouse # ' num2str(micetoana),'  session ' sessionstoana{1}, ':',...
%     sessionstoana{end},' trials', num2str(startEnd(1)), ' to ', num2str(startEnd(2)), ' (min ', num2str(minimumSamplingTime), ')', Notes])
% %%

fnam1=[imagepath, opsinName(opsinNames+1, :),num2str(micetoana(1)), 'to', ...
    num2str(micetoana(mouse)), '_', num2str(sessionstoana{1}), 'to', ...
    num2str(sessionstoana{end}), '_trials', num2str(startEnd(1)), '_to_', num2str(startEnd(2)), '_', nowDate, 'lightOnOff.png']; % your file name

snam='summaryFigure'; % note: NO extension...
s=hgexport('readstyle',snam);
s.Format='png';
hgexport(f1,fnam1,s);
%%
if length(valveValues)>1

    f2=figure(2);
    set(f2, 'Position', [0, 0, 220*numberOfSubplots+100  400])

        subplot(1, numberOfSubplots, 1)
        barPlot2(mean(sampTimeOff100ms_Switch, 1), mean(sampTimeOff300ms_Switch, 1), micetoana, lightPurple, individualPoints, names)
        ylabel('Qualified Samp Time (ms)')
        set(gca, 'XTickLabel', {'100', '300'})

        subplot(1, numberOfSubplots, 2)
        barPlot2(mean(allCenterPokesOff100ms_Switch, 1), mean(allCenterPokesOff300ms_Switch, 1), micetoana, lightPurple, individualPoints, names)
        ylabel('All Samp Time (ms)')
        set(gca, 'XTickLabel', {'100', '300'})
        xlabel('Cue Onset (ms)')
        subplot(1, numberOfSubplots, 3)
        barPlot2(mean(qualifiedTrialsOff100ms_Switch, 1), mean(qualifiedTrialsOff300ms_Switch, 1), micetoana, lightPurple, individualPoints, names)
        ylabel('Percent Trials Qualified')
        set(gca, 'XTickLabel', {'100', '300'})
        subplot(1, numberOfSubplots, 4)
        barPlot2(mean(accuracyOff100ms_Switch, 1), mean(accuracyOff300ms_Switch, 1), micetoana, lightPurple, individualPoints, names)
        ylabel('Accuracy')
        set(gca, 'XTickLabel', {'100', '300'})
    
end
suptitle([opsinName(opsinNames+1, :),', ' num2str(sessionstoana{1}), ' to ', ...
    num2str(sessionstoana{end}), ' , n = ', num2str(length(micetoana)), ' Baseline Differences'])


fnam2=[imagepath, opsinName(opsinNames+1, :),num2str(micetoana(1)), 'to', ...
    num2str(micetoana(mouse)), '_', num2str(sessionstoana{1}), 'to', ...
    num2str(sessionstoana{end}), '_trials', num2str(startEnd(1)), '_to_', num2str(startEnd(2)), '_', nowDate, 'BaselineDiff.png']; % your file name

snam='summaryFigure'; % note: NO extension...
s=hgexport('readstyle',snam);
s.Format='png';
hgexport(f2,fnam2,s);


% plotDailySampling(totalData, totalCenterPoke, [1 50], 0, 0, geno, imagepath )%%
%%

figure(micetoana(2)+20)
individualPoints=1
dates=dateRange(1:3)

subplot(131)
hold on
for i=1:3
    
    plot(i, mean(sampTimeOff(i, :), 2), 'ko')
    ownErrorbar(i, mean(sampTimeOff(i, :), 2), std(sampTimeOff(i, :), 0, 2)/sqrt(length(micetoana)), std(sampTimeOff(i, :), 0, 2)/sqrt(length(micetoana)), .1, 2, 'k')
    [h, p]=ttest(sampTimeOff(i, :), sampTimeOn(i, :))
    text(i,  mean(sampTimeOff(i, :), 2)+0.02, num2str(p))
    plot(i, mean(sampTimeOn(i, :), 2), 'o', 'Color', opsin)
    ownErrorbar(i, mean(sampTimeOn(i, :), 2), std(sampTimeOn(i, :),0, 2)/sqrt(length(micetoana)), std(sampTimeOn(i, :),0,  2)/sqrt(length(micetoana)), .1, 2, opsin)   
        plot(ones(length(sampTimeOff(i, :)), 1)*i, sampTimeOff(i, :), '.', 'Color', lightGray, 'MarkerSize', 15);
        plot(ones(length(sampTimeOn(i, :)), 1)*i, sampTimeOn(i, :), '.', 'Color', lightOpsin, 'MarkerSize', 15);
    end

plot([1, 2, 3], mean(sampTimeOff, 2), 'k-')
plot([1, 2, 3], mean(sampTimeOn, 2), '-', 'Color', opsin)
ylabel('Sampling Time (s)')

if individualPoints==1

    for i=1:length(micetoana)
        text(3.5, sampTimeOff(3, i), num2str(micetoana(i)), 'Color', lightGray)
        text(3.5, sampTimeOn(3, i), num2str(micetoana(i)), 'Color', opsin)
        text(0.5, sampTimeOff(1, i), num2str(micetoana(i)), 'Color', lightGray)
        text(0.5, sampTimeOn(1, i), num2str(micetoana(i)), 'Color', opsin)
        plot([1, 2, 3], sampTimeOn(:, i), '-', 'Color', lightOpsin)
        plot([1, 2, 3], sampTimeOff(:, i), '-', 'Color', lightGray)

    end
end
    xlim([0.5 4])
% %%
sampDiff=sampTimeOn-sampTimeOff;

subplot(132)
hold on
for i=1:3
    
    plot(i, mean(sampDiff(i, :), 2), 'o', 'Color', opsin)
    ownErrorbar(i, mean(sampDiff(i, :), 2), std(sampDiff(i, :),0, 2)/sqrt(length(micetoana)), std(sampDiff(i, :),0,  2)/sqrt(length(micetoana)), .1, 2, opsin)   
        plot(ones(length(sampDiff(i, :)), 1)*i, sampDiff(i, :), '.', 'Color', lightOpsin, 'MarkerSize', 15);
end

if individualPoints==1
    for i=1:length(micetoana)
        text(3.5, sampDiff(3, i), num2str(micetoana(i)), 'Color', opsin)
        text(0.5, sampDiff(1, i), num2str(micetoana(i)), 'Color', opsin)
        plot([1, 2, 3], sampDiff(:, i), '-', 'Color', lightOpsin)

    end
end
plot([0 4],[0 0], 'Color', lightGray )
plot([1, 2, 3], mean(sampDiff, 2), '-', 'Color', opsin)
ylabel('Difference in Sampling Time (s)')

ylim([-.07 .07])


sampDiffNorm=(sampTimeOn-sampTimeOff)./sampTimeOff;

subplot(133)
hold on
for i=1:3
    
    plot(i, mean(sampDiffNorm(i, :), 2), 'o', 'Color', opsin)
    ownErrorbar(i, mean(sampDiffNorm(i, :), 2), std(sampDiffNorm(i, :),0, 2)/sqrt(length(micetoana)), std(sampDiffNorm(i, :),0,  2)/sqrt(length(micetoana)), .1, 2, opsin)   
        plot(ones(length(sampDiffNorm(i, :)), 1)*i, sampDiffNorm(i, :), '.', 'Color', lightOpsin, 'MarkerSize', 15);
end

if individualPoints==1
    for i=1:length(micetoana)
        text(3.5, sampDiffNorm(3, i), num2str(micetoana(i)), 'Color', opsin)
        text(0.5, sampDiffNorm(1, i), num2str(micetoana(i)), 'Color', opsin)
        plot([1, 2, 3], sampDiffNorm(:, i), '-', 'Color', lightOpsin)

    end
end
plot([0 4],[0 0], 'Color', lightGray )
plot([1, 2, 3], mean(sampDiffNorm, 2), '-', 'Color', opsin)
ylabel('Normalized Difference in Sampling Time (s)')

ylim([-.20 .20])


%%

figure(micetoana(end)*2)
for m=1:length(micetoana)
   subplot(4, 3, m)
   hold on
   
   opsinType=geno(find(geno(:, 1)==micetoana(m)), 3);
switch opsinType
    case 2
    opsin=green;
    case 1
    opsin=blue;
    case 0
    opsin='k';   
end
    data=eval(['mouseData_',num2str(micetoana(m))]);
    
    scatter(data(:, 4), data(:, 6), 'k');
    [r, p]=corr(data(:, 4), data(:, 6));
    plot(data(find(data(:, 10)==1), 4), data(find(data(:, 10)==1), 6), '.', 'Color', opsin)
    [ron, pon]=corr(data(find(data(:, 10)==1), 4), data(find(data(:, 10)==1), 6))
    [roff, poff]=corr(data(find(data(:, 10)==0), 4), data(find(data(:, 10)==0), 6))
%     text(0.6, 2, ['r=', num2str(r)])
    title([num2str(micetoana(m)), ' ron^2=', num2str(ron^2), ' pon =', num2str(pon),' roff^2=', num2str(roff^2), ' poff =', num2str(poff)])
end
