mouse=[414]
data=[];

for i=1:length(mouse)
data=[data;eval(['data', num2str(mouse(i))])];
end

splT=data(:, 4);
splTA=splT(2:end);

dataA=[];

outcome=data(1:end-1, 3);
outcome(find(outcome==0))=-1;
dataA=[data(2:end, [1, 2, 3, 10]), outcome, 1-abs(diff(data(:, 2)))];
dataA=[dataA, dataA(:, 5)+dataA(:, 6)*2, data(2:end, 4), data(1:end-1, 10), data(1:end-1, 2) ];
dataA=[dataA, dataA(:, 10).*dataA(:, 5),(1- dataA(:, 10)).* dataA(:, 5), data(1:end-1, 10)];

dataB=dataA(dataA(:, 4)==0, :);
dataC=dataA(dataA(:, 4)==1, :);




figure (mouse(1)-20)
subplot(221)
hold on
plotHist(splTA(find((1-dataA(:, 4)).*dataA(:, 13))),0.05,  opsin, opsin, 1, normalize);
plotHist(splTA(find((1-dataA(:, 4)).*(1-dataA(:, 13)))), 0.05, gray, gray, 1, normalize);
[h111, p111]=kstest2(splTA(find((1-dataA(:, 4)).*(1-dataA(:, 13)))), splTA(find((1-dataA(:, 4)).*dataA(:, 13))));
title(['previous stim/unstim, current unstim, p=', num2str(p111)])

subplot(222)
plotHist(splTA(find((dataA(:, 4)).*dataA(:, 13))),0.05,  opsin, opsin, 1, normalize);
plotHist(splTA(find((dataA(:, 4)).*(1-dataA(:, 13)))), 0.05, gray, gray, 1, normalize);
[h112, p112]=kstest2(splTA(find((dataA(:, 4)).*dataA(:, 13))), splTA(find((dataA(:, 4)).*(1-dataA(:, 13)))));

title(['previous stim/unstim, current stim, p=', num2str(p112)])

subplot(223)

plotHist(splTA(find(dataA(:, 4))),0.05,  opsin, opsin, 1, normalize);
plotHist(splTA(find(1-dataA(:, 4))), 0.05, gray, gray, 1, normalize);
[h113, p113]=kstest2(splTA(find(dataA(:, 4))), splTA(find(1-dataA(:, 4))));

title(['current stim/unstim, p=', num2str(p113)])

subplot(224)

plotHist(splTA(find(dataA(:, 13))),0.05,  opsin, opsin, 1, normalize);
plotHist(splTA(find(1-dataA(:, 13))), 0.05, gray, gray, 1, normalize);
[h114, p114]=kstest2(splTA(find(dataA(:, 13))), splTA(find(1-dataA(:, 13))));

title(['previous stim/unstim, p=', num2str(p114)])

% suptitle(num2str(mouse))


% %%


stimTrials=find(data(:, 10));
lookback=[];
for i=4:length(stimTrials)
    for j=1:3
        if data(stimTrials(i)-j, 10)==0
            break
        end
    end
    lookback= [lookback; stimTrials(i), j];    
end

for i=2:3
    lookback=[stimTrials(i), length(find(data(1:i, 10))); lookback];
end
stimAccuracy=data(stimTrials(2:end), 3);
% %%
for accuracy=0:1
    figure(accuracy + mouse(1))
subplot(121)
plotHist(splT(find(data(:, 10)==0 & data(:, 3)==accuracy)),0.05,  'k', 'k', 1, normalize);
plotHist(splT(lookback(find(lookback(:, 2)==1 & stimAccuracy==accuracy), 1)),0.05,  blue, blue, 1, normalize);
plotHist(splT(lookback(find(lookback(:, 2)==2 & stimAccuracy==accuracy), 1)),0.05,  green, green, 1, normalize);
plotHist(splT(lookback(find(lookback(:, 2)==3 & stimAccuracy==accuracy), 1)),0.05,  orange, orange, 1, normalize);

subplot(122)
hold on
errorbar(0, mean(splT(find(data(:, 10)==0 & data(:, 3)==accuracy))), std(splT(find(data(:, 10)==0 & data(:, 3)==accuracy)))/sqrt(length(find(data(:, 10)==0 & data(:, 3)==accuracy))), 'Color', 'k', 'LineWidth',2)
plot(0, mean(splT(find(data(:, 10)==0 & data(:, 3)==accuracy))), 'ko')

errorbar(1, mean(splT(lookback(find(lookback(:, 2)==1 & stimAccuracy==accuracy), 1))), std(splT(lookback(find(lookback(:, 2)==1 & stimAccuracy==accuracy), 1)))/sqrt(length(find(lookback(:, 2)==1 & stimAccuracy==accuracy))), 'Color', blue, 'LineWidth',2)
plot(1, mean(splT(lookback(find(lookback(:, 2)==1 & stimAccuracy==accuracy), 1))), 'o', 'Color', blue)


errorbar(2, mean(splT(lookback(find(lookback(:, 2)==2 & stimAccuracy==accuracy), 1))), std(splT(lookback(find(lookback(:, 2)==2 & stimAccuracy==accuracy), 1)))/sqrt(length(find(lookback(:, 2)==2 & stimAccuracy==accuracy))), 'Color', green, 'LineWidth',2)
plot(2, mean(splT(lookback(find(lookback(:, 2)==2 & stimAccuracy==accuracy), 1))), 'ko', 'Color', green)


errorbar(3, mean(splT(lookback(find(lookback(:, 2)==3 & stimAccuracy==accuracy), 1))), std(splT(lookback(find(lookback(:, 2)==3 & stimAccuracy==accuracy), 1)))/sqrt(length(find(lookback(:, 2)==3 & stimAccuracy==accuracy))), 'Color', orange, 'LineWidth',2)
plot(3, mean(splT(lookback(find(lookback(:, 2)==3 & stimAccuracy==accuracy), 1))), 'ko', 'Color', orange)

xlim([-1, 4])
suptitle(['accuracy =', num2str(accuracy)])
end
%%



X=[1, 10, 11, 12];
Y=2;

[bA, dA, statsA]=glmfit(dataA(:, X), dataA(:, Y) ,  'binomial', 'link', 'logit')
[bB, dB, statsB]=glmfit(dataB(:, X), dataB(:, Y) ,  'binomial', 'link', 'logit')
[bC, dC, statsC]=glmfit(dataC(:, X), dataC(:, Y) ,  'binomial', 'link', 'logit')


[statsA.beta, statsA.p, statsB.beta, statsB.p, statsC.beta, statsC.p]
% 
% figure(1)
% subplot(131)
% normplot(statsA.residp);
% subplot(132)    
% normplot(statsB.residp);
% subplot(133)
% normplot(statsC.residp);

% %%
%columns: 
% 1: cue
% 2: side
% 3: score
% 4: stim
% 5: previous score
% 6: shift 0 or stay 1
% 7:   
% %0: lose shift; 
% %1: lose stay;
% %2: win shift;
% %3: win stay;
% 8: sampling time
% 9: previous stim
% 10: previous choice
% 11: left previous outcome
% 12: right previous outcome
% 13: previous laser
figure
hold on
% subplot(121)
% hist(dataA(find(dataA(:, 9)==0), 6))
% subplot(122)

% hist(dataA(find(dataA(:, 9)==1), 6))
[bg,DEV,STATS]=plotLogitThings(dataA, 3, 8, 1, 1, 1, 1, 'jet', 'logit')

% xlim([0 0.5])
% plot(dataA(:, 8),dataA(:, 7), 'o')


% %%
figure

subplot(121)
n1=hist(dataA(find(dataA(:, 10)==1), 7));
hist(dataA(find(dataA(:, 10)==1), 7));

set(gca, 'XTick', [-1, 1, 2, 3])
set(gca, 'XTickLabel', {'LSh', 'LSt', 'WSh', 'WSt'})
title('Previous Trial Left')
subplot(122)
n2=hist(dataA(find(dataA(:, 10)==0), 7));
hist(dataA(find(dataA(:, 10)==0), 7));

set(gca, 'XTick', [-1, 1, 2, 3])
set(gca, 'XTickLabel', {'LSh', 'LSt', 'WSh', 'WSt'})
title('Previous Trial Right')


% %%
n1Trials=n1(find(n1));
n2Trials=n2(find(n2));
n1Proportions= n1Trials([2, 4])./(n1Trials([1, 3])+n1Trials([2, 4]))
n2Proportions= n2Trials([2, 4])./(n2Trials([1, 3])+n2Trials([2, 4]))

figure

hold on
bar([1, 4], n1Proportions, 0.2, 'FaceColor', blue)
bar([2, 5], n2Proportions,0.2,  'FaceColor', red)
legend('Previous Left', 'Previous Right')


%%
