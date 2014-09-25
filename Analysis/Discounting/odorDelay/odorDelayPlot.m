function [leftSide, rightSide, delayDiffSide, xyzP, rightDelayShift, leftDelayShift]=odorDelayPlot(data, stimpara, stimIg)
noOfStimuli=length(unique(data(:, 1)));

xyzPdiff=zeros(noOfStimuli^2, 3);
if stimIg~=0
data(find(data(:, stimIg)==1), :)=[];
end
rightDelayShift=zeros(noOfStimuli, 1);
leftDelayShift=zeros(noOfStimuli, 1);

if length(unique(data(:, stimpara)))>1
    range=1:(max(data(:, stimpara))+1);
else
    range=2;
end
for st= range
    data1=data(find(data(:, stimpara)==st-1),:);
    leftDelay=data1(:, 1);
    rightDelay=data1(:, 2);
    side=data1(:, 3);

    leftDelaySet=sort(unique(leftDelay));
    delayDiff=leftDelay-rightDelay;
    delayRatio=leftDelay./(leftDelay+rightDelay);
    delayRatio(isnan(delayRatio))=0;
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

    rightDelayShift=odor(:, 4)-rightDelayShift;
    leftDelayShift=odor(:, 2)-leftDelayShift;
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
    % delayRatioSide=[delayRatioSet, delayR];
    % delayRatioSide=delayRatioSide(delayRatioSide(:, 1)>=0, :);
    [Rd,Pd,RLOd,RUPd]=corrcoef(delayDiffSide(:, 1), delayDiffSide(:, 2));
    % [Rr,Pr,RLOr,RUPr]=corrcoef(delayRatioSide(:, 1), delayRatioSide(:, 2));





    subplot(2,2, 1)
    hold on
    switch st
        case 1
    plot(leftDelaySet, odor(:, 2), 'b*-')
    plot(leftDelaySet, odor(:, 4), 'r*-')
        case 2
    plot(leftDelaySet, odor(:, 2), 'bo:')
    plot(leftDelaySet, odor(:, 4), 'ro:')
    end


    % plot(leftDelaySet, mean([odor(:, 2), odor(:, 4)], 2), 'k*-')
    legend('Left', 'Right')
    l=line([0 max(leftDelaySet)], [0.5, 0.5]);
    set(l, 'Color', [.8, .8, .8])
    xlim([0 max(leftDelaySet)])
    ylim([0 1])
    xlabel('Delay/s');
    ylabel('Preference');






    xyzS=zeros(max(leftDelaySet)*30+1);
    xyzS1=zeros(max(leftDelaySet)*30+1);
    for i=1:length(leftDelay)
        xyzS(round(leftDelay(i)*30)+1, round(rightDelay(i)*30)+1)= xyzS(round(leftDelay(i)*30)+1, round(rightDelay(i)*30)+1)+1;
        xyzS1(round(leftDelay(i)*30+1), round(rightDelay(i)*30)+1)= xyzS1(round(leftDelay(i)*30)+1, round(rightDelay(i)*30)+1)+1*side(i);
    end
    [i,j,s] = find(sparse(xyzS));
    xyz=[(i-1)/30, (j-1)/30, s];
    xyz1=[(i-1)/30, (j-1)/30, diag(xyzS1(i, j))];


    subplot(2, 2, st+2)


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

    try
    xyzP1=xyzPdiff;
    xyzPdiff=xyzP-xyzPdiff;
    end
end

    xyzPdiff(:, [1, 2])=xyz(:, [1, 2]);
    xyzPdiffN=xyzPdiff;
    xyzPdiffN(:, 3)=xyzPdiff(:, 3)./xyzP1(:, 3);
    xyzPdiff=1-(xyzPdiff+0.5);

    subplot(222)
try
c=colormap(jet(100));
for i=1:length(xyz)
    hold on
    plot(xyz(i, 1), xyz(i, 2), '.', 'Color', c(round(xyzPdiff(i, 3)*(length(c)-1))+1, :), 'MarkerSize', 50)
end
plot(max(xyz(:, 1)+1.5), max(xyz(:, 1)+0.5), '.', 'Color', c(50, :),'MarkerSize', 50)

xlim([-2 max(xyz(:, 1)+2)])
ylim([-2 max(xyz(:, 1)+2)])
ylabel('Right Delay')
xlabel('Left Delay')
% z=sparse(xyzPdiffN(:, 1)/2+1, xyzPdiffN(:, 2)/2+1, xyzPdiffN(:, 3)*100)
% surf([0:2: 10], [0:2: 10],z)
% xlim([0 10])
% ylim([0 10])
end
figure
hold on
rightDelayShift=rightDelayShift*100;
leftDelayShift=leftDelayShift*100;
plot(leftDelaySet, rightDelayShift, 'r*', 'MarkerSize', 20)
plot(leftDelaySet,leftDelayShift, 'b*', 'MarkerSize', 20)
xlim([-2 12])
ylim([min([rightDelayShift; leftDelayShift])-10, max([rightDelayShift; leftDelayShift])+10])
xlabel('Delay')
ylabel('light-shift in prefernce for each reward')
plot([-2 12] , [0 0 ], 'k')
