


set(0,'DefaultAxesFontName', 'Arial')
set(0,'DefaultAxesFontSize', 12)

% Change default text fonts.
set(0,'DefaultTextFontname', 'Arial')
set(0,'DefaultTextFontSize', 12)

close all

% clean up directory and find all files in range
F=0;
delete '.DS_Store';
D = dir;

info=zeros(length(D), 3);
for i=3:length(D)
    info(i, 1)=str2num(D(i).name(4:6));
    info(i, 2)=datenum(D(i).name(8:15), 'dd-mm-yy');
end

info(1:2, :)=[];
info(:, 2)=info(:, 2)-min(info(:, 2))+1;
info(:, 3)=[1:length(info(:, 1))];

[info(:, 2), I]=sort(info(:, 2));
info(:, 2)=round(info(:, 2));
info(:, 1)=info(I, 1);
info(:, 3)=info(I, 3);


mouse=input('which mouse ');
day=input('which day ');
bigSize=input('what big size ');

if mean(day)==0 && mean(mouse)~=0
indrange=info(ismember(info(:, 1), mouse), 3);
elseif mean(mouse)==0 && mean(day)~=0
indrange=info(ismember(info(:, 2),day), 3);
elseif mean(mouse)==0 && mean(day)==0
    indrange=info(:, 3);
else
indrange=info(ismember(info(:, 1), mouse), 3);
indrange2=info(ismember(info(:, 2),day), 3);
indrange=intersect(indrange, indrange2);
end
data=[];
infoMouse=[];
for m=1: length(indrange)

filename= D(indrange(m)+2).name
    

[e, a]=extractOlfData(filename);
info(info(:, 3)==indrange(m), 4)=e.bigSize;
info(info(:, 3)==indrange(m), 5)=max([3*max(e.leftDecisionTTL),1*max(e.cueSampledTTL),2*max(e.cueOnTTL)]);
info(info(:, 3)==indrange(m), 6)= a.rewardCollected;

odor=[];
delayD=[];

leftDelay=e.leftRewardDelay(a.validTrials);
rightDelay=e.rightRewardDelay(a.validTrials);
s=size(leftDelay);
if s(1)==1
    leftDelay=leftDelay';
    rightDelay=rightDelay';
end
side=a.side(:, 1);
actualDelay=sum(a.side.*[leftDelay, rightDelay], 2);
leftRewardSize=e.leftRewardSizeTotal(a.validTrials)/0.03;
rightRewardSize=e.rightRewardSizeTotal(a.validTrials)/0.03;
infoMouse=[infoMouse; info(info(:, 3)==indrange(m),:)];


<<<<<<< HEAD
leftActualDelay=leftDelay.*side;
rightActualDelay=rightDelay.*(1-side);
actualDelaySigned=leftActualDelay-rightActualDelay;
actualDelay=leftActualDelay+rightActualDelay;
previousSide=[0; side(1:end-1)];
previousTrialDelay=[0; actualDelaySigned(1:end-1)];

previousTrialDelayCase=(leftActualDelay>mean(actualDelay))*3-(rightActualDelay>mean(actualDelay))*3;
case2L=intersect(find(leftActualDelay>0), find(leftActualDelay<=mean(actualDelay)));
case2R=intersect(find(rightActualDelay>0), find(rightActualDelay<=mean(actualDelay)));
previousTrialDelayCase(case2L)=2;
previousTrialDelayCase(case2R)=-2;
case1=find(previousTrialDelayCase==0);
case1L=intersect(find(side==1), case1);
case1R=intersect(find(side==0), case1);
previousTrialDelayCase(case1L)=1;
previousTrialDelayCase(case1R)=-1;

previousTrialDelayCase=[1; previousTrialDelayCase(1:end-1)];


data=[data;leftDelay, rightDelay, side,leftRewardSize, rightRewardSize,  a.validTrials, m*ones(length(a.validTrials), 1), leftDelay-rightDelay, leftDelay./(leftDelay+rightDelay), leftRewardSize-rightRewardSize, e.cueSampledTTL(a.validTrials), e.cueOnTTL(a.validTrials), a.travelTime(a.validTrials-min(a.validTrials)+1), a.reactionTime(a.validTrials-min(a.validTrials)+1), previousTrialDelay, previousTrialDelayCase, previousSide];
=======
data=[data;leftDelay, rightDelay, side,leftRewardSize, rightRewardSize,  a.validTrials, m*ones(length(a.validTrials), 1), leftDelay-rightDelay, leftDelay./(leftDelay+rightDelay), leftRewardSize-rightRewardSize, 3*e.leftDecisionTTL(a.validTrials)+2*e.cueSampledTTL(a.validTrials)+e.cueOnTTL(a.validTrials), a.travelTime(a.validTrials-min(a.validTrials)+1), a.reactionTime(a.validTrials-min(a.validTrials)+1)];
>>>>>>> FETCH_HEAD
% 
% [leftSide, rightSide, delayDiffSide, delayRatioSide]=odorDelayPlot(leftDelay, rightDelay, side);
% title(filename)

% plot(delayDiffSet, delayD(:, 1)./delayD(:, 2),'o',delayDiffSet,yfit./delayD(:, 2),'-','LineWidth',2)
assignin('base', ['info' e.mouseID(end-2:end)], infoMouse);
assignin('base', ['data' e.mouseID(end-2:end)], data);
<<<<<<< HEAD



% save(['C:\Users\user\Desktop\OD\MatFiles\' e.mouseID(end-2:end) '.mat'],['info' e.mouseID(end-2:end)] , ['data' e.mouseID(end-2:end)])
a.rewardCollected
length(a.validTrials)
=======
save(['C:\Users\user\Desktop\OD\MatFiles\' e.mouseID(end-2:end) '.mat'],['info' e.mouseID(end-2:end)] , ['data' e.mouseID(end-2:end)])
a.rewardCollected
a.rewardPokeOut
>>>>>>> FETCH_HEAD
end

<<<<<<< HEAD
%
if mean(info(:,5))>0
columnAna=input('what column to analyze? ')+10;
columnIg=input('what column to ignore? ')+10;
    stimTime=2;
else
    columnAna=5;
    stimTime=0;
    
    columnIg=0; 
end
 % %
% stimTime=0;
% columnIg=0;
% columnAna=16;
=======
close all
data=[];
bigSize=2;
stimTime=2;
f=pwd;
mice =[381];
runSessionsStart=1;
>>>>>>> FETCH_HEAD

mice =mouse;

<<<<<<< HEAD
close all
 data=[];
f=pwd;
runSessionsStart=1;

for j=1:length(mice)    
    info1=eval(['info',num2str(mice(j))]);
=======
for j=1:length(mice)    
    info1=eval(['info',num2str(mice(j))])
>>>>>>> FETCH_HEAD
    data1=eval(['data', num2str(mice(j))]);
    days=[max(info1(:, 2))-200:max(info1(:, 2))]';
    c=intersect(info1(:, 2), days);
    ia=[];
    for i=1:length(c)
    ia=[ia; find(info1(:, 2)==c(i))];
    end
<<<<<<< HEAD
    sessions=intersect(intersect(find(info1(:, 4)==bigSize), find(info1(:, 5)==stimTime)), ia);
    %     sessions=intersect(find(info1(:, 5)==stimTime), ia);
 for i=runSessionsStart:length(sessions)
=======
    sessions=intersect(intersect(find(info1(:, 4)==bigSize), find(info1(:, 5)==stimTime)), ia)
%     sessions=intersect(find(info1(:, 5)==stimTime), ia);
    for i=runSessionsStart:length(sessions)
>>>>>>> FETCH_HEAD
data=[data; data1(find(data1(:,7)==sessions(i)), :)];  
    end
end
numberOfTrials=length(data)
<<<<<<< HEAD
=======
  
f1=figure(1);
set(f1, 'Position', [200, 200,1100, 500])
>>>>>>> FETCH_HEAD


[bg,DEV,STATS, intercept, result]=plotLogitThings(data,3, 8, columnAna, columnIg, 1)
bg
pvalue=STATS.p
intercept


f1=figure(1);

subplot(221)
axis square
% [coefficients, deviances, regressionStats] = glmfit(data(:, [8, 10, 11]), data(:, 3), 'binomial', 'link', 'logit');
% [ax, lineHandles, patchHandles]=plotLogisticRegression(coefficients, regressionStats, data, [8, 10, 11], 8, [10, 11]);
% 
% [regressionStats.beta, regressionStats.p]

[bg,DEV,STATS, intercept, result]=plotLogitThings(data,3, 8, columnAna, columnIg, 1);
xlabel('(Left Delay-Right Delay)/s');
ylabel('Preference for left side');
bg
pvalue=STATS.p
intercept
try
for i=1:length(bg(1, :))
text(3, 1-i*0.1, [num2str(round(bg(2,i)*1000)/1000), '(',num2str(round(STATS.p(2, i)*1000)/1000) ')'])
text(3, 1-i*0.05, [num2str(round(bg(1,i)*1000)/1000), '(',num2str(round(STATS.p(1, i)*1000)/1000) ')'])
end
end
xlim([-10 10])
subplot(222)
hold on
axis square
if columnIg~=0
data2=data(data(:, columnIg)==0,:);
else
    data2=data;
end
[coefficients, deviances, regressionStats] = glmfit(data2(:, [8, columnAna]), data2(:, 3), 'binomial', 'link', 'logit');
[ax, lineHandles, patchHandles]=plotLogisticRegression(coefficients, regressionStats, data2, [8, columnAna], 8, columnAna);
l=line([-10, 10], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])
text(3, .85, ['p = ' num2str(round(regressionStats.p(3)*1000)/1000)])
text(3, .9, ['B = ' num2str(round(regressionStats.beta(3)*1000)/1000)])

[regressionStats.beta, regressionStats.p]

xlabel('(Left Delay-Right Delay)/s');
ylim([0 1])


figure(1)


<<<<<<< HEAD
subplot(223)
axis square
dataA=data2(data2(:, 8)>=0, :);

[bg,DEV,STATS, intercept, result]=plotLogitThings(dataA,3, 8, columnAna, columnIg, 1);
xlabel('(Left Delay-Right Delay)/s');
ylabel('Preference for left side');
bg
pvalue=STATS.p
intercept
try
for i=1:length(bg(1, :))
text(3, 1-i*0.1, [num2str(round(bg(2,i)*10000)/10000), '(',num2str(round(STATS.p(2, i)*10000)/10000) ')'])
text(3, 1-i*0.05, [num2str(round(bg(1,i)*10000)/10000), '(',num2str(round(STATS.p(1, i)*10000)/10000) ')'])
end
end

subplot(224)
axis square
[coefficients, deviances, regressionStats] = glmfit(dataA(:, [8, columnAna]), dataA(:, 3), 'binomial', 'link', 'logit');
[ax, ~, patchHandles]=plotLogisticRegression(coefficients, regressionStats, dataA, [8, columnAna], 8, columnAna);
[coefficients, deviances, regressionStats] = glmfit(dataA(:, [8, columnAna]), dataA(:, 3), 'binomial', 'link', 'logit');
[ax, lineHandles, patchHandles]=plotLogisticRegression(coefficients, regressionStats, dataA, [8, columnAna], 8, columnAna);
l=line([-0, 10], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])
text(3, .85, ['p = ' num2str(round(regressionStats.p(3)*10000)/10000)])
text(3, .9, ['B = ' num2str(round(regressionStats.beta(3)*10000)/10000)])



suptitle(['mouse #' num2str(mice) ', number of trials=' num2str(length(data(:, 1))), ', big reward=' num2str(bigSize), ' x small reward']);


%
f=figure(2);
set(f, 'Position', [0, 0, 750, 800])
[leftSide, rightSide, delayDiffSide, xyzP, rightD3elayShift, leftDelayShift]=odorDelayPlot(data, columnAna, columnIg);





%%
    
figure(3);
subplot(221)
plotLinThings(data, 13,  8, columnAna, 1)
=======
f2=figure(2);
set(f2, 'Position', [200, 200,1100, 500])
subplot(121)
plotLinThings(data, 12,  8, 11, 1)
>>>>>>> FETCH_HEAD
xlabel('(Left Delay-Right Delay)/s');
ylabel('travel time/s')


ylim([0 2])
if columnIg~=0

diff=data(:, columnAna)-data(:, columnIg);
else
    diff=data(:, columnAna);
end
tvl0=data(diff==0, 13);
tvl1=data(find(diff==1), 13);
tvl2=data(find(diff==-1), 13);
tvl0(tvl0>10)=[];
tvl1(tvl1>10)=[];
tvl2(tvl2>10)=[];
tvl0(tvl0<=0)=[];
tvl1(tvl1<=0)=[];
tvl2(tvl2<=0)=[];


% plot([0 1 2 3],[mean(tvl0), mean(tvl1), mean(tvl2), mean(tvl3)],  '*-')
% hold on
% plot([0 1 2 3],[var(tvl0)+mean(tvl0),var(tvl1)+mean(tvl1), var(tvl2)+mean(tvl2), var(tvl3)+mean(tvl3)],  '*-')
% ylim([0 1])
% xlim([-1 3])
axis square 
subplot(222)
axis square 
hold on
% no shoot
plotHist(tvl0, .05, 'r', 'r', 1);
%sample
plotHist(tvl1, .05, 'c', 'c', 1);
% cueon
plotHist(tvl2, .05, 'g', 'g', 1);

xlabel('travel time/s')

xlim([0 2])
suptitle(['mouse #' num2str(mice) ', number of trials=' num2str(length(data(:, 1))), ', big reward=' num2str(bigSize), ' x small reward']);



<<<<<<< HEAD
f1=figure(3);
subplot(223)
plotLinThings(data, 14,  8, columnAna, 1)
=======
f3=figure(3);
set(f3, 'Position', [200, 200,1100, 500])
subplot(121)
plotLinThings(data, 13,  8, 11, 1)
>>>>>>> FETCH_HEAD
xlabel('(Left Delay-Right Delay)/s');
ylabel('sampling time/s')

ylim([0 3])

rxn0=data(find(diff==0), 14);
rxn1=data(find(diff==1), 14);
rxn2=data(find(diff==-1), 14);
rxn0(rxn0>10)=[];
rxn1(rxn1>10)=[];
rxn2(rxn2>10)=[];
rxn0(rxn0<=0.3)=[];
rxn1(rxn1<=0.3)=[];
rxn2(rxn2<=0.3)=[];
% 
% plot([0 1 2 3],[mean(rxn0), mean(rxn1), mean(rxn2), mean(rxn3)],  '*-')
% hold on
% plot([0 1 2 3],[var(rxn0)+mean(rxn0),var(rxn1)+mean(rxn1), var(rxn2)+mean(rxn2), var3(rxn3)+mean(rxn3)],  '*-')
% ylim([0 1])
% xlim([-1 3])
axis square 
subplot(224)
axis square 
hold on

plotHist(rxn0, .05, 'r', 'r', 1);
xlabel('sampling time/s')
% sample
plotHist(rxn1, .05, 'c', 'c', 1);
% cueon
plotHist(rxn2, .05, 'g', 'g', 1);
xlim([0 2])
suptitle(['mouse #' num2str(mice) ', number of trials=' num2str(length(data(:, 1))), ', big reward=' num2str(bigSize), ' x small reward']);
set(findall(f1,'type','text'), 'fontWeight','bold')
suptitle(['mouse #' num2str(mice) ', number of trials=' num2str(length(data(:, 1))), ', big reward=' num2str(bigSize), ' x small reward']);

% print('-depsc','-r200',['C:\Users\user\Desktop\OD\Graphs\#' num2str(mice) '_samptime_bigsize', num2str(num2str(bigSize)), '_laser_', num2str(stimTime)])


<<<<<<< HEAD
=======
[leftSide, rightSide, delayDiffSide, delayRatioSide, xyzP]=odorDelayPlot(data);
figure(1)
suptitle(num2str(mouse))

figure(2)
subplot(331)
qqplot(actualDelay, leftDelay)
xlabel('actualDelay')
ylabel('leftDelay')
subplot(332)
qqplot(actualDelay, rightDelay)
xlabel('actualDelay')
ylabel('rightDelay')
subplot(334)
fakeChoice=round(rand(length(a.validTrials), 1));
randomDelay=sum([fakeChoice, 1-fakeChoice].*[leftDelay, rightDelay], 2);
qqplot(randomDelay, leftDelay)
xlabel('randomDelay')
ylabel('leftDelay')
subplot(335)
qqplot(randomDelay, rightDelay)
xlabel('randomDelay')
ylabel('rightDelay')

subplot(333)
qqplot(actualDelay, randomDelay)
xlabel('actualDelay')
ylabel('randomDelay')

subplot(336)
hold on
plotHist(randomDelay, 0.5, 'k', 'k', 1);
ylim([0, 70])
subplot(337)
>>>>>>> FETCH_HEAD

fprintf('\n\n\nkstests for traveling time\n')
[h, p]=kstest2(tvl0, tvl1);
fprintf(['\n tvl0 tvl1 ', num2str([h, p]), '\n'])
[h, p]=kstest2(tvl0, tvl2);
fprintf(['\ntvl0 tvl2 ', num2str([h, p]), '\n'])


fprintf('\n\n\nkstests for sampling time\n')
[h, p]=kstest2(rxn0,rxn1);

fprintf(['\n rxn0 rxn1 ', num2str([h, p]), '\n'])
[h, p]=kstest2(rxn0,rxn2);

<<<<<<< HEAD
fprintf(['\n rxn0 rxn2 ', num2str([h, p]), '\n'])

% 
% figure(2)
% suptitle(num2str(mouse))
% 435
% figure(2)
% subplot(331)
% qqplot(actualDelay, leftDelay)
% xlabel('actualDelay')
% ylabel('leftDelay')
% subplot(332)
% qqplot(actualDelay, rightDelay)
% xlabel('actualDelay')
% ylabel('rightDelay')
% subplot(334)
% fakeChoice=round(rand(length(a.validTrials), 1));
% randomDelay=sum([fakeChoice, 1-fakeChoice].*[leftDelay, rightDelay], 2);
% qqplot(randomDelay, leftDelay)
% xlabel('randomDelay')
% ylabel('leftDelay')
% subplot(335)
% qqplot(randomDelay, rightDelay)
% xlabel('randomDelay')

% ylabel('rightDelay')
% 
% subplot(333)
% qqplot(actualDelay, randomDelay)
% xlabel('actualDelay')
% ylabel('randomDelay')
% 
% subplot(336)
% hold on
% plotHist(randomDelay, 0.5, 'k', 'k', 1);
% ylim([0, 70])
% subplot(337)
% 
% plotHist(leftDelay, 0.5, 'g', 'g', 1);
% ylim([0, 70])
% 
% subplot(338)
% ylim([0, 70])
% 
% plotHist(rightDelay, 0.5, 'r', 'r', 1);
% ylim([0, 70])
% 
% subplot(339)
% ylim([0, 70])
% 
% plotHist(actualDelay, 0.5, 'b', 'b', 1);
%%
=======
plotHist(actualDelay, 0.5, 'b', 'b', 1);

>>>>>>> FETCH_HEAD
f3=figure(3);
set(f3, 'Position', [600, 600, 1000, 250])

subplot(131)
x1=xyzP(:, 1);
x2=xyzP(:, 2);
y=xyzP(:, 3);
X = [ones(size(x1)) x1 x2 x1.*x2];
% X = [ones(size(x1)) x1 x2 x1./(x1+x2)];
% X = [ones(size(x1)) x1 x2 x1./(x1+x2)  x2./(x1+x2)];
% X = [ones(size(x1)) x1 x2];
[b ,BINT,R,RINT,STATS]= regress(y,X);
b
STATS

scatter3(x1,x2,y,'filled')
zlim([0 1])
hold on
x1fit = min(x1):.01:max(x1);
x2fit = min(x2):.01:max(x2);
[X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT+ b(4)*X1FIT.*X2FIT;
% YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X1FIT./(X1FIT+X2FIT);
% YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X1FIT./(X1FIT+X2FIT)+ b(5)*X2FIT./(X1FIT+X2FIT);
% YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT;

colormap(april)

mesh(X1FIT,X2FIT,YFIT)
view(0,90)
xlabel('left')
ylabel('right')
zlabel('left preference')


subplot(132)
hist(R)
title('distribution of residuals')

subplot(133)
qqplot(R)

xxx=data(:, 1:2);
yyy=data(:, 3);
[bg,DEV,STATS] = glmfit(xxx, yyy, 'binomial', 'link', 'logit')
xx=linspace(0,10)';
xc=ones(length(xx), 1);
f4=figure(4)
set(f4, 'Position', [0, 0, 1200, 250])

for i=0:10
    figure(4)
    subplot(141)
    hold on

yfit = glmval(bg, [xx, xc*i], 'logit', 'size', 1);
plot(linspace(0,10)', yfit, '-')
    subplot(142)
    hold on

yfit = glmval(bg, [xc*i, xx], 'logit', 'size', 1);
plot(linspace(0,10)', yfit, 'r-')

end
    subplot(141)
    hold on
l=line([0 8], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])
plot(leftSide(:, 1), leftSide(:, 2), '*')
ylim([0 1])
title('stepping through right reward delay')
xlabel('left reward delay/s')
ylabel('preference for left')
    subplot(142)
hold on
l=line([0 8], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])
plot(rightSide(:, 1), 1-rightSide(:, 2), '*')
ylim([0 1])
xlabel('right reward delay/s')
ylabel('preference for left')
title('stepping through left reward delay')

    subplot(143)
x1fit = min(x1):.01:max(x1);
x2fit = min(x2):.01:max(x2);
[X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
xpred = [X1FIT(:), X2FIT(:)];
ypred=glmval(bg, xpred, 'logit', 'size', 1);
Ypred = reshape(ypred,length(x2fit),length(x1fit));
zlim([0 1])
colormap(april)

mesh(x1fit,x2fit, Ypred)
view(0,90)
xlabel('left')
ylabel('right')
zlabel('left preference')

hold on
scatter3(x1,x2,y,'filled')

subplot(144)
%calculate 0.5 intercepts
leftDelayFixed=unique(leftDelay);
rightIndifferent=(0-bg(1)-bg(2)*leftDelayFixed)./bg(3);
plot(leftDelayFixed, rightIndifferent, '*')
hold on
[bf, bintf, rf, rintf, statsf]= regress(rightIndifferent, [ones(length(leftDelayFixed),1), leftDelayFixed]);
xf=min(leftDelayFixed):1:max(leftDelayFixed);
lf=plot(xf, bf(1)+bf(2).*xf);
set (lf, 'Color', 'r')
l1=line([min(leftDelayFixed) max(leftDelayFixed)], [0, 0]);
set(l1, 'Color', [.8, .8, .8])
l2=line( [0, 0], [min(leftDelayFixed) max(leftDelayFixed)]);
set(l2, 'Color', [.8, .8, .8])
xlabel('Fixed Left Delay')
ylabel('Indifferent Right Delay')



f=figure(5);
set(f, 'Position', [0, 0, 800, 700])
subplot(221)
[gof,intercept]=plotHyperThings(data, 1, 2);
xlabel('Left Delay/s');
ylabel('Preference for left side');

subplot(222)
hold on

[bf, bintf, rf, rintf, statsf]= regress(intercept', [ones(length(leftDelayFixed),1), leftDelayFixed]);
xf=min(leftDelayFixed):1:max(leftDelayFixed);
lf=plot(xf, bf(1)+bf(2).*xf, 'k');
xlim([0, max(leftDelayFixed)])
ylim([min(intercept)-1, max(intercept)+1])
plot(leftDelayFixed, intercept, 'ko')
plot(leftDelayFixed, intercept, 'k*')
xlabel('Right Delay/s');
ylabel('Indifferent Left Delay/s');


subplot(223)
data5=data;
data5(:, 3)=1-data(:, 3);
[gof,intercept]=plotHyperThings(data5, 2, 1);
xlabel('Right Delay/s');
ylabel('Preference for left side');


<<<<<<< HEAD
subplot(224)
hold on
=======

figure(6)

[coefficients, deviances, regressionStats] = glmfit(data(:, [8, 10, 11]), data(:, 3), 'binomial', 'link', 'logit');
>>>>>>> FETCH_HEAD

[bf, bintf, rf, rintf, statsf]= regress(intercept', [ones(length(leftDelayFixed),1), leftDelayFixed]);
xf=min(leftDelayFixed):1:max(leftDelayFixed);
lf=plot(xf, bf(1)+bf(2).*xf, 'k');
xlim([0, max(leftDelayFixed)])
ylim([min(intercept)-1, max(intercept)+1])
plot(leftDelayFixed, intercept, 'ko')
plot(leftDelayFixed, intercept, 'k*')
xlabel('Left Delay/s');
ylabel('Indifferent Right Delay/s');

% subplot(223)
% %plot data by stimulation
% [bg,DEV,STATS, intercept]=plotLogitThings(data,3, 8, 11, 1);
% xlabel('Delay/s');
% ylabel('Preference for left side');
% 
% subplot(224)
% %plot data by stimulation
% [bg,DEV,STATS, intercept]=plotLogitThings(data,3,  8, 10, 1);
% xlabel('Delay/s');
% ylabel('Preference for left side');
% 
% 
% figure(6)
% 
% [coefficients, deviances, regressionStats] = glmfit(data(:, [8, 10, 11]), data(:, 3), 'binomial', 'link', 'logit');
% 
% [ax, lineHandles, patchHandles]=plotLogisticRegression(coefficients, regressionStats, data, [8, 10, 11], 8, [10, 11])


%%

%%
% 
% f=figure;
% set(f, 'Position', [300, 300, 200, 200])0
% 
% L=dataL./dataLs;
% R=dataR./dataRs;
% 
% hold on
% ciplot(mean(L, 2)+std(L, 0, 2), mean(L, 2)-std(L, 0, 2), leftDelaySet, [.9, .8, .95])
% % plot(leftDelaySet, mean(L, 2)+std(L, 0, 2), 'Color', [.6, .5, .85])
% % plot(leftDelaySet, mean(L, 2)-std(L, 0, 2), 'Color', [.6, .5, .85])
% 
% 
% ciplot(mean(R, 2)+std(R, 0, 2), mean(R, 2)-std(R, 0, 2), leftDelaySet, [.8, .9, .7])
% % plot(leftDelaySet, mean(R, 2)+std(R, 0, 2), 'Color', [.5, .7, .85])
% % plot(leftDelaySet, mean(R, 2)-std(R, 0, 2), 'Color', [.85, .7, .85])
% plot(leftDelaySet, mean(R, 2), '*','Color', [.7, .4, .8], 'LineWidth', 2)
% plot(leftDelaySet, mean(R, 2), 'Color', [.7, .4, .8], 'LineWidth', 2)
% 
% plot(leftDelaySet, mean(L, 2), '*','Color', [.5, .3, .6], 'LineWidth', 2)
% plot(leftDelaySet, mean(L, 2), 'Color', [.5, .3, .6], 'LineWidth', 2)
% xlim([0 max(leftDelaySet)])
% 
% ylim([0 1])
% xlabel('Delay/s');
% ylabel('Preference');
% 
% l=line([0 max(leftDelaySet)], [0.5, 0.5]);
% set(l, 'Color', 'r')
