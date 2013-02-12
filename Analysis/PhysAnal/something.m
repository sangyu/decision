close all
totalw=[];
figure

for n=1:12
subplot(6, 2, n)
    W=erp(timestamps, valvestamp, TS2);
    totalw=[totalw; W];
    saveas(figure(1), [num2str(n),'.png'])
    close all
end
figure
hold on
plotHist(totalw, 20, 'k', 'k',0)
xlabel('time/ms')

l2=line([0,0], [0 10]);
set(l2, 'Color', 'g')

