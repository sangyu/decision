clear;
close all
LColor=[0.3 .8 .6];
RColor=[.8 .3 0.6];
delete '.DS_Store';

% Data
allPorts={ 'L', 'R'};
L=[0, 0];
R=[0, 0];

D = dir;


% Engine
% S = [D(:).name]; % you may want to eliminate . and .. first.
% [S,S] = sort(S);
% S = {D(S).name}; % Cell array of names in order by datenum.
td=[];

for i=1:length(D)
    if length(D(i).name)<5
        td=[td; i];
    end
    
end
D(td)=[];
        
n=length(D);

for i=1:length(D)
    dates(i)=getfield(D(i), 'datenum');
end

 [y, ind]=sort(dates);
 
 
for i=1:n
    filename=D(ind(i)).name
    i
    [exptSetup, action]=extractOlfDataStim(filename);
    m=max([ L(end, 1), R(end,1)]);
% r=length(action.centerIn)/(length(action.leftIn)+length(action.rightIn))/2;
% activePorts={input('activeport1=', 's'), input('activeport2=', 's')};
activePorts={exptSetup.scheduleID(end-2),exptSetup.scheduleID(end-2)};

if ismember(activePorts(2), 'N')|ismember(activePorts(1), activePorts(2))
    activePorts(2)=[];
end
    

inactivePorts=setdiff(allPorts, activePorts);
for j=1:length(allPorts)
    pokes=eval(port(allPorts{j}));
assignin('base', allPorts{j}, [eval(allPorts{j});m+pokes-min([action.leftIn; action.rightIn]), ones(length(pokes), 1)*ismember(allPorts{j}, activePorts)])
end

figure(1)
subplot(6, n+2, [i, n+2+i, 2*(n+2)+i])
hold on
try
for j=1:length(allPorts)
    pokes=eval(port(allPorts{j}))-min([action.leftIn; action.rightIn]);
    h=plot(pokes/60, [1:length(pokes)], ':', 'Color', eval([allPorts{j}, 'Color']), 'LineWidth', 1.5);
    assignin('base', [(allPorts{j}), 'Port'], h)
    
end
% legend('C', 'L', 'R')

for j=1:length(activePorts)
    t=[(activePorts{j}), 'Port'];
    set(eval(t), 'LineStyle', '-');
end
end
xlabel('time/min')
% ylabel('cumulative number of pokes')


title([' session ', num2str(i)])
xlabel('time/min')
% ylabel('cumulative number of pokes')
xlim([ 0 max([action.leftIn; action.rightIn])/60-min([action.leftIn; action.rightIn])/60+10])

% ylim([0 200])
hold off



for j=1:length(activePorts)
    try
    if ismember(activePorts{j},'0')
        aPokes(j)=0;
    else
    aPokes(j)=length(eval(port(activePorts{j})))
    end
    end
end
for j=1:length(inactivePorts)
    if ismember(inactivePorts{j},'0')
        inPokes(j)=0;
    else
    inPokes(j)=length(eval(port(inactivePorts{j})))
     end
end

try
aPokesC(i)=mean(aPokes);
inPokesC(i)=mean(inPokes);
end
figure(2)
subplot(121)
hold on
if length(activePorts)==1 && ismember(activePorts, 'N')==0
se=eval([activePorts{1}, 'Color']);
bar(i, (aPokesC(i)-inPokesC(i))./(aPokesC(i)+inPokesC(i)), 'FaceColor', se)

elseif length(activePorts)==2
se=[0.98, 0.58, 0]
bar(i, (aPokesC(i)-inPokesC(i))./(aPokesC(i)+inPokesC(i)), 'FaceColor', se)

else
se=[.5 .5 .5]
end
try

hold on
plot([0 length(aPokesC)], [0 0])
end
ylim([-1 1])

end
preferenceIndex=(aPokesC-inPokesC)./(aPokesC+inPokesC)

figure(1)
legend('L', 'R')

subplot(6, n+2, [n+1:n+2, 2*(n+2)-1: 2*(n+2), 3*(n+2)-1:3*(n+2)])
hold on
for j=1:length(allPorts)
    A=eval(allPorts{j});
    plot(A(:, 1)/60, [1:length(A)], '-', 'Color', eval([allPorts{j}, 'Color']), 'LineWidth', 1.5)
    B=A(:, 1).*A(:, 2);
    I=find(B);
% plot(B(I)/60, I, 'x', 'Color', eval([allPorts{j}, 'Color']), 'LineWidth', 1.5 )
end

plot([0, 0, max([L(:, 1); R(:, 1)]/60+10), max([L(:, 1); R(:, 1)]/60+10), 0], [0, 250, 250, 0, 0], 'Color', [.5, .4, 1], 'LineWidth', 3)



% for j=1:length(activePorts)
% set(eval(activePorts{j}), 'LineStyle', '-')
% end
title(' cumulative ')
xlabel('time/min')
% ylabel('cumulative number of pokes')
ylim([0 251])
xlim([0 max([L(:, 1); R(:, 1)])/60+10])


suptitle(exptSetup.mouseID)

figure(2)
hold on
plot([0 length(aPokesC)], [0 0])
title(exptSetup.mouseID)


figure(2)
subplot(122)
bar([1 2], [mean(aPokesC), mean(inPokesC)], 'FaceColor', 'none')
hold on
e=errorbar([mean(aPokesC), mean(inPokesC)], [std(aPokesC), std(inPokesC)])
set(e, 'Color','k', 'LineStyle', 'none', 'LineWidth', 1.5)

plot(ones(1, length(aPokesC)), aPokesC, 'o', 'MarkerFaceColor', 'auto')
plot(2*ones(1, length(inPokesC)), inPokesC, 'o', 'MarkerFaceColor', 'auto')
alpha(0.3)
ylim([0 200])

[H,P,CI,STATS] = ttest(aPokesC, inPokesC)

if H==1
    plot(1.5, max([mean(aPokesC), mean(inPokesC)])+40, '*')
end
