function [bg,DEV,STATS, intercept]=plotLogitThings(data, regressor, plotter)
%
if plotter==0
plotterRange=1;
else
plotterRange=unique(data(:, plotter));
end
regressorRange=unique(data(:, regressor));
hold on
c=colormap(april(length(plotterRange)));
for i=1:length(plotterRange)
    if plotter==0
        plotterInd=1:length(data);
    else
    plotterInd=find(data(:, plotter)==plotterRange(i));
    end
    subdata=data(plotterInd,:);
    for j=1:length(regressorRange)
    regressorInd=find(subdata(:, regressor)==regressorRange(j));
    result(j, i)=mean(subdata(regressorInd, 3));
    end
[bg(:, i),DEV(:, i),STATS(:, i)] = glmfit(subdata(:, regressor), subdata(:, 3), 'binomial', 'link', 'logit');
hold on
[yfit(:, i), yhi(:, i), ylo(:, i)] = glmval(bg(:, i), linspace(min(regressorRange), max(regressorRange))', 'logit', STATS(:, i), 'simultaneous', 'true');
intercept(i)=(0-bg(1, i))/bg(2, i);
boundedline(linspace(min(regressorRange), max(regressorRange))', yfit(:, i), [yhi(:, i), ylo(:, i)], 'cmap', c(i, :), 'alpha')
plot(linspace(min(regressorRange), max(regressorRange))', yfit(:, i), 'Color', c(i, :))
hold on
plot(regressorRange, result(:, i), '*', 'Color', c(i, :))

end
l=line([min(regressorRange), max(regressorRange)], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])

colormap(april(length(plotterRange)))
hcb = colorbar('YTickLabel',num2str(plotterRange));
set(hcb,'YTickMode','manual')
xlim([ min(regressorRange), max(regressorRange)])
ylim([0 1])


function c = april(m)

if nargin < 1, m = size(get(gcf,'colormap'),1); end
r = (0:m-1)'/max(m-1,1); 
c = [1-r r r];
