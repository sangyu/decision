figure

subplot(131)

foff=plotHist(splT(unstimTrials), samplingTimeBinWidth, 'k', 'k', 1, normalize);

ylabel('count')
subplot(132)

    fon=plotHist(splT(stimTrials), samplingTimeBinWidth, opsin, opsin, 1, normalize);
xlabel('sampling time (s)')

subplot(133)

hold on

foff=plotHist(splT(unstimTrials), samplingTimeBinWidth, 'k', 'k', 1, normalize);
    fon=plotHist(splT(stimTrials), samplingTimeBinWidth, opsin, opsin, 1, normalize);
suptitle('414, day 17 oct-2 ')
