%% plotHist(a, NBins, color, facecolor, m) takes the matrix, size of the brins and color of the plot. plot median if m ==1

function [bins]=plotHist(a, binSize, color, facecolor, m)


NBins=(max(a)-min(a))/binSize;

for i=1:NBins
    bins(i)=length(find(a>=(min(a)+(i-1)*binSize) & a<(min(a)+ i*binSize)));
end

hold on

for i=1:NBins
    number=min(a)+(i-1)*binSize;

    plot([number,number],[0, bins(i)],'Color', color, 'LineWidth', 1)
    plot( [number,number+binSize], [bins(i), bins(i)], 'Color',color, 'LineWidth', 1)
    plot([number+binSize,number+binSize], [0, bins(i)],'Color',color, 'LineWidth', 1)
    area( [number,number+binSize], [bins(i), bins(i)], 'EdgeColor', color,'FaceColor',facecolor)
alpha(0.5)
end
if m==1
l=line ([median(a), median(a)],[0, max(bins)+2]);
set(l, 'LineWidth', 2, 'Color', 'k');
end
end
