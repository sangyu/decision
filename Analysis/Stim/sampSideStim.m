[e a]=extractOlfData('sy_382_17-05-13_16-07-39.csv');
%%
side=a.side(:, 1);
leftStim=e.leftDecisionTTL(a.validTrials);

data1=[side, leftStim];
stat=[];
figure
windowrange=5:5:100
for window=windowrange
    l=conv(leftStim, ones(1, window)/window);
    l=l(1:end-window+1);
    data3=[side, l];
    [bg,DEV,STATS, intercept]=plotLogitThings(data3, 1, 2, 0, 1);
    stat=[stat; STATS.beta(2), STATS.p(2)];
end

figure
plot(windowrange, stat)
legend('beta', 'p')


window=windowrange(find(stat(:, 2)==min(stat(:, 2))));
s=conv(side, ones(1, window)/window);
s=s(1:end-window+1);
l=conv(leftStim, ones(1, window)/window);
l=l(1:end-window+1);
f1=figure
set(f1, 'Position', [200, 200, 1050, 300])

hold on
plot(s)
plot(side, '.')
plot([60 60], [0 1], 'g')
plot([120 120], [0 1], 'g')
plot([1 length(s)], [0.5 0.5], 'Color', [.8 .8 .8])
plot((leftStim-0.1)*1.3, 'g.')






