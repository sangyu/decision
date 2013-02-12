function plotDots(x1, y1, x2, y2, legend1, legend2, smallTitle, xlabel, ylabel, ylim, color1, color2)





h = plot(x1, y1, x2, y2);
set(h(1),'Color', color1, 'LineStyle','*', 'MarkerSize', 4)
set(h(2),'Color',color2, 'LineStyle','*', 'MarkerSize', 4)
legend([legend1, num2str(mean(y1))], [legend2, num2str(mean(y2))])
set(get(gca,'XLabel'),'String',xlabel)
set(get(gca,'YLabel'),'String',ylabel)
set(gca, 'YLim', [0 ylim])
set(gca, 'XLim', [0 max(x1)])
set(gca, 'FontSize', 8)
title(smallTitle)
grid on

end