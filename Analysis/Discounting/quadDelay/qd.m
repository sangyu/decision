
close all

%% clean up directory and find all files in range
F=0;
delete '.DS_Store';
D = dir;


info=zeros(length(D), 3);
for i=3:length(D)
    info(i, 1)=str2num(D(i).name(4:6));
    info(i, 2)=datenum(D(i).name(8:15), 'dd-mm-yy');
end

info(1:2, :)=[];
info(:, 2)=info(:, 2)-min(info(:, 2))+1;
info(:, 3)=[1:length(info(:, 1))];

[info(:, 2), I]=sort(info(:, 2));
info(:, 2)=round(info(:, 2));
info(:, 1)=info(I, 1);
info(:, 3)=info(I, 3);

mouse=input('which mouse ');
day=input('which day ');


if mean(day)==0 && mean(mouse)~=0
indrange=info(ismember(info(:, 1), mouse), 3);
elseif mean(mouse)==0 && mean(day)~=0
indrange=info(ismember(info(:, 2),day), 3);
elseif mean(mouse)==0 && mean(day)==0
    indrange=info(:, 3);
else
indrange=info(ismember(info(:, 1), mouse), 3);
indrange2=info(ismember(info(:, 2),day), 3);
indrange=intersect(indrange, indrange2);
end

% extract each file and append data below existing data matrix
data=[];


% for j=1:length(D)-2
r=[];
for m=1: length(indrange)

filename= D(indrange(m)+2).name   
    

[e, a]=extractOlfDataQD(filename);
data=[data; a.score, a.side(:, 1),a.travelTime,  e.left(a.validTrials), e.leftRewardDelay(a.validTrials)+e.rightRewardDelay(a.validTrials),  str2num(e.mouseID (end-2:end))*ones( length(a.validTrials),1 ), datenum(e.dateTime(1:11))*ones( length(a.validTrials),1 )];

r(m)=a.rewardCollected

end


data((data(:, 1)==-1), 1)=0;
data(data(:, 1)==5, 1)=4;



[y, cy, fiy, fvy]=segmentRegressionData(data, [4, 5], data(:, 1));
[side, c, fi, fv]=segmentRegressionData(data, [4, 5], data(:, 2));
[travelTime, c, fi, fv]=segmentRegressionData(data, [4, 5], data(:, 3));
[travelTimeROC, c, fi, fv]=segmentRegressionData(data, [7, 2, 4], data(:, 3));

% fv =
% 
%      0     0 -true right
%      0     1 -false right
%      1     0 -false left
%      1     1 -true left
rightCorrect=c(1)/(c(1)+c(3));
leftCorrect=c(4)/(c(2)+c(2));

figure(1)
subplot(131)
bar([0, 1], [y(1: 2)'; y(3: 4)'])
ylabel('accuracy')
legend('delay 0', 'delay 3s')
subplot(132)
bar([0, 1], [side(1: 2)'; side(3: 4)'])
ylabel('side')
legend('delay 0', 'delay 3s')
subplot(133)
bar([0, 1], [travelTime(1: 2)'; travelTime(3: 4)'])
ylabel('travelTime')
legend('delay 0', 'delay 3s')
figure(2)
plot(leftCorrect, rightCorrect, 'o')
hold on
xlim([0 1])
ylim([0 1])
l2=line([0, 1], [0.5, 0.5]);
set(l2, 'Color', [.8, .8, .8])
l1=line([0.5, 0.5], [0, 1]);
set(l1, 'Color', [.8, .8, .8])
%%
c=april(length(unique(fv(:, 1))));
figure
for i=1:length(y)
hold on
plot(fv(i, 2), y(i), '.', 'Color', c(i,:))
end

m=[];
e=[];
gene=unique(fv(:, 2));
for i=1:length(gene)
    m=[m;mean(y(find(fv(:, 2)==gene(i))))];
    e=[e;std(y(find(fv(:, 2)==gene(i))))];
end
plot(gene, m, 'ro')
errorbar(gene, m, e, e, 'r');
