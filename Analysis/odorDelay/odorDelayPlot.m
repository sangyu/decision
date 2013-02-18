function [leftSide, rightSide, delayDiffSide, delayRatioSide, xyzP]=odorDelayPlot(data)

leftDelay=data(:, 1);
rightDelay=data(:, 2);
side=data(:, 3);

leftDelaySet=sort(unique(leftDelay));
delayDiff=leftDelay-rightDelay;
delayRatio=leftDelay./(leftDelay+rightDelay);
[delayDiffSet, I]=sort(unique(delayDiff));
[delayRatioSet, J]=sort(unique(delayRatio));

for i=1:length(leftDelaySet)
    indL=find(leftDelay==leftDelaySet(i));
    indR=find(rightDelay==leftDelaySet(i));
    odor(i, 2)=mean(side(indL));
    odor(i, 3)=length(indL);    
    odor(i, 4)=1-mean(side(indR));
    odor(i, 5)=length(indR);
    
end
for i=1:length(delayDiffSet)    
    indD=find(delayDiff==delayDiffSet(i));
    delayD(i, 1)=mean(side(indD));
    delayD(i, 2)=length(indD);
end

for i=1:length(delayRatioSet)    
    indD=find(delayRatio==delayRatioSet(i));
    delayR(i, 1)=mean(side(indD));
    delayR(i, 2)=length(indD);
end

leftSide=[leftDelaySet, odor(:, 2:3)];
rightSide=[leftDelaySet, odor(:, 4:5)];
delayDiffSide=[delayDiffSet, delayD];
delayRatioSide=[delayRatioSet, delayR];
delayRatioSide=delayRatioSide(delayRatioSide(:, 1)>=0, :);
[Rd,Pd,RLOd,RUPd]=corrcoef(delayDiffSide(:, 1), delayDiffSide(:, 2));
[Rr,Pr,RLOr,RUPr]=corrcoef(delayRatioSide(:, 1), delayRatioSide(:, 2));





subplot(2,2, 1)
hold on
plot(leftDelaySet, odor(:, 2), 'b*-')
plot(leftDelaySet, odor(:, 4), 'r*-')
% plot(leftDelaySet, mean([odor(:, 2), odor(:, 4)], 2), 'k*-')
legend('Left', 'Right')
l=line([0 max(leftDelaySet)], [0.5, 0.5]);
set(l, 'Color', [.8, .8, .8])
xlim([0 max(leftDelaySet)])
ylim([0 1])
xlabel('Delay/s');
ylabel('Preference');





subplot(2,2, 2)

plotLogitThings(data, 8, 10)
xlabel('Left Delay - Right Delay/s');
ylabel('Preference for left side');
subplot(2, 2, 3)
plotLogitThings(data, 9, 4)
xlabel('left Delay/(Left Delay+Right Delay)/s');
ylabel('Preference for left side');
plot([min(delayRatioSet), max(delayRatioSet)], [0.5, 0.5], 'Color', [.8, .8, .8])
ylim([0 1])
xlabel('Delay Ratio');
ylabel('Preference for Left Side');





xyzS=zeros(max(leftDelaySet)*30+1);
xyzS1=zeros(max(leftDelaySet)*30+1);
for i=1:length(leftDelay)
    xyzS(round(leftDelay(i)*30)+1, round(rightDelay(i)*30)+1)= xyzS(round(leftDelay(i)*30)+1, round(rightDelay(i)*30)+1)+1;
    xyzS1(round(leftDelay(i)*30+1), round(rightDelay(i)*30)+1)= xyzS1(round(leftDelay(i)*30)+1, round(rightDelay(i)*30)+1)+1*side(i);
end
[i,j,s] = find(sparse(xyzS));
xyz=[(i-1)/30, (j-1)/30, s];
xyz1=[(i-1)/30, (j-1)/30, diag(xyzS1(i, j))];




subplot(2, 2, 4)
xyzP=[xyz(:, 1:2), xyz1(:, 3)./xyz(:, 3)];
c=colormap(april(100));
for i=1:length(xyz)
    hold on
    plot(xyz(i, 1), xyz(i, 2), '.', 'Color', c(round(xyzP(i, 3)*(length(c)-1))+1, :), 'MarkerSize', xyz(i, 3)*2000/sum(xyz(:, 3)))
end

plot(max(xyz(:, 1)+1.5), max(xyz(:, 1)+0.5), '.', 'Color', c(1, :), 'MarkerSize', ceil(sum(xyz(:, 3))/500)*5*2000/sum(xyz(:, 3)))
plot(max(xyz(:, 1)+1.5), max(xyz(:, 1)+1.5), '.', 'Color', c(end, :), 'MarkerSize', ceil(sum(xyz(:, 3))/500)*10*2000/sum(xyz(:, 3)))
plot([-2, max(xyz(:, 1)+2)], [-2 max(xyz(:, 1)+2)], 'Color', [.8, .8, .8])
text(max(xyz(:, 1)), max(xyz(:, 1)+0.5), [num2str(ceil(sum(xyz(:, 3))/500)*5), 'R'])
text(max(xyz(:, 1)), max(xyz(:, 1)+1.5), [num2str(ceil(sum(xyz(:, 3))/500)*10), 'L'])

% line([0 0], [max(xyz(:, 1))+2, max(xyz(:, 1)+2)])

ylabel('Right Delay')
xlabel('Left Delay')
xlim([-2 max(xyz(:, 1)+2)])
ylim([-2 max(xyz(:, 1)+2)])