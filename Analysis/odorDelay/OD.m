set(0,'DefaultAxesFontName', 'Arial')
set(0,'DefaultAxesFontSize', 16)

% Change default text fonts.
set(0,'DefaultTextFontname', 'Arial')
set(0,'DefaultTextFontSize', 16)

close all

%% clean up directory and find all files in range
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
info(info(:, 3)==indrange(m), 5)=3*max(e.leftDecisionTTL)+2*max(e.cueSampledTTL)+max(e.cueOnTTL);

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


data=[data;leftDelay, rightDelay, side,leftRewardSize, rightRewardSize,  a.validTrials, m*ones(length(a.validTrials), 1), leftDelay-rightDelay, leftDelay./(leftDelay+rightDelay), leftRewardSize-rightRewardSize, 3*e.leftDecisionTTL(a.validTrials)+2*e.cueSampledTTL(a.validTrials)+e.cueOnTTL(a.validTrials), a.travelTime(a.validTrials-min(a.validTrials)+1), a.reactionTime(a.validTrials-min(a.validTrials)+1)];
% 
% [leftSide, rightSide, delayDiffSide, delayRatioSide]=odorDelayPlot(leftDelay, rightDelay, side);
% title(filename)

% plot(delayDiffSet, delayD(:, 1)./delayD(:, 2),'o',delayDiffSet,yfit./delayD(:, 2),'-','LineWidth',2)
assignin('base', ['info' e.mouseID(end-2:end)], infoMouse);
assignin('base', ['data' e.mouseID(end-2:end)], data);
save(['C:\Users\user\Desktop\OD\MatFiles\' e.mouseID(end-2:end) '.mat'],['info' e.mouseID(end-2:end)] , ['data' e.mouseID(end-2:end)])
a.rewardCollected
a.rewardPokeOut
end
%%
%shape data

close all
data=[];
bigSize=2;
stimTime=2;
f=pwd;
mice =[381];
runSessionsStart=1;


for j=1:length(mice)    
    info1=eval(['info',num2str(mice(j))])
    data1=eval(['data', num2str(mice(j))]);
    days=[max(info1(:, 2))-200:max(info1(:, 2))]';
    c=intersect(info1(:, 2), days);
    ia=[];
    for i=1:length(c)
    ia=[ia; find(info1(:, 2)==c(i))];
    end
    sessions=intersect(intersect(find(info1(:, 4)==bigSize), find(info1(:, 5)==stimTime)), ia)
%     sessions=intersect(find(info1(:, 5)==stimTime), ia);
    for i=runSessionsStart:length(sessions)
data=[data; data1(find(data1(:,7)==sessions(i)), :)];  
    end
end
numberOfTrials=length(data)
  
f1=figure(1);
set(f1, 'Position', [200, 200,1100, 500])


subplot(121)
axis square
% [coefficients, deviances, regressionStats] = glmfit(data(:, [8, 10, 11]), data(:, 3), 'binomial', 'link', 'logit');
% [ax, lineHandles, patchHandles]=plotLogisticRegression(coefficients, regressionStats, data, [8, 10, 11], 8, [10, 11]);
% 
% [regressionStats.beta, regressionStats.p]

[bg,DEV,STATS, intercept]=plotLogitThings(data,3, 8, 11, 1);
xlabel('(Left Delay-Right Delay)/s');
ylabel('Preference for left side');


subplot(122)
hold on
axis square

[coefficients, deviances, regressionStats] = glmfit(data(:, [8, 11]), data(:, 3), 'binomial', 'link', 'logit');
[ax, lineHandles, patchHandles]=plotLogisticRegression(coefficients, regressionStats, data, [8, 11], 8, 11);
l=line([-10, 10], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])
text(3, .85, ['p = ' num2str(round(regressionStats.p(3)*1000)/1000)])
text(3, .9, ['B = ' num2str(round(regressionStats.beta(3)*1000)/1000)])

[regressionStats.beta, regressionStats.p]

xlabel('(Left Delay-Right Delay)/s');
ylim([0 1])
suptitle(['mouse #' num2str(mice) ', number of trials=' num2str(length(data)), ', big reward=' num2str(bigSize), ' x small reward']);

set(findall(f1,'type','text'), 'fontWeight','bold')

print('-depsc','-r200',['#' num2str(mice) '_preference_bigsize', num2str(num2str(bigSize)), '_laser_', num2str(stimTime)])


f2=figure(2);
set(f2, 'Position', [200, 200,1100, 500])
subplot(121)
plotLinThings(data, 12,  8, 11, 1)
xlabel('(Left Delay-Right Delay)/s');
ylabel('travel time/s')


ylim([0 1])

tvl0=data(find(data(:, 11)==0), 12);
tvl1=data(find(data(:, 11)==1), 12);
tvl2=data(find(data(:, 11)==2), 12);
tvl3=data(find(data(:, 11)==3), 12);
tvl0(tvl0>10)=[];
tvl1(tvl1>10)=[];
tvl2(tvl2>10)=[];
tvl3(tvl3>10)=[];
tvl0(tvl0<=0)=[];
tvl1(tvl1<=0)=[];
tvl2(tvl2<=0)=[];
tvl3(tvl3<=0)=[];

% plot([0 1 2 3],[mean(tvl0), mean(tvl1), mean(tvl2), mean(tvl3)],  '*-')
% hold on
% plot([0 1 2 3],[var(tvl0)+mean(tvl0),var(tvl1)+mean(tvl1), var(tvl2)+mean(tvl2), var(tvl3)+mean(tvl3)],  '*-')
% ylim([0 1])
% xlim([-1 3])
axis square 
subplot(122)
axis square 
hold on
plotHist(tvl0, .05, 'r', 'r', 0);
plotHist(tvl2, .05, 'c', 'c', 0);
plotHist(tvl1, .05, 'c', 'c', 0);

xlabel('travel time/s')

xlim([0 2])
suptitle(['mouse #' num2str(mice) ', number of trials=' num2str(length(data)), ', big reward=' num2str(bigSize), ' x small reward']);
set(findall(f2,'type','text'), 'fontWeight','bold')

print('-depsc','-r200',['#' num2str(mice) '_tvltime_bigsize', num2str(num2str(bigSize)), '_laser_', num2str(stimTime)])


f3=figure(3);
set(f3, 'Position', [200, 200,1100, 500])
subplot(121)
plotLinThings(data, 13,  8, 11, 1)
xlabel('(Left Delay-Right Delay)/s');
ylabel('sampling time/s')

ylim([0 1])

rxn0=data(find(data(:, 11)==0), 13);
rxn1=data(find(data(:, 11)==1), 13);
rxn2=data(find(data(:, 11)==2), 13);
rxn3=data(find(data(:, 11)==3), 13);
rxn0(rxn0>10)=[];
rxn1(rxn1>10)=[];
rxn2(rxn2>10)=[];
rxn3(rxn3>10)=[];
rxn0(rxn0<=0)=[];
rxn1(rxn1<=0)=[];
rxn2(rxn2<=0)=[];
rxn3(rxn3<=0)=[];
% 
% plot([0 1 2 3],[mean(rxn0), mean(rxn1), mean(rxn2), mean(rxn3)],  '*-')
% hold on
% plot([0 1 2 3],[var(rxn0)+mean(rxn0),var(rxn1)+mean(rxn1), var(rxn2)+mean(rxn2), var(rxn3)+mean(rxn3)],  '*-')
% ylim([0 1])
% xlim([-1 3])
axis square 
subplot(122)
axis square 
hold on

plotHist(rxn0, .05, 'r', 'r', 0);
xlabel('sampling time/s')
plotHist(rxn1, .05, 'c', 'c', 0);

plotHist(rxn2, .05, 'c', 'c', 0);
xlim([0 2])
suptitle(['mouse #' num2str(mice) ', number of trials=' num2str(length(data)), ', big reward=' num2str(bigSize), ' x small reward']);
set(findall(f3,'type','text'), 'fontWeight','bold')

print('-depsc','-r200',['#' num2str(mice) '_samptime_bigsize', num2str(num2str(bigSize)), '_laser_', num2str(stimTime)])

%%
f=figure(1);
set(f, 'Position', [0, 0, 750, 800])
mouse=mice

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

plotHist(leftDelay, 0.5, 'g', 'g', 1);
ylim([0, 70])

subplot(338)
ylim([0, 70])

plotHist(rightDelay, 0.5, 'r', 'r', 1);
ylim([0, 70])

subplot(339)
ylim([0, 70])

plotHist(actualDelay, 0.5, 'b', 'b', 1);

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
xlabel('Delay/s');
ylabel('Preference for left side');
subplot(222)
hold on

[bf, bintf, rf, rintf, statsf]= regress(intercept', [ones(length(leftDelayFixed),1), leftDelayFixed]);
xf=min(leftDelayFixed):1:max(leftDelayFixed);
lf=plot(xf, bf(1)+bf(2).*xf, 'k');
xlim([0, max(leftDelayFixed)])
ylim([0, max(leftDelayFixed)])
plot(leftDelayFixed, intercept, 'ko')
plot(leftDelayFixed, intercept, 'k*')

subplot(223)
%plot data by stimulation
[bg,DEV,STATS, intercept]=plotLogitThings(data,3, 8, 11, 1);
xlabel('Delay/s');
ylabel('Preference for left side');

subplot(224)
%plot data by stimulation
[bg,DEV,STATS, intercept]=plotLogitThings(data,3,  8, 10, 1);
xlabel('Delay/s');
ylabel('Preference for left side');


figure(6)

[coefficients, deviances, regressionStats] = glmfit(data(:, [8, 10, 11]), data(:, 3), 'binomial', 'link', 'logit');

[ax, lineHandles, patchHandles]=plotLogisticRegression(coefficients, regressionStats, data, [8, 10, 11], 8, [10, 11])



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
