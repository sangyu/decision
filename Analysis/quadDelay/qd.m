
close all

%% clean up directory and find all files in range
F=0;
delete '.DS_Store';
D = dir;

info=zeros(length(D), 3);
for i=3:length(D)
    info(i, 1)=str2num(D(i).name(4:6));
    info(i, 2)=D(i).datenum;
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

%% extract each file and append data below existing data matrix
data=[];


% for j=1:length(D)-2

for m=1: length(indrange)

filename= D(indrange(m)+2).name   
    

[e, a]=extractOlfData(filename);
data=[data; e.odor1Valve(a.validTrials)+e.odor2Valve(a.validTrials), a.side, a.score(a.validTrials), str2num(e.mouseID (end-2:end))*ones( length(a.validTrials),1 ), datenum(e.dateTime(1:11))*ones( length(a.validTrials),1 )];



end

%%
data(data(:, 5)==362, 7)=2;
data(data(:, 5)==363, 7)=3;
data(data(:, 5)==364, 7)=3;
data(data(:, 5)==365, 7)=4;
data(data(:, 5)==366, 7)=1;
data(data(:, 5)==367, 7)=1;
data(data(:, 5)==368, 7)=2;
data(data(:, 5)==369, 7)=2;
data(data(:, 5)==370, 7)=3;
data(data(:, 5)==371, 7)=1;
data(data(:, 5)==372, 7)=1;
data(data(:, 5)==373, 7)=4;
data(data(:, 5)==374, 7)=4;
data(data(:, 1)==5, 1)=4;
%%


[y, c, fi, fv]=segmentRegressionData(data, [5, 7], data(:, 4));
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
