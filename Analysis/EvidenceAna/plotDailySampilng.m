function plotDailySampling(data, centerPokesAvail, startEnd, secondary, cutAbort, cutLeftOff, geno, imagepath)


set(0,'DefaultAxesFontName', 'Arial')
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultTextFontname', 'Arial')
set(0,'DefaultTextFontSize', 8)
markers={'o';'^';'d';'s';'p';'h';'*' };
red=[ 0.85    0.20   0.20];
blue=[ 0.3    0.4    0.9];
orange= [0.9, 0.3,  0];
gray=[.4, .4, .4];
green=[  .3,  0.75,0.5];
yellow=[1, 0.95, 0.4];
pink= [0.9, 0.3,  0.6];


samplingTimeBinWidth=0.05;
minSamplingBin=0;
maxSamplingBin=0.8;
normalize=0;


f30=figure(30)
valveValues=sort(unique(data(:, 16)))
set(f30, 'Position', [200, 200,  300*length(valveValues)+100, 700])

if length(valveValues)>1
    ymaxV=0;
    for i=1:length(valveValues)
        sp=subplot(2, length(valveValues),  i);
        assignin('base', ['sp', num2str(i)], sp);
        dataValve=data(data(:, 16)==valveValues(i), :);
        hold on

        try
            foff=plotHist(dataValve((dataValve(:, 10)==0), 4), samplingTimeBinWidth, 'k', 'k', 1, normalize);
            if stimPresent==1
                fon=plotHist(dataValve((dataValve(:, 10)==1), 4), samplingTimeBinWidth, opsin, opsin, 1, normalize);
                [hsOnOff, psOnOff]=kstest2(dataValve((dataValve(:, 10)==0), 4), dataValve((dataValve(:, 10)==1), 4))
                ymaxV=max([fon, foff, ymaxV]);
            else 
                ymaxV=max(foff);
            end
        end
        if stimPresent==1
%             text(median(splT)+std(splT), ymaxV*1.3, ['Light On, ', num2str( round(10000*mean(data(stimTrials, 3)))/100), '% correct'], 'Color', opsin)
            text(median(splT)+std(splT), ymaxV*0.9, ['mean ST_{On}=', num2str( round(100*mean(dataValve((dataValve(:, 10)==1), 4)))/100), 's'], 'Color', opsin)
            text(median(splT)+std(splT), ymaxV*0.7, ['ks Test p = ', num2str( round(100*psOnOff)/100)], 'Color', 'k')
        end
%         text(median(splT)+std(splT), ymaxV*1.5, ['Light Off, ', num2str(round(10000* mean(data(unstimTrials, 3)))/100), '% correct'], 'Color', 'k')
        text(median(splT)+std(splT), ymaxV*1.1, ['mean ST_{Off}=', num2str( round(100*mean(dataValve((dataValve(:, 10)==0), 4)))/100), 's'], 'Color', 'k')
        plot([valveValues(i) valveValues(i)], [0 ymaxV*5], 'LineWidth', 0.5, 'Color', blue)
        xlabel('Sampling Time')
        ylabel('Count')
        title(['Switch at ', num2str(1000*valveValues(i))])
    end
    
    for i=1:length(valveValues)
        subplot(eval(['sp', num2str(i)]))
        plot([odorOnset odorOnset], [0 ymaxV*2],  'LineWidth', 0.5,'Color', gray)
        plot([qualifying qualifying], [0 ymaxV*2],  'LineWidth', 0.5,'Color', orange)
        ylim([0 ymaxV*1.7])
        xlim([0, 1.1*max(data(:, 4))]);
    end
end

    suptitle(['Different Valve Switch Values: ', mat2str(valveValues*1000), ' ms'])





subplot(2, 2, 3)
     
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
    subplot(2, 2, 4)
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