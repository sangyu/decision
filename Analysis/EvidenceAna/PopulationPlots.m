

figure(2000)
subplot(211)
foff=plotHist(splT(unstimTrials), samplingTimeBinWidth, 'k', 'k', 1, normalize);
    fon=plotHist(splT(stimTrials), samplingTimeBinWidth, opsin, opsin, 1, normalize);
    [hsOnOff, psOnOff]=kstest2(splT(stimTrials), splT(unstimTrials))
    ymax=max([fon, foff]);
    text(median(splT)+std(splT), ymax*0.8, ['Light On, ', num2str( round(10000*mean(data(stimTrials, 3)))/100), '% correct'], 'Color', opsin)
    text(median(splT)+std(splT), ymax*1.0, ['Light On mean ST ', num2str( round(100*mean(splT(stimTrials)))/100), 's'], 'Color', opsin)
    text(median(splT)+std(splT), ymax*1.1, ['ks Test h = ', num2str(hsOnOff), ' p = ', num2str(psOnOff)], 'Color', 'k')
text(median(splT)+std(splT), ymax*0.7, ['Light Off, ', num2str(round(10000* mean(data(unstimTrials, 3)))/100), '% correct'], 'Color', 'k')
text(median(splT)+std(splT), ymax*0.9, ['Light Off mean ST ', num2str( round(100*mean(splT(unstimTrials)))/100), 's'], 'Color', 'k')
xlim([0 0.8])
nboot=500;
splTbsOff=bootstrp(nboot, @mean, splT(unstimTrials) );
a=ksdensity(splTbsOff)
% splTbsOff=bootstrp(125, 'mean', splTbsOff);
splTbsOn=bootstrp(nboot, @mean, splT(stimTrials) );
% splTbsOn=bootstrp(125, 'mean', splTbsOn);
% %%
subplot(212)
foff=plotHist(splTbsOff, samplingTimeBinWidth, 'k', 'k', 1, normalize);
fon=plotHist(splTbsOn, samplingTimeBinWidth, opsin, opsin, 1, normalize);
xlim([0 0.8])