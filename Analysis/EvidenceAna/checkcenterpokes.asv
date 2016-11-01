




lookAtTrials=[1, 50];





figure

trialno=e.trialNo(1:end-1);
valveSwitch=e.secondaryCueDelay+e.centerPokeDelay;
qualifying=e.cueSamplingTime+e.centerPokeDelay;

stim=find(e.cueOnTTL(a.validTrials));
% lookAtTrials=length(a.trialAvailTime);

if a.centerIn(1)>a.centerOut(1)
    a.centerOut(1)=[];
end
for i=1:length(e.events)
        time(i)=str2num(e.events{i,2})';
end
subplot(3, 2, [1, 3])
hold on
    trialStartTime=[time(ismember(e.events(:, 1), 'TrialStarted'))', find(ismember(e.events(:, 1), 'TrialStarted'))];
    trialAvailTime=[time(ismember(e.events(:, 1), 'TrialAvailable'))', find(ismember(e.events(:, 1), 'TrialAvailable'))];
% %%
hold on
before=2;
after=10;
samplingRate=1000;
centerPokeInMatrix=zeros(lookAtTrials(end)-lookAtTrials(1)+1,(before+after)*samplingRate+1);
alignEvent=trialAvailTime;
centerPokesAvail=[];

for i=1:length(alignEvent(:, 1))
    try
        centerInd=intersect(find(a.centerIn>alignEvent(i, 1)), find(a.centerIn<alignEvent(i, 1)+after));
        centerInd=centerInd(1);
        centerPokesAvail=[centerPokesAvail; a.centerOut(centerInd)-a.centerIn(centerInd), ismember(trialno(alignEvent(i, 2)), stim), valveSwitch(trialno(alignEvent(i, 2)));];
        trialStartInd=intersect(find(trialStartTime(:, 1)>alignEvent(i, 1)-before), find(trialStartTime(:, 1)<alignEvent(i, 1)+after));
        trialAvailInd=intersect(find(trialAvailTime(:, 1)>alignEvent(i, 1)-before), find(trialAvailTime(:, 1)<alignEvent(i, 1)+after));
        text(1.5, i, num2str(trialno(alignEvent(i, 2))))
        plot([a.centerIn(centerInd)-a.centerIn(centerInd), a.centerOut(centerInd)-a.centerIn(centerInd)], ones(1, 2)*i,'LineWidth', 3, 'Color', 'k');
        if a.centerIn(centerInd)>trialAvailTime(i, 1) && ismember(trialno(alignEvent(i, 2)), stim)
               plot([a.centerIn(centerInd)-a.centerIn(centerInd), a.centerOut(centerInd)-a.centerIn(centerInd)], ones(1, 2)*i,'LineWidth', 3, 'Color', opsin);    
               t1=text(1.5, i, num2str(trialno(alignEvent(i, 2))));
               set(t1, 'Color', opsin);
        end

            in=round(samplingRate*(a.centerIn(centerInd)-a.centerIn(centerInd)));
            out=round(samplingRate*(a.centerOut(centerInd)-a.centerIn(centerInd)));
            centerPokeInMatrix(i, [in:out]+before*samplingRate)=1; 
        
        try
            if trialStartTime((trialStartInd), 1)-a.centerOut(centerInd)<0.3
                plot(trialStartTime((trialStartInd), 1)-a.centerIn(centerInd), i, '.', 'Color', red, 'MarkerSize', 12)
            end
            plot(trialAvailTime((trialAvailInd), 1)-a.centerIn(centerInd), i, '.', 'Color', blue, 'MarkerSize', 12)
        end
    end
    try
                    plot(valveSwitch(switchInd)-a.centerIn(centerInd), i, '.', 'Color', 'c', 'MarkerSize', 12)
    end
    try
                valve=valveSwitch(trialno(alignEvent(i, 2)));
                valveDot=plot([valve, valve], [i-0.2, i+0.2], 'c', 'LineWidth', 4);        
                uistack(valveDot(1), 'top')
    end
    
    if length(trialStartInd>0) && trialStartInd==lookAtTrials(end)
        break
    end
end

    xlim([-2, 2])
    plot([0, 0], [0, i], 'Color', gray);
    plot([0.3, 0.3], [0, i], 'Color', green);
    set(gca,'Ydir','reverse')
    ylabel('trials')
    xlabel('Time from trial available (s)')


    
    subplot(3, 2, [2, 4])
hold on
    trialStartTime=[time(ismember(e.events(:, 1), 'TrialStarted'))', find(ismember(e.events(:, 1), 'TrialStarted'))];
    trialAvailTime=[time(ismember(e.events(:, 1), 'TrialAvailable'))', find(ismember(e.events(:, 1), 'TrialAvailable'))];
% %%
hold on
before=10;
after=4;
samplingRate=1000;
centerPokeInMatrix=zeros(lookAtTrials,(before+after)*samplingRate+1);
alignEvent=trialStartTime;
startCenterPokes=[];
for i=lookAtTrials(1):length(alignEvent(:, 1))
    centerInd=intersect(find(a.centerIn>alignEvent(i, 1)-before), find(a.centerIn<trialStartTime(i, 1)));
    trialStartInd=intersect(find(trialStartTime(:, 1)>alignEvent(i, 1)-before), find(trialStartTime(:, 1)<alignEvent(i, 1)+after));
    trialAvailInd=intersect(find(trialAvailTime(:, 1)>alignEvent(i, 1)-before), find(trialAvailTime(:, 1)<alignEvent(i, 1)+after));
    for j=1:length(centerInd)
        plot([a.centerIn(centerInd(j))-alignEvent(i, 1), a.centerOut(centerInd(j))-alignEvent(i)], ones(length(centerInd), 2)*i,'LineWidth', 3, 'Color', 'k')    
        
        if a.centerIn(centerInd(j))>trialAvailTime(i, 1) && ismember(trialno(alignEvent(i, 2)), stim)
                plot([a.centerIn(centerInd(j))-alignEvent(i, 1), a.centerOut(centerInd(j))-alignEvent(i, 1)], ones(length(centerInd), 2)*i,'LineWidth', 3, 'Color', opsin)    
        end
        
        in=round(samplingRate*(a.centerIn(centerInd(j))-alignEvent(i, 1)));
        out=round(samplingRate*(a.centerOut(centerInd(j))-alignEvent(i, 1)));
        centerPokeInMatrix(i,[in:out]+before*samplingRate)=1; 
        
    end
        text(-before, i, num2str(trialno(alignEvent(i, 2))))
        startCenterPokes=[startCenterPokes; a.centerOut(centerInd(j))-a.centerIn(centerInd(j)), j,  ismember(trialno(alignEvent(i, 2)), stim)];
    try
        plot(trialStartTime((trialStartInd), 1)-alignEvent(i, 1), i, '.', 'Color', red, 'MarkerSize', 12)
        plot(trialAvailTime((trialAvailInd), 1)-alignEvent(i, 1), i, '.', 'Color', blue, 'MarkerSize', 12)
    end
    if trialStartInd==lookAtTrials
        break
    end
end
    plot([0, 0], [0, i], 'Color', gray);
    set(gca,'Ydir','reverse')
    ylabel('trials')
    xlabel('Time from trial Start (s)')
    xlim([-10, 4])
    
%     %%
    valveValues=sort(unique(centerPokesAvail(:, 3)));
    
    subplot(3, 2, 5)
     
hold on

C=centerPokesAvail(centerPokesAvail(:, 3)==valveValues(1), :)
try
    cStim=plotHist(C(find(C(:, 2)==1), 1), samplingTimeBinWidth, opsin, opsin, 1, normalize);
    [h1, p1]=kstest2(C(find(C(:, 2)==1), 1), C(find(C(:, 2)==0), 1));
    text(0.7, 18, ['p=', num2str(p1)]);
end

cUnstim=plotHist(C(find(C(:, 2)==0), 1), samplingTimeBinWidth, 'k', 'k', 1, normalize);

ylim([0 30]);
xlim([0, 1.1*max(centerPokesAvail(:, 1))]);

title(['valve Switch at ', num2str(round(1000*valveValues(1))), 'ms']);
xlabel('Sampling Time');
ylabel('Count');
tOn=text(0.7, 28, 'Light On');
tOff=text(0.7, 23, 'Light Off');
set(tOn, 'Color', opsin);


try
    subplot(3, 2, 6)
    C=centerPokesAvail(centerPokesAvail(:, 3)==valveValues(2), :)

    hold on
    try
        cStim=plotHist(C(find(C(:, 2)==1), 1), samplingTimeBinWidth, opsin, opsin, 1, normalize);
        [h1, p1]=kstest2(C(find(C(:, 2)==1), 1), C(find(C(:, 2)==0), 1));
        text(0.7, 18, ['p=', num2str(p1)]);
    end

    cUnstim=plotHist(C(find(C(:, 2)==0), 1), samplingTimeBinWidth, 'k', 'k', 1, normalize);

    ylim([0 30]);
    xlim([0, 1.1*max(centerPokesAvail(:, 1))]);

    title(['valve Switch at ', num2str(round(1000*valveValues(2))), 'ms']);
    tOn=text(0.7, 28, 'Light On');
    tOff=text(0.7, 23, 'Light Off');
    set(tOn, 'Color', opsin);
    
end

suptitle([num2str(mouse), '  ', datestr(dateRun)])
    %%
figure
hold on
plot(startCenterPokes(find(startCenterPokes(:, 3)==1), 2), startCenterPokes(find(startCenterPokes(:, 3)==1), 1), 'o', 'Color', opsin)
plot(startCenterPokes(find(startCenterPokes(:, 3)==0), 2), startCenterPokes(find(startCenterPokes(:, 3)==0), 1), 'o', 'Color', gray)

plot(mean(startCenterPokes(find(startCenterPokes(:, 3)==1), 2)), mean(startCenterPokes(find(startCenterPokes(:, 3)==1), 1)), 's', 'Color', 'r')
plot(mean(startCenterPokes(find(startCenterPokes(:, 3)==0), 2)), mean(startCenterPokes(find(startCenterPokes(:, 3)==0), 1)), 's', 'Color', 'g')







