%% plotHist(a, NBins, color, facecolor, m) takes the matrix, size of the brins and color of the plot. plot median if m ==1

function [bins]=plotHist(a, binSize, color, facecolor, m)


NBins=(max(a)-0)/binSize;

for i=1:NBins
    bins(i)=length(find(a>=(i-1)*binSize & a<i*binSize));
end

hold on

for i=1:NBins
    number=(i-1)*binSize;

    plot([number,number],[0, bins(i)/length(a)],'Color', color, 'LineWidth', 1)
    plot( [number,number+binSize], [bins(i)/length(a), bins(i)/length(a)], 'Color',color, 'LineWidth', 1)
    plot([number+binSize,number+binSize], [0, bins(i)/length(a)],'Color',color, 'LineWidth', 1)
    area( [number,number+binSize], [bins(i)/length(a), bins(i)/length(a)], 'EdgeColor', color,'FaceColor',facecolor)
alpha(0.5)
end
if m==1
l=line ([median(a), median(a)],[0, max(bins/length(a))+.2]);
set(l, 'LineWidth', 2, 'Color', color);
end
end
