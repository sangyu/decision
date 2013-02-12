
%% Plot Composite
function plotComposite(exptSetup, summary)
global strongRed weakRed blue green gray purple lookback lookforward


% lookback=10;
% lookforward=40;
% blue=[0 .5 .8];
% green=[0 .7 .4];
% gray=[0.9, 0.9, 0.9];
% purple=[0.5 0 .8];
% 

try
figure ('OuterPosition', [0, 0, 1550, 800], 'Position', [0 0 1550 800])

suptitle([exptSetup(end).mouseID ' ', exptSetup(end).dateTime]);


subplot(251);
hold on

plot(summary.odor1Perf*100, summary.odor2Perf*100, '.-', 'LineWidth',1.5,'Color', blue )
for i=1:length(summary.odor1Perf-1)
    plot(summary.odor1Perf(i)*100, summary.odor2Perf(i)*100, 'o', 'MarkerSize', sqrt(summary.numberOfTrials(i)), 'MarkerEdgeColor', blue, 'MarkerFaceColor', gray)
end
    plot(summary.odor1Perf(end)*100, summary.odor2Perf(end)*100, 'o', 'MarkerSize', sqrt(summary.numberOfTrials(i)), 'MarkerEdgeColor', blue, 'MarkerFaceColor', [1, 0, 0])
xlim([0 100])
ylim([0 100])
xlabel('% correct to odor 1')
ylabel('% correct to odor 2')

title('Performance Comparison by Cue')
set(gca, 'FontSize', 8)
grid on
axis square 


subplot(256)

hold on
plot((1:length(summary.freePref)), summary.freePref*100, '.-', 'LineWidth',1.5,'Color',blue )
plot((1:length(summary.timeOut)), summary.timeOut*100, '.-', 'LineWidth',1.5,'Color', purple )
plot((1:length(summary.allPerf)), summary.allPerf*100, '.-', 'LineWidth',1.5,'Color', green )
plot(length(summary.allPerf), summary.allPerf(end)*100, 'r.','MarkerSize',15)
plot(length(summary.freePref), summary.freePref(end)*100, 'r.','MarkerSize',15)
plot(length(summary.freePref), summary.timeOut(end)*100, 'r.','MarkerSize',15)

legend('Free Left', 'Timeout', 'Perf','Location', 'SouthWest')
set(gca, 'FontSize', 8)
ylim([0 100])
xlim([1 length(summary.freePref)])
title('Percentage of Left Choice and summary.timeOut')
xlabel('Day')
ylabel('Percentage')
axis square 
grid on


subplot(252)

set(gca, 'FontSize', 8)
hold on
plot([-lookback: lookforward],summary.meanLongTrend*100, '.-', 'LineWidth',1.5,'Color',[.3 .2 .6] )
% plot([-lookback: lookforward],summary.stdDayLongTrend*100+summary.meanLongTrend*100, '-', 'Color',[.4 .3 .7] )
% plot([-lookback: lookforward],summary.meanLongTrend*100-summary.stdDayLongTrend*100, '-', 'Color',[.4 .3 .7] )
line([0, 0], [-100, 100])
xlim([-lookback lookforward])
ylim([0,100])
t=text(-6, 10, num2str(length(summary.longTrend(1,:))));
set(t, 'FontSize', 15, 'LineWidth', 1, 'Color', 'r')
title('Percentage choosing the initially short reward')
xlabel('No. of Trials')
ylabel('Percentage choosing the long reward')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off



subplot(257)

set(gca, 'FontSize', 8)
hold on
plot([-lookback: lookforward],summary.meanBigTrend*100, '.-', 'LineWidth',1.5,'Color',[.3 .2 .6] )
% plot([-lookback: lookforward],summary.stdDayBigTrend*100+summary.meanBigTrend*100, '-', 'Color',[.4 .3 .7] )
% plot([-lookback: lookforward],summary.meanBigTrend*100-summary.stdDayBigTrend*100, '-', 'Color',[.4 .3 .7] )
line([0, 0], [-100, 100])
xlim([-lookback 20])
ylim([0,100])
t=text(-6, 10, num2str(length(summary.bigTrend(1,:))));
set(t, 'FontSize', 15, 'LineWidth', 1, 'Color', 'r')

title('Percentage choosing the initially big reward')
xlabel('No. of Trials')
ylabel('Percentage choosing the big reward')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off

catch ME
end


try



subplot(253)
set(gca, 'FontSize', 8)
hold on
plot((1:length(summary.allPerf)), summary.meanWaitTime, '.-', 'LineWidth',1.5,'Color',[0 .5 .8] )
line([0, length(summary.allPerf)], [summary.expectedRewardDelay(1), summary.expectedRewardDelay(1)])
line([0, length(summary.allPerf)], [summary.minRewardDelay(1), summary.minRewardDelay(1)])
line([0, length(summary.allPerf)], [summary.maxRewardDelay(1), summary.maxRewardDelay(1)])

ylim([summary.minRewardDelay(1) summary.maxRewardDelay(1)])
xlim([1 length(summary.allPerf)])
title('Optimization of Delay in Free Choice Trials')
xlabel('Day')
ylabel('Average Delay to Reward  per Trial/s')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off

subplot(258)
set(gca, 'FontSize', 8)
hold on
plot((1:length(summary.allPerf)), summary.meanRewardAmount, '.-', 'LineWidth',1.5,'Color',green )
line([0, length(summary.allPerf)], [summary.expectedValveDuration(1), summary.expectedValveDuration(1)])
line([0, length(summary.allPerf)], [summary.maxValveDuration(1), summary.maxValveDuration(1)])
line([0, length(summary.allPerf)], [summary.minValveDuration(1), summary.minValveDuration(1)])

ylim([summary.minValveDuration(1) summary.maxValveDuration(1)])
xlim([1 length(summary.allPerf)])
title('Optimization of Reward Duration in Free Choice Trials')
xlabel('Day')
ylabel('Average Reward Duration per Trial/s')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off





subplot(254)
set(gca, 'FontSize', 8)
hold on
plothist(summary.shortTT, 0.02, 'r')
plothist(summary.longTT, 0.02, blue)
ylim([0 60])
xlim([0 6])
t=text(4, 50, 'short');
set(t, 'Color', 'r')
t=text(4, 45, 'long');
set(t, 'Color', blue)
title('distribution of travel time by delay')
xlabel('time/s')
ylabel('count')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off

subplot(259)
set(gca, 'FontSize', 8)
hold on
plothist(summary.bigTT, 0.02, 'r')
plothist(summary.smallTT, 0.02, blue)
t=text(4, 50, 'big');
set(t, 'Color', 'r')
t=text(4, 45, 'small');
set(t, 'Color', blue)
title('distribution of travel time by size')
ylim([0 60])
xlim([0 6])

xlabel('time/s')
ylabel('count')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off


subplot(255)
set(gca, 'FontSize', 8)
hold on
plothist(summary.shortST, 0.02, 'r')
plothist(summary.longST, 0.02, blue)
ylim([0 60])
xlim([0 6])
t=text(4, 50, 'short');
set(t, 'Color', 'r')
t=text(4, 45, 'long');
set(t, 'Color', blue)
title('distribution of sampling time by delay')
xlabel('time/s')
ylabel('count')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off

subplot(2, 5, 10)
set(gca, 'FontSize', 8)
hold on
plothist(summary.bigST, 0.02, 'r')
plothist(summary.smallST, 0.02, blue)
t=text(4, 50, 'big');
set(t, 'Color', 'r')
t=text(4, 45, 'small');
set(t, 'Color', blue)
title('distribution of sampling time by size')
ylim([0 60])
xlim([0 6])

xlabel('time/s')
ylabel('count')
set(gca, 'FontSize', 8)
axis square 
grid on
hold off



catch ME

end

    

end

