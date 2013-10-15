function plotLinThings(data, y,  regressor, plotter, plotline)
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
    result(j, i)=mean(subdata(regressorInd, y));
    end

plot(regressorRange, result(:, i), '*', 'Color', c(i, :))

end

colormap(april(length(plotterRange)))
% hcb = colorbar('YTickLabel',num2str(plotterRange));
% set(hcb,'YTickMode','manual')
xlim([ min(regressorRange), max(regressorRange)])


function c = april(m)

if nargin < 1, m = size(get(gcf,'colormap'),1); end
r = (0:m-1)'/max(m-1,1); 
c = [1-r r r];
