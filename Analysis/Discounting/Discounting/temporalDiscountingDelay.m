%temporal discounting
clear
% close all
colors=[.2, .3, .7 ; .4, .7, .1, ; .6, .2, .7; .7, .2, .7];
delete '.DS_Store'
filelist=dir;

info=zeros(length(filelist), 3);
for i=3:length(filelist)
    info(i, 1)=str2num(filelist(i).name(4:6));
    info(i, 2)=filelist(i).datenum;
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
%%


if day==0 && mouse~=0
indrange=info(find(info(:, 1)==mouse), 3);
elseif mouse==0 && day~=0
indrange=info(find(info(:, 2)==day), 3);
elseif mouse==0 && day==0
    indrange=info(:, 3);
else
indrange=find(info(:, 1)==mouse);
indrange2=find(info(indrange, 2)==day);
indrange=info(indrange(indrange2), 3);
end
giant=[];
breaker=1;
M=[];
V=[];
PV=[];
Delay=[];
Mouse=[];
Stim={};
Day=cell(4, 1);
pref=[];
eStart=[];
lWaste=[];
rWaste=[];
smallDelay=[];

for m=1: length(indrange)

filename=filelist(indrange(m)+2).name
[e, a]=extractOlfData(filename);
d=a.rewardDelay;
fnames=fieldnames(e);
counter=1;
for q=1:length(fnames)
    fname=char(fnames(q));
    memberComp=ismember(fname, 'TTL');
    if mean(memberComp(end-2:end))==1 && mean(getfield(e, fname))>0
        Stim{m, counter}=fname;
    counter=counter+1;
    stim=getfield(e, fname);
    stim=stim(a.validTrials);
    end
end
if counter==1
    Stim{m}=0;
    stim=0;
end
dc=d;

for i=2:length(d)
    if d(i)==e.bigDelay
        if d(i-1)>1
        d(i)=d(i-1)-0.5;
        else d(i)=1;
        end
    end
end

ind=find(d>e.bigDelay);
for i=1:ind(1)-1
    d(ind(1)-i)=d(ind(1)-i+1)+0.5;
end
try
laser=getfield(e, char(Stim(m, 1)));
laser=laser(1:length(d));
catch
    laser=[];
end
figure(1)

subplot(4, length(indrange), [m,m+length(indrange)])
plot(d, '.-')
hold on
plot(find(laser), 4*ones(length(find(laser)), 1), 'r.')
ylim([0 8])
xlim([0 length(d)])
if m==1
 ylabel('delay/s')
end
if m==length(indrange)/2||m==length(indrange)/2+0.5
 xlabel('trial no.')
 title(num2str(mouse))
end
title(e.mouseID)
% axis square
subplot(4, length(indrange), m+length(indrange)*2)
% hist(dc)
plotHist(d, .2, 'b', 'b', 0);
hold off
xlim([0 12])
if m==1
ylabel('count')

end
if m==length(indrange)/2||m==length(indrange)/2+0.5
xlabel('delay/s')
end
ylim([0 30])

subplot(4, length(indrange),length(indrange)*3+1:length(indrange)*4)
hold on
plot(m, mean(d), 'r.-')
plot(m, var(d), 'bo-')
hold off
ylim([0 12])
xlim([.5 m+0.5])

% suptitle(['Mouse ID ' num2str(mouse), 'Day ', num2str(day)])
disp(['variance - ', num2str(var(d)), ' percent variance - ' num2str(var(d)/mean(d)*100), '%'])
disp(['percent left/right choice - ', num2str(mean(a.side)*100), '%'])
M=[M; mean(d)];
V=[V; var(d)];
PV=[PV; var(d)/mean(d)*100];
Delay=[Delay; d];
Mouse(m)=str2num(e.mouseID(end-2:end));
Day(m)={e.dateTime};
try
pref=[pref;mean(a.side(end-39:end, :))];
end
eStart(m)=a.effectiveStart;
lWaste(m)=a.leftWaste;
rWaste(m)=a.rightWaste;
rew=a.side(:, 1)+1;
cumRew=rew;
for r=1:length(rew)
    cumRew(r)=sum(rew(1:r));
end

giant(breaker(m):breaker(m)-1+length(a.validTrials), 3)=a.validTrials;
giant(breaker(m)-1+a.rewardTrials, 4)=a.rewardDelay;
giant(breaker(m):breaker(m)-1+length(a.validTrials), 5)=a.side(:, 1);
giant(breaker(m):breaker(m)-1+length(a.validTrials), 6)=cumRew;
giant(breaker(m):breaker(m)-1+length(a.validTrials), 1)=Mouse(m);
giant(breaker(m):breaker(m)-1+length(a.validTrials), 9)=stim;
giant(breaker(m):breaker(m)-1+length(a.validTrials), 8)=e.smallDelay;
giant(breaker(m):breaker(m)-1+length(a.validTrials), 2)=datenum(e.dateTime(1:11));

breaker(m+1)=length(giant(:, 1));

end

%%

delay=giant(:, 4).*giant(:, 5);
for i=2:length(delay)
if (delay(i)==0)
delay(i)=delay(i-1);
end
end
% plot(delay)
giant(:, 7)=delay;

switcher=0;


lD=unique(giant(:, 5).*giant(:, 7));
rD=unique(giant(:, 8));
rD(find(rD==0))=[];
rD(end)=[];
xintercept=[];
for j=[2, 3, 1]
freq=zeros(length(lD), 3);
for i=1:length(lD)
    try
ind=intersect(find(giant(:, 7)==lD(i)), find(giant(:, 8)==rD(j)));
if ind(end)+1>length(giant)
    ind(end-0:end)=[];
end
choice=giant(ind, 5);
freq(i, :)=[lD(i), length(find(choice)), length(choice)-length(find(choice))];
    end
    end
ind=find(freq(:, 2)+freq(:, 3)==0);
ind=[ind; find(freq(1,1)==0)];
freq(ind, :)=[];
freq(:, 4)=freq(:, 2)./((freq(:, 3))+freq(:, 2));
freq(find(freq(:, 2)+freq(:, 4)==0), :)=[];

figure(2)
plot([0 11], [0.5, 0.5], 'r')
hold on
try
for i=1:length(freq)
plot(freq(i, 1), freq(i, 4), '.','Color', colors(j,:), 'MarkerSize', 5*log(freq(i,2)+freq(i, 3)+1))
end
freq1=freq(1:end, 1);
freq4=freq(1:end, 4);
[fitresult, gof] = generateHypFit1(freq1, freq4, colors(j, :))
xintercept(j)=(fitresult.a/0.5-1)/fitresult.k;
grid off
ylim([0 1])
xlim([0 11])  
pause
end
end 

title(['#', num2str(Mouse(:, 1)), '       a=', num2str(round(fitresult.a*100)/100), '        k=', num2str(round(fitresult.k*100)/100)]);
figure(3)
hold on
plot(rD, xintercept, 'b.', 'MarkerSize', 20)
[fo, goodness]=fit(rD, xintercept', 'poly1')
plot(rD, fo.p1.*rD+fo.p2, 'b', 'LineWidth', 1.5)
xlim([0 max(rD)+0.5])
ylim([0, max(xintercept)+1])
title(['r square=' num2str(goodness.rsquare)])
%%
% subplot(2, 2, 4)
% hist(d)
figure(4)
try
subplot(1, 3, 1)
scatter(eStart, M)
xlim([0 1])
xlabel('estart')
ylabel('mean')
subplot(1, 3, 2)
scatter(lWaste, M)
xlim([0 1])
xlabel('lWaste')
ylabel('mean')

subplot(1, 3, 3)
scatter(rWaste, M)
xlim([0 1])
xlabel('rWaste')
ylabel('mean')
end

figure(5)
try
subplot(1, 3, 1)
scatter(M, PV)
xlabel('mean')
ylabel('percentVar')

subplot(1, 3, 2)
scatter(pref(:, 1)*100, PV)
xlabel('pref left')
ylabel('percentVar')

subplot(1, 3, 3)
bar([PV, pref(:, 1)*100])
legend('PV', 'Pref Left')
ylim([0 100])
end

yay1=find(PV<20);
yay2=find(abs(.5-pref(:, 1))<0.05);

Mouse(yay1);
Day(yay1);
Mouse (yay2);
Day(yay2);
[Mouse(yay1)', PV(yay1), M(yay1), pref(yay1, :)];
[Mouse(yay2)', PV(yay2), M(yay2), pref(yay2, :)];
allMean=mean(Delay);
allVar=var(Delay);
