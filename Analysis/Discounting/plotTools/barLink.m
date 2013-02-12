function barLink(x1, x2, facecolor)
set(gca, 'FontSize', 12)
hold on
bar([mean(x1), mean(x2)] + [std(x1), std(x2)], 0.02);
alpha(.5)

h=bar([mean(x1), mean(x2)], 0.6);
set(h(1), 'facecolor', facecolor)
for i=1:length(x1)
line([1, 2], [x1(i), x2(i)])
%text(2.3, x2(i), num2str(i) )
alpha(.5)
end