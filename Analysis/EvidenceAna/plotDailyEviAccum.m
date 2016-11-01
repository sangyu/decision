
function plotDailyEviAccum(data,startEnd, secondary, cutAbort, cutLeftOff, geno,  imagepath)
mouse=data(end, 8);


set(0,'DefaultAxesFontName', 'Arial')
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultTextFontname', 'Arial')
set(0,'DefaultTextFontSize', 8)
markers={'o';'^';'d';'s';'p';'h';'*' };
red=[ 0.85    0.20   0.20];
blue=[ 0.3    0.4    0.9];
orange= [0.9, 0.3,  0];
gray=[.4, .4, .4];
green=[  .3,  0.75,0.5];
yellow=[1, 0.95, 0.4];
pink= [0.9, 0.3,  0.6];


samplingTimeBinWidth=0.05;
minSamplingBin=0;
maxSamplingBin=0.8;
normalize=0;




minimumLaser=0;
opsinType=geno(find(geno(:, 1)==mouse(1)), 3);
% opsinType=1
switch opsinType
    case 2
    opsin=green;
    case 1
    opsin=blue;
    case 0
    opsin='k';   
end




if cutAbort==1
   data= data(find(data(:, 15)==0), :);
end

if cutLeftOff==1
    data(data(:, 4)<0.35, :)=[];
end


totalNoTrials=length(data(:, 3));
correctNoTrials=length(find(data(:, 3)==1));
score=data(:, 3);
side=data(:, 2);
cue1Species=max(data(:, 17));




% data(intersect(find(data(:, 13)<minimumLaser),find(data(:, 10)==1)), :)=[];
splT=data(:, 4);
rxnT=data(:, 6);
odorOnset=data(end, 14);
qualifying=data(end, 14)+data(end, 9);

if secondary~=0
   data= data(find(data(:, 16)==secondary), :);
   valveSwitch=data(end, 14)+data(end, 16);
end

correctTrials=find(score==1);
incorrectTrials=find(score==0);
leftTrials=find(data(:,1)==1);
rightTrials=find(data(:,1)==0);
stimTrials=find(data(:, 10)==1);
unstimTrials=find(data(:, 10)==0);
stimPresent=length(stimTrials)~=0;
leftCorr=intersect(leftTrials, correctTrials);
leftIncorr=intersect(leftTrials, incorrectTrials);
rightCorr=intersect(rightTrials, correctTrials);
rightIncorr=intersect(rightTrials, incorrectTrials);

leftStim=intersect(leftTrials, stimTrials);
leftUnstim=intersect(leftTrials, unstimTrials);
rightStim=intersect(rightTrials, stimTrials);
rightUnstim=intersect(rightTrials, unstimTrials);

stimCorr=intersect(stimTrials, correctTrials);
stimIncorr=intersect(stimTrials, incorrectTrials);
unstimCorr=intersect(unstimTrials, correctTrials);
unstimIncorr=intersect(unstimTrials, incorrectTrials);


leftStimCorr=intersect(leftCorr, stimTrials);
leftUnstimCorr=intersect(leftCorr, unstimTrials);
rightStimCorr=intersect(rightCorr, stimTrials);
rightUnstimCorr=intersect(rightCorr, unstimTrials);


timeOutTrials=find(score==-1);
nonTimeOut=score(score>=0);
splTNonTimeOut=splT(score>=0);
% cueNonTimeOut=data(1, score>=0)

halfymax=0;
quartymax=0;


%
sampleBins=[minSamplingBin:samplingTimeBinWidth:maxSamplingBin];
sampleBins=[sampleBins; sampleBins+samplingTimeBinWidth];

% sampleBins=[0.2, 0.4, 0.8; 0.4, 0.8, 1.8];




% %%


accuracyBins=[];
trialsBins=[];

for i=1:length(sampleBins(1, :))
    accuracyBins(i)=mean(nonTimeOut(intersect(find(splTNonTimeOut>=sampleBins(1, i)), find(splTNonTimeOut<sampleBins(2, i)))));
    trialsBins(i)=length(nonTimeOut(intersect(find(splTNonTimeOut>=sampleBins(1, i)), find(splTNonTimeOut<sampleBins(2, i)))));
end
if length(mouse)==1
        assignin('base', ['accuracyBins' num2str(mouse)], accuracyBins);
end
accuracyBins=accuracyBins*100;
maxSamplingTime=sampleBins(1, max(find(trialsBins)))+0.3;

 
    
splTNonTimeOutL=data(intersect(find(data(:, 1)==1), find(data(:, 3)~=-1)), 4);
splTNonTimeOutR=data(intersect(find(data(:, 1)==0), find(data(:, 3)~=-1)), 4);
nonTimeOutL=data(intersect(find(data(:, 1)==1), find(data(:, 3)~=-1)), 3);
nonTimeOutR=data(intersect(find(data(:, 1)==0), find(data(:, 3)~=-1)), 3);

accuracyBinsL=[];
trialsBinsL=[];
accuracyBinsR=[];
trialsBinsR=[];

for i=1:length(sampleBins(1, :))
    accuracyBinsL(i)=mean(nonTimeOutL(intersect(find(splTNonTimeOutL>=sampleBins(1, i)), find(splTNonTimeOutL<sampleBins(2, i)))));
    trialsBinsL(i)=length(nonTimeOutL(intersect(find(splTNonTimeOutL>=sampleBins(1, i)), find(splTNonTimeOutL<sampleBins(2, i)))));
    accuracyBinsR(i)=mean(nonTimeOutR(intersect(find(splTNonTimeOutR>=sampleBins(1, i)), find(splTNonTimeOutR<sampleBins(2, i)))));
    trialsBinsR(i)=length(nonTimeOutR(intersect(find(splTNonTimeOutR>=sampleBins(1, i)), find(splTNonTimeOutR<sampleBins(2, i)))));
end

accuracyBinsL=accuracyBinsL*100;
accuracyBinsR=accuracyBinsR*100;




% % %%
% % 
% 
% figure(3000)
% subplot(131)
% noCenterPokesOn=(data(data(:, 10)==1, 12));
% noCenterPokesOff=(data(data(:, 10)==0, 12));
% ylabel('Percent Attempts Qualified')
% 
% percQualifyingOn=round(length(noCenterPokesOn)/sum(noCenterPokesOn)*10000)/100;
% percQualifyingOff=round(length(noCenterPokesOff)/sum(noCenterPokesOff)*10000)/100;
% hold on
% b1=bar(1, percQualifyingOff);
% set(b1, 'FaceColor', gray);
% if stimPresent==1
%     b2=bar(2, percQualifyingOn);
%     set(b2, 'FaceColor', opsin);
%     text(1.8,percQualifyingOn*1.01, num2str(percQualifyingOn) )
% end
% set(gca, 'xTick', [1, 2])
% set(gca, 'xTickLabel', {'Off', 'On'})
% xlim([0 3])
% text(0.8,percQualifyingOff*1.01, num2str(percQualifyingOff) )
% % ylim([min([percQualifyingOn, percQualifyingOff])*0.9, max([percQualifyingOn, percQualifyingOff])*1.05])
% ylim([0 100])
% 
% 
% subplot(132)
% ylabel('Percent of Trials Qualified')
% 
% hold on
% qualifiedOff=(1-mean(data(find(data(:, 10)==0), 14)))*100;
% qualifiedOn=(1-mean(data(find(data(:, 10)==1), 14)))*100;
% 
% b1=bar(1,qualifiedOff);
% set(b1, 'FaceColor', gray);
% if stimPresent==1
%     b2=bar(2, qualifiedOn);
%     set(b2, 'FaceColor', opsin);
%     text(1.8,qualifiedOn*1.05, num2str(qualifiedOn))
% end
% set(gca, 'xTick', [1, 2])
% set(gca, 'xTickLabel', {'Off', 'On'})
% xlim([0 3])
% text(0.8,qualifiedOff*1.05, num2str(qualifiedOff))
% ylim([0 100])
% 
% 
% 
% subplot(133)
% ylabel('Percent of Trials Qualified')
% 
% hold on
% extraworkOff=sum(data(find(data(:, 10)==0), 12))/length(find(data(:, 10)==0));
% extraworkOn=sum(data(find(data(:, 10)==1), 12))/length(find(data(:, 10)==1));
% 
% b1=bar(1,extraworkOff);
% set(b1, 'FaceColor', gray);
% text(0.8,extraworkOff*1.05, num2str(extraworkOff))
% if stimPresent==1
%     b2=bar(2, extraworkOn);
%     set(b2, 'FaceColor', opsin);
%     text(1.8,extraworkOn*1.05, num2str(extraworkOn))
% end
% set(gca, 'xTick', [1, 2])
% set(gca, 'xTickLabel', {'Off', 'On'})
% xlim([0 3])
% ylim([1 2])
% 


% %%


f2=figure(mouse(1));

set(f2, 'Position', [0, 0, 1600, 1000])
substantialPoints=find(trialsBins>totalNoTrials/20);




subplot(3, 5, 1);
sp1=gca;
hold on
plot(sampleBins(1, :), accuracyBinsL, 'b-')
plot(sampleBins(1, :), accuracyBinsR, 'g-')

plot(sampleBins(1, :), accuracyBins, 'k--o')
plot(sampleBins(1, substantialPoints), accuracyBins(substantialPoints), 'r.')
plot([sampleBins(1, 1), sampleBins(1, end)], [50, 50], 'Color', [0.8, 0.8, 0.8])

ylabel('accuracy')
title('Accuracy breakdown by sampling time','fontweight','bold')


sp7=subplot(3, 5, 7);

hold on
try
    fc=plotHist(splT(correctTrials), samplingTimeBinWidth, 'k', 'k', 1, normalize);
    finc=plotHist(splT(incorrectTrials), samplingTimeBinWidth, 'r', 'r', 1, normalize);
    ymax=max([fc, finc]);
    if halfymax<ymax
        halfymax=ymax;
    end
end
try
[hsCI, psCI]=kstest2(splT(correctTrials), splT(incorrectTrials))
end
title('Correct/incorrect trials','fontweight','bold')


sp12=subplot(3, 5, 12);
hold on
try
    fl=plotHist(splT(leftTrials), samplingTimeBinWidth, 'b', 'b', 1, normalize);
    fr=plotHist(splT(rightTrials), samplingTimeBinWidth, 'g', 'g', 1, normalize);
    ymax=max([fl, fr]);
    if halfymax<ymax
        halfymax=ymax;
    end
    [hsCI, psCI]=kstest2(splT(leftTrials), splT(rightTrials))

end
title('Odor 1/odor 2 trials','fontweight','bold')




sp8=subplot(3, 5, 8);

hold on
try
    fLc=plotHist(splT(leftCorr), samplingTimeBinWidth, 'k', 'k', 1, normalize);
end
try
    fLi=plotHist(splT(leftIncorr), samplingTimeBinWidth, 'r', 'r', 1, normalize);
end
try
        [hsLcLi, psLcLi]=kstest2(splT(leftCorr), splT(leftIncorr))
end
try
    ymax=max([fLc, fLi]);
    if quartymax<ymax
        quartymax=ymax;
    end
end
title('Odor 1','fontweight','bold')




sp9=subplot(3, 5, 9);

hold on
try
fRc=plotHist(splT(rightCorr), samplingTimeBinWidth, 'k', 'k', 1, normalize);

end
try
    fRi=plotHist(splT(rightIncorr), samplingTimeBinWidth, 'r', 'r', 1, normalize);

end

try
    [hsLcLi, psLcLi]=kstest2(splT(rightCorr), splT(rightIncorr))
    ymax=max([fRc, fRi]);

end

if quartymax<ymax
    quartymax=ymax;
end

title('Odor 2','fontweight','bold')




% %%

sp13=subplot(3, 5, 13);


hold on
try
    if stimPresent==1
        fLst=plotHist(splT(leftStim), samplingTimeBinWidth, opsin, opsin, 1, normalize);
    end
    fLus=plotHist(splT(leftUnstim), samplingTimeBinWidth, 'k', 'k', 1, normalize);
end
ymax=max([fLst, fLus]);
if quartymax<ymax
    quartymax=ymax;
end




% %%
sp14=subplot(3, 5, 14);

hold on

try
    if stimPresent==1 
        fRst=plotHist(splT(rightStim), samplingTimeBinWidth, opsin, opsin, 1, normalize);    
        [hsROnROff, psROnROff]=kstest2(splT(rightStim), splT(rightUnstim))
    end
    if quartymax<ymax
        quartymax=ymax;
    end
end
    fRus=plotHist(splT(rightUnstim), samplingTimeBinWidth, 'k', 'k', 1, normalize);

if stimPresent==1
    text(median(splT)+std(splT), ymax*1.5, ['Light On, ', num2str( round(10000*mean(data(rightStim, 3)))/100), '% correct'], 'Color', opsin)
    text(median(splT)+std(splT), ymax*1.1, ['Light On mean ST ', num2str( round(100*mean(splT(rightStim)))/100), 's'], 'Color', opsin)
    text(median(splT)+std(splT), ymax*0.9, ['ks Test h = ', num2str(hsROnROff), ' p = ', num2str(psROnROff)], 'Color', 'k')
        ymax=max([fRst, fRus, fLst, fLus]);

end
text(median(splT)+std(splT), ymax*1.3, ['Light Off mean ST ', num2str( round(100*mean(splT(rightUnstim)))/100), 's'], 'Color', 'k')
text(median(splT)+std(splT), ymax*1.7, ['Light Off, ', num2str(round(10000* mean(data(rightUnstim, 3)))/100), '% correct'], 'Color', 'k')
title('Odor 2','fontweight','bold')


subplot(sp13)

if stimPresent==1
    text(median(splT)+std(splT), ymax*1.5, ['Light On, ', num2str( round(10000*mean(data(leftStim, 3)))/100), '% correct'], 'Color', opsin)
    text(median(splT)+std(splT), ymax*1.1, ['Light On mean ST ', num2str( round(100*mean(splT(leftStim)))/100), 's'], 'Color', opsin)
    try
    [hsLOnLOff, psLOnLOff]=kstest2(splT(leftStim), splT(leftUnstim))
    text(median(splT)+std(splT), ymax*0.9, ['ks Test h = ', num2str(hsLOnLOff), ' p = ', num2str(psLOnLOff)], 'Color', 'k')
    end
end
text(median(splT)+std(splT), ymax*1.7, ['Light Off, ', num2str(round(10000* mean(data(leftUnstim, 3)))/100), '% correct'], 'Color', 'k')
text(median(splT)+std(splT), ymax*1.3, ['Light Off mean ST ', num2str( round(100*mean(splT(leftUnstim)))/100), 's'], 'Color', 'k')



title('Odor 1','fontweight','bold')



    
    
    
splTNonTimeOutOn=data(intersect(find(data(:, 10)==1), find(data(:, 3)~=-1)), 4);
splTNonTimeOutOff=data(intersect(find(data(:, 10)==0), find(data(:, 3)~=-1)), 4);
nonTimeOutOn=data(intersect(find(data(:, 10)==1), find(data(:, 3)~=-1)), 3);
nonTimeOutOff=data(intersect(find(data(:, 10)==0), find(data(:, 3)~=-1)), 3);

accuracyBinsOn=[];
trialsBinsOn=[];
accuracyBinsOff=[];
trialsBinsOff=[];

for i=1:length(sampleBins(1, :))
    accuracyBinsOn(i)=mean(nonTimeOutOn(intersect(find(splTNonTimeOutOn>=sampleBins(1, i)), find(splTNonTimeOutOn<sampleBins(2, i)))));
    trialsBinsOn(i)=length(nonTimeOutOn(intersect(find(splTNonTimeOutOn>=sampleBins(1, i)), find(splTNonTimeOutOn<sampleBins(2, i)))));
    accuracyBinsOff(i)=mean(nonTimeOutOff(intersect(find(splTNonTimeOutOff>=sampleBins(1, i)), find(splTNonTimeOutOff<sampleBins(2, i)))));
    trialsBinsOff(i)=length(nonTimeOutOff(intersect(find(splTNonTimeOutOff>=sampleBins(1, i)), find(splTNonTimeOutOff<sampleBins(2, i)))));
end

accuracyBinsOn=accuracyBinsOn*100
accuracyBinsOff=accuracyBinsOff*100

% %%
sp6=subplot(3, 5, 6);

hold on
plot(sampleBins(1, :), accuracyBinsOn, 'o-', 'Color', opsin)
plot(sampleBins(1, :), accuracyBinsOff, 'ko-')
l1=legend('Light On', 'Light Off');
set(l1, 'FontSize', 8);
plot([sampleBins(1, 1), sampleBins(1, end)], [50, 50], 'Color', [0.8, 0.8, 0.8])
ylabel('accuracy')
title('Accuracy by stimulation','fontweight','bold')
% %%
sp2=subplot(3, 5, 2);
hold on
try
foff=plotHist(splT(unstimTrials), samplingTimeBinWidth, 'k', 'k', 1, normalize);
    if stimPresent==1
    fon=plotHist(splT(stimTrials), samplingTimeBinWidth, opsin, opsin, 1, normalize);
    [hsOnOff, psOnOff]=kstest2(splT(stimTrials), splT(unstimTrials))
    ymax=max([fon, foff]);
    else 
        ymax=max(foff)
   end
if halfymax<ymax
    halfymax=ymax;
end
end
if stimPresent==1
    text(median(splT)+std(splT), ymax*1.5, ['Light On, ', num2str( round(10000*mean(data(stimTrials, 3)))/100), '% correct'], 'Color', opsin)
    text(median(splT)+std(splT), ymax*1.1, ['Light On mean ST ', num2str( round(100*mean(splT(stimTrials)))/100), 's'], 'Color', opsin)
    text(median(splT)+std(splT), ymax*0.9, ['ks Test h = ', num2str(hsOnOff), ' p = ', num2str(psOnOff)], 'Color', 'k')
end
text(median(splT)+std(splT), ymax*1.7, ['Light Off, ', num2str(round(10000* mean(data(unstimTrials, 3)))/100), '% correct'], 'Color', 'k')
text(median(splT)+std(splT), ymax*1.3, ['Light Off mean ST ', num2str( round(100*mean(splT(unstimTrials)))/100), 's'], 'Color', 'k')

title('Stim/Unstim trials','fontweight','bold')
 
% %%
sp3=subplot(3, 5, 3);

if stimPresent==1

    hold on
    try
        fstc=plotHist(splT(stimCorr), samplingTimeBinWidth, 'k', 'k', 1, normalize);
        fstinc=plotHist(splT(stimIncorr), samplingTimeBinWidth, 'r', 'r', 1, normalize);
        [hsLcLi, psLcLi]=kstest2(splT(stimCorr), splT(stimIncorr))
        ymax=max([fstc, fstinc]);
        if quartymax<ymax
            quartymax=ymax;
        end
    end
end
title('Stim Trials','fontweight','bold')



sp4=subplot(3, 5, 4);


hold on
try
fusc=plotHist(splT(unstimCorr), samplingTimeBinWidth, 'k', 'k', 1, normalize);
fusinc=plotHist(splT(unstimIncorr), samplingTimeBinWidth, 'r', 'r', 1, normalize);
[hsLcLi, psLcLi]=kstest2(splT(unstimCorr), splT(unstimIncorr))

ymax=max([fusc, fusinc]);
if quartymax<ymax
    quartymax=ymax;
end
end

title('Unstim Trials','fontweight','bold')


sp5=subplot(3, 5, 5);

hold on
stimShortTrials=intersect(stimTrials, find((splT<valveSwitch)));
stimLongTrials=intersect(stimTrials, find((splT>valveSwitch)));
unstimShortTrials=intersect(unstimTrials, find((splT<valveSwitch)));
unstimLongTrials=intersect(unstimTrials, find((splT>valveSwitch)));

b1=bar([3, 9], [mean(score(unstimShortTrials)*100), mean(score(unstimLongTrials)*100)],  0.3, 'Facecolor', gray)
b2=bar([5, 11], [mean(score(stimShortTrials)*100), mean(score(stimLongTrials)*100)], 0.3,  'Facecolor', opsin)

set(gca, 'xTick', [3, 5, 9, 11])
set(gca, 'xTickLabel', {'S', 'S', 'L', 'L'})


sp11=subplot(3, 5, 11);

hold on
for i=1:length(sampleBins(1, :))
    try
    plot(sampleBins(1, i), accuracyBinsOn(i), '.', 'Color', opsin, 'MarkerSize', trialsBinsOn(i)*300/sum(trialsBins));
    plot(sampleBins(1, i), accuracyBinsOff(i), '.', 'Color', 'k', 'MarkerSize', trialsBinsOff(i)*300/sum(trialsBins));
    end
end
plot([sampleBins(1, 1), sampleBins(1, end)], [50, 50], 'Color', [0.8, 0.8, 0.8])

xlabel('sampling time/s')
ylabel('accuracy')
title('scatter plot')


sp10=subplot(3, 5, 10)
if stimPresent==1
    rxst=plotHist(rxnT(stimTrials), samplingTimeBinWidth, opsin, opsin, 1, normalize);
    [hsrxnOnOff, psrxnOnOff]=kstest2(rxnT(stimTrials), rxnT(unstimTrials))
    text(median(rxnT)+std(rxnT), ymax*0.9, ['ks Test h = ', num2str(hsrxnOnOff), ' p = ', num2str(psrxnOnOff)], 'Color', 'k')
end

rxus=plotHist(rxnT(unstimTrials), samplingTimeBinWidth, 'k', 'k', 1, normalize);

xlim([0 2 ])
xlabel('reaction time/s')


sp15=subplot(3, 5, 15);

noCenterPokesOn=(data(data(:, 10)==1, 12));
noCenterPokesOff=(data(data(:, 10)==0, 12));

percQualifyingOn=round(length(noCenterPokesOn)/sum(noCenterPokesOn)*10000)/100;
percQualifyingOff=round(length(noCenterPokesOff)/sum(noCenterPokesOff)*10000)/100;
hold on
b1=bar(1, percQualifyingOff);
% b3=bar(4, mean(data(find(data(:, 10)==0), 14)));
set(b1, 'FaceColor', gray);
if stimPresent==1
    b2=bar(2, percQualifyingOn);
    set(b2, 'FaceColor', opsin);
%     b4=bar(5, mean(data(find(data(:, 10)==1), 14)));
%     set(b4, 'FaceColor', opsin);
    text(1.8,percQualifyingOn*1.01, num2str(percQualifyingOn) )
end
set(gca, 'xTick', [1, 2, 4, 5])
set(gca, 'xTickLabel', {'Off', 'On', 'Off', 'On'})
text(0.8,percQualifyingOff*1.01, num2str(percQualifyingOff) )
ylim([min([percQualifyingOn, percQualifyingOff])*0.9, max([percQualifyingOn, percQualifyingOff])*1.05])

title('Percentage of qualified center pokes during trial avail')


% %%
%cosmetic adjustments

allSampTimePlots=[1:4, 6:9, 11:14];
allcIncPlots=[3, 4, 7, 8, 9];
allPerfPlots=[1, 6, 11, 5, 15];
allShortPlots=[3, 4, 8, 9, 13, 14];
allTallPlots=[2, 7, 10, 12];
allStimNonStimPlots=[2, 13, 14];

ymaxOverall(allShortPlots)=quartymax;
ymaxOverall(allTallPlots)=halfymax;
ymaxOverall(allPerfPlots)=200;
if cue1Species==0
    cue1Color=[1, 1, 1];
    cue2Color=[0.98, 0.98, 1];
    subplot(sp1);
    tC1=text(mean([odorOnset, valveSwitch]), 90, 'Blank')
    tC2=text(mean([valveSwitch, qualifying]), 90, 'Cue 1')
end
if cue1Species==1
    cue1Color=[0.98, 0.98, 1];
    cue2Color=[1, 1, 0.95];
    subplot(sp1);
    tC1=text(mean([odorOnset, valveSwitch]), 90, 'Cue 1')
    tC2=text(mean([valveSwitch, qualifying]), 90, 'Cue 2')
end

for plotnumber=allSampTimePlots
    try
       subplot(eval(['sp', num2str(plotnumber)]))
       hold on


       if valveSwitch>0.05
            plot([valveSwitch valveSwitch], [0 ymaxOverall(plotnumber)*5], 'LineWidth', 0.5, 'Color', blue)
       end

        plot([odorOnset odorOnset], [0 ymaxOverall(plotnumber)*5],  'LineWidth', 0.5,'Color', gray)
        plot([qualifying qualifying], [0 ymaxOverall(plotnumber)*5],  'LineWidth', 0.5,'Color', orange)
        fill1=fill([odorOnset odorOnset, valveSwitch, valveSwitch], [0 ymaxOverall(plotnumber)*5, ymaxOverall(plotnumber)*5, 0], cue1Color);
        fill2=fill([valveSwitch valveSwitch, qualifying, qualifying], [0 ymaxOverall(plotnumber)*5, ymaxOverall(plotnumber)*5, 0], cue2Color);
        uistack(fill1,'bottom')
        uistack(fill2,'bottom')

        if ismember(plotnumber, allcIncPlots)
            text(median(splT(rightCorr))+std(splT(rightCorr)), ymaxOverall(plotnumber)*1.5, 'Incorrect Trials', 'Color', 'r')
            text(median(splT(rightCorr))+std(splT(rightCorr)), ymaxOverall(plotnumber)*1.3, 'Correct Trials', 'Color', 'k')
        end


        if plotnumber==12
            text(median(splT(rightCorr))+std(splT(rightCorr)), ymaxOverall(plotnumber)*1.5, 'Odor 1 Trials', 'Color', 'b')
            text(median(splT(rightCorr))+std(splT(rightCorr)), ymaxOverall(plotnumber)*1.3, 'Odor 2 Trials', 'Color', 'g')
        end

        ylabel('count')
        xlabel('sampling time/s')
        xlim([0, maxSamplingTime])
        if plotnumber==10
            xlabel('transit time/s')
            xlim([0, max(rxnT)])

        end
            
        if ismember(plotnumber, allPerfPlots)
        ylim([0 100])
        xlim([0, maxSamplingTime])
        plot([0, maxSamplingTime], [50, 50], 'Color', [0.8, 0.8, 0.8])

        else
        ylim([0 ymaxOverall(plotnumber)*1.7])
        end
    end
end

percentCorrectLeft=round(length(leftCorr)/length(leftTrials)*100);
percentCorrectRight=round(length(rightCorr)/length(rightTrials)*100);


percentCorrectLeftOn=round(length(leftStimCorr)/length(leftStim)*100);
percentCorrectRightOn=round(length(rightStimCorr)/length(rightStim)*100);


percentCorrectLeftOff=round(length(leftUnstimCorr)/length(leftUnstim)*100);
percentCorrectRightOff=round(length(rightUnstimCorr)/length(rightUnstim)*100);

percentLeftChoiceOn=round(100*mean(data(stimTrials, 2)));
percentLeftChoiceOff=round(100*mean(data(unstimTrials, 2)));
percentLeftChoice=round(100*mean(data(:, 2)));


suptitle({['mouse # ' num2str(mouse),'  session ' datestr(data(1, 7)) , ':',...
    datestr(data(end, 7)), '   ', ' Trials: [', num2str([startEnd(1), startEnd(3)]), ']  valve', num2str(data(1, 16)*1000), 'ms ', ...
     num2str(length(data(:, 1))), ' trials total: ', ], [num2str(length(correctTrials)), ' correct /  ', num2str(length(incorrectTrials)), ' incorrect     ', ...
    'bias(% left choice) : ' num2str(percentLeftChoice), ' On   ', num2str(percentLeftChoiceOn), '  Off  ' , num2str(percentLeftChoiceOff)]})

%
fprintf(['\n',  num2str(length(correctTrials)),' correct trials ', ...
    '\n', num2str(length(incorrectTrials)), ' incorrect trials ',...
    '\n'])
fprintf([num2str(100*length(correctTrials)/(length(incorrectTrials)+length(correctTrials))), ' percent correct', '\n'])
% %%
mkdir(imagepath)

fnam1=[imagepath,'\', num2str(mouse), '_', datestr(data(1, 7)), 'valve', num2str(data(1, 16)*1000), '_ms_', num2str(data(1, 4)), '_', 'performance.png']; % your file name
% fnam2=[imagepath,  'byMouse\', num2str(mouse), '\', num2str(mouse), '_', datestr(data(1, 7)), datestr(data(end, 7)), num2str(data(1, 4)), '_', 'performance.png']; % your file name
% %%
snam='figure'; % note: NO extension...
s=hgexport('readstyle',snam);
s.Format='png';
hgexport(f2,fnam1,s);
% hgexport(f2,fnam2,s);
