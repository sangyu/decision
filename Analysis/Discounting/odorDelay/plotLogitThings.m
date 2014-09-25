function [bg,DEV,STATS, intercept,result]=plotLogitThings(data, y,  regressor, plotter, plotline,markerFace, ci, choiceOfColorMap)
%
markers={'o';'^';'s';'d';'p';'h'; };
lineShapes={'-', ':', '--', '-.'};
if plotter==0
plotterRange=1;
else
plotterRange=unique(data(:, plotter));
end
regressorRange=unique(data(:, regressor));
hold on
fc=str2func(choiceOfColorMap);
c=colormap(fc(length(plotterRange)));

for i=1:length(plotterRange)
    if plotter==0
        plotterInd=1:length(data);
    else
    plotterInd=find(data(:, plotter)==plotterRange(i));
    end
    subdata=data(plotterInd,:);
    for j=1:length(regressorRange)
    regressorInd=find(subdata(:, regressor)==regressorRange(j));
    result(j, i)=mean(subdata(regressorInd, y));
    result(j, i+length(plotterRange))=length(subdata(regressorInd, y));
    end
[bg(:, i),DEV(:, i),STATS(:, i)] = glmfit(subdata(:, regressor), subdata(:, y), 'binomial', 'link', 'logit');
[yfit(:, i), yhi(:, i), ylo(:, i)] = glmval(bg(:, i), linspace(min(regressorRange), max(regressorRange))', 'logit', STATS(:, i));
intercept(i)=(0-bg(1, i))/bg(2, i);
if ci>0
boundedline(linspace(min(regressorRange), max(regressorRange))', yfit(:, i), [yhi(:, i), ylo(:, i)], ':', 'cmap', c(i, :), 'alpha')
end
switch plotline
    case 1
        plot(linspace(min(regressorRange), max(regressorRange))', yfit(:, i), 'Color', c(i, :), 'LineWidth', 1.5)
    case 2
        plot(linspace(min(regressorRange), max(regressorRange))', yfit(:, i), '-.', 'Color', c(i, :), 'LineWidth', 1.5)
end
hold on
if markerFace>0
    plot(regressorRange, result(:, i), markers{i},'MarkerFaceColor', c(i, :), 'Color', c(i, :))
else
    plot(regressorRange, result(:, i), markers{i}, 'Color', c(i, :))

end
end
l=line([min(regressorRange), max(regressorRange)], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])

colormap(fc(length(plotterRange)))
hcb = colorbar('YTickLabel',num2str(plotterRange));
set(hcb,'YTickMode','manual')
xlim([ min(regressorRange)-1, max(regressorRange)+1])

ylim([0 1])

