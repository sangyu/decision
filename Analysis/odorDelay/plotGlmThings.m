function [bg,DEV,STATS, intercept]=plotGlmThings(data, regressors, plotters)
%%
global april
plotterRange=unique(data(:, plotters));
regressorRange=unique(data(:, regressors));
hold on
for i=1:length(plotterRange)
    plotterInd=find(data(:, plotters)==plotterRange(i));
    subdata=data(plotterInd,:);
    for j=1:length(regressorRange)
    regressorInd=find(subdata(:, regressors)==regressorRange(j));
    result(j, i)=mean(subdata(regressorInd, 3));
    end
[bg(:, i),DEV(:, i),STATS(:, i)] = glmfit(subdata(:, regressors), subdata(:, 3), 'binomial', 'link', 'logit');
hold on
[yfit(:, i), yhi(:, i), ylo(:, i)] = glmval(bg(:, i), linspace(min(regressorRange), max(regressorRange))', 'logit', STATS(:, i), 'simultaneous', 'true');
intercept(i)=(0-bg(1, i))/bg(2, i);


boundedline(linspace(min(regressorRange), max(regressorRange))', yfit(:, i), [yhi(:, i), ylo(:, i)], 'cmap', april(round(length(april)/(length(plotterRange)+1))*i+2, :), 'alpha')

plot(linspace(min(regressorRange), max(regressorRange))', yfit(:, i), 'Color', april(round(length(april)/(length(plotterRange)+1))*i+2, :))
% legend(num2str(plotterRange(i)))
hold on
plot(regressorRange, result(:, i), '*', 'Color', april(round(length(april)/(length(plotterRange)+1))*i+2, :))
l=line([min(regressorRange), max(regressorRange)], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])
xlim([ min(regressorRange), max(regressorRange)])
ylim([0 1])
xlabel('Delay/s');
ylabel('Preference for left side');
end
