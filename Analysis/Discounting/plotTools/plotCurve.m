function plotCurve(x1, y1, x2, y2, legend1, legend2, smallTitle, xlabel, ylabel, ylim, color1, color2)

h = plot(x1, y1, x1, y2);
title('Performance')
set(h(1),'Color', color1, 'LineStyle','-', 'LineWidth', 1)
set(h(2),'Color',color2, 'LineStyle','-', 'LineWidth', 1)
legend(legend1, legend2);
set(get(gca,'XLabel'),'String',xlabel)
set(get(gca,'YLabel'),'String', ylabel)
set(gca, 'YLim', [0 ylim])
set(gca, 'XLim', [0 max(x1)])
set(gca, 'FontSize', 8)
grid on
title(smallTitle)

end

