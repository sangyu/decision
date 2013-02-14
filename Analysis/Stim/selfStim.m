clear;
close all
CColor=[.3 .6 .8];
LColor=[0.3 .8 .6];
RColor=[.8 .3 0.6];
delete '.DS_Store';

% Data
allPorts={'C', 'L', 'R'};
C=[0, 0];
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
%     filename=D(1).name;
%     
%     [exptSetup, action]=extractOlfData(filename);
% activePorts={input('activeport=', 's')};
% inactivePorts={setdiff( allPorts, activePorts)};
% for j=1:length(allPorts)
%     pokes=eval(port(allPorts{j}));
% assignin('base', allPorts{j}, [eval(allPorts{j});pokes, ones(length(pokes), 1)*ismember(allPorts{j}, activePorts)])
% end
% 



figure

% subplot(6, n+2, [1, n+2+1, 2*(n+2)+1])
% 
% hold on
% CPort=plot(C(:, 1)/60, [1:length(C(:, 1))], ':', 'Color', CColor, 'LineWidth', 1.5)
% LPort=plot(L(:, 1)/60, [1:length(L(:, 1))], ':', 'Color', LColor, 'LineWidth', 1.5)
% RPort=plot(R(:, 1)/60, [1:length(R(:, 1))], ':', 'Color', RColor, 'LineWidth', 1.5)
% legend('C', 'L', 'R')
% 
% for j=1:length(activePorts)
%     t=[(activePorts{j}), 'Port']
%     set(eval(t), 'LineStyle', '-')
% end
% xlabel('time/min')
% ylabel('cumulative number of pokes')
% ylim([0 100])
% xlim([0 max([action.centerIn ;action.leftIn; action.rightIn])/60+10])
% title(' session 1')


for i=1:n
    filename=D(i).name
    i
    [exptSetup, action]=extractOlfDataStim(filename);
    m=max([C( end, 1), L(end, 1), R(end,1)]);
%     r=length(action.centerIn)/(length(action.leftIn)+length(action.rightIn))/2;
activePorts={input('activeport1=', 's'), input('activeport2=', 's')};
if ismember(activePorts(2), 'N')|ismember(activePorts(1), activePorts(2))
    activePorts(2)=[];
end
    

inactivePorts=setdiff(allPorts, activePorts);
for j=1:length(allPorts)
    pokes=eval(port(allPorts{j}));
assignin('base', allPorts{j}, [eval(allPorts{j});m+pokes-min([action.centerIn ;action.leftIn; action.rightIn]), ones(length(pokes), 1)*ismember(allPorts{j}, activePorts)])
end

figure(1)
subplot(6, n+2, [i, n+2+i, 2*(n+2)+i])
hold on
try
for j=1:length(allPorts)
    pokes=eval(port(allPorts{j}))-min([action.centerIn ;action.leftIn; action.rightIn]);
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
xlim([ 0 max([action.centerIn ;action.leftIn; action.rightIn])/60-min([action.centerIn ;action.leftIn; action.rightIn])/60+10])

ylim([0 200])
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

figure(1)
legend('C', 'L', 'R')

subplot(6, n+2, [n+1:n+2, 2*(n+2)-1: 2*(n+2), 3*(n+2)-1:3*(n+2)])
hold on
for j=1:length(allPorts)
    A=eval(allPorts{j});
    plot(A(:, 1)/60, [1:length(A)], '-', 'Color', eval([allPorts{j}, 'Color']), 'LineWidth', 1.5)
    B=A(:, 1).*A(:, 2);
    I=find(B);
%     plot(B(I)/60, I, 'x', 'Color', eval([allPorts{j}, 'Color']), 'LineWidth', 1.5 )
end

plot([0, 0, max([C(:, 1) ;L(:, 1); R(:, 1)]/60+10), max([C(:, 1) ;L(:, 1); R(:, 1)]/60+10), 0], [0, 250, 250, 0, 0],  'Color', [.5, .4, 1], 'LineWidth', 3)



% for j=1:length(activePorts)
%     set(eval(activePorts{j}), 'LineStyle', '-')
% end
title(' cumulative ')
xlabel('time/min')
% ylabel('cumulative number of pokes')
ylim([0 251])
xlim([0 max([C(:, 1) ;L(:, 1); R(:, 1)])/60+10])


% 
% subplot(6,n+2,[(n+2)*3+1:(n+2)*4])
% plotHist(C(:, 1)/60, 1, CColor, CColor, 0);
% xlim([0 max([C(:, 1) ;L(:, 1); R(:, 1)])/60+10])
% ylim([0 20])
% subplot(6,n+2,[(n+2)*4+1:(n+2)*5])
% plotHist(L(:, 1)/60, 1, LColor, LColor, 0);
% xlim([0 max([C(:, 1) ;L(:, 1); R(:, 1)])/60+10])
% ylim([0 20])
% subplot(6,n+2,[(n+2)*5+1:(n+2)*6])
% xlim([0 max([C(:, 1) ;L(:, 1); R(:, 1)])/60+10])
% ylim([0 20])
% plotHist(R(:, 1)/60, 1, RColor, RColor, 0);

suptitle(exptSetup.mouseID)

figure(2)
hold on
plot([0 length(aPokesC)], [0 0])
title(exptSetup.mouseID)

%%
itic=diff(C);
itil=diff(L);
itir=diff(R);

figure
title(exptSetup.mouseID)

% subplot(311)
% plotHist(itic, 5, CColor, CColor, 1);
% legend('center poke')
% xlim([0 500])
% ylim([0 50])
% subplot(312)
% plotHist(itil, 5, LColor, LColor, 1);
% legend('left poke')
% xlim([0 500])
% ylim([0 50])
% subplot(313)
% plotHist(itir, 5, RColor, RColor, 1);
% legend('right poke')
% xlim([0 500])
% ylim([0 50])
% xlabel('inter-poke intervals/s')

%% bootstrap
variables={'itic', 'itil', 'itir'};
nboot=250;
rsm=zeros(nboot, length(variables));

for i=1:length(variables)
    assignin('base', 'sample', eval(variables{i}));
    for j=1:nboot
        l=length(sample);
        rs=randsample(sample,round(l/2), true);
        rsm(j, i)=mean(rs);
    end
end


figure
title(exptSetup.mouseID)


range=[min(min(rsm)) max(max(rsm))];
subplot(311)
plotHist(rsm(:, 1), 5, CColor, CColor, 1);
xlim(range)
ylim([0 nboot/5])
subplot(312)
plotHist(rsm(:, 2), 5, LColor, LColor, 1);
xlim(range)
ylim([0 nboot/5])
subplot(313)
plotHist(rsm(:, 3), 5, RColor, RColor, 1);
xlim(range)
ylim([0 nboot/5])
xlabel('bootstrapped sample mean of inter-poke intervals/s')

[H1,P1,CI1,STATS1]=ttest(rsm(:, 1), rsm(:, 2))
[H2,P2,CI2,STATS2]=ttest(rsm(:, 1), rsm(:, 3))
[H3,P3,CI3,STATS3]=ttest(rsm(:, 2), rsm(:, 3))
