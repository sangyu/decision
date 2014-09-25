%lynx

filename='CSC12.ncs';
FieldSelection(1) = 1;%timestamps
FieldSelection(2) = 0;
FieldSelection(3) = 1;%sample freq
FieldSelection(4) = 0;
FieldSelection(5) = 1;%samples
ExtractHeader = 1;

ExtractMode = 1; % 2 = extract record index range; 4 = extract timestamps range.


[timestamps,fs, datasamples, header] = Nlx2MatCSC_v3(filename, FieldSelection, ExtractHeader, ExtractMode);

%flatten
datasamples=datasamples(:);


    %%
window=50000;
nOverlap=00;
F=0:.5:12;  
fs=32000; 
subplot(121)
spectrogram(datasamples, window, nOverlap, F, fs, 'yaxis')
 [s, f, t, p]=spectrogram(datasamples, window, nOverlap, F, fs, 'yaxis');

subplot(122)

 plot(mean(p, 2), '*-')

 
 %%
 load('TT12_1.mat')
 w=1000;

 nevfn='Events.nev'
[timestamps, ttls] = extractTTLsAndTimestampsFromNEVfile(nevfn)
stimFq=10;
stimWd=10;
stimN=10;
stimW=[-1, -1 ];
for i=1:stimN
    stimW=[stimW; (i-1)*1000/stimFq, 1; stimWd+(i-1)*1000/stimFq, 1; stimWd+(i-1)*1000/stimFq+0.0000000001, -1; i*1000/stimFq-0.0000000001, -1];
end

figure(1)


 diffdeg=log10(timestamps(1))-log10(TS(1))
 ts1=round(timestamps(1)/(10^ceil(diffdeg)));
 TS=round(TS)
 TS1=TS(1);
 timestamps=round(timestamps'/100);
 
 if ts1>=TS1
     timestamps=timestamps-TS1
     TS=TS-TS1
 else
     timestamps=timestamps-ts1
     TS=TS-ts1
 end
plot(TS,1,'r.')
hold on
plot(timestamps, ttls, 'b.')

stim=timestamps(ttls==1)
viewRange=1;

figure(2)
subplot(211)
hold on
allspikes=zeros(1, TS(end));
allspikes(TS)=1;
spikemat=[];

try
for i=1:20
    ind=stim(i);
    spikes=allspikes(ind-viewRange*fs:ind+viewRange*fs);
    plot(find(spikes)/fs-viewRange, i, 'r', 'MarkerSize', 4)
    spikemat=[spikemat; spikes];
    hold on
end
end

plot(stimW(:, 1)/1000, i*stimW(:, 2)+2)
ylim([1 i+1])

subplot(212)
hold on
sumAllSpikes=sum(spikemat);
slideTrain=[];
maxSpikeRate=0;

for i=1:length(sumAllSpikes)/w-1
    ind=[(i-1)*w+1:i*w];
    segmentSum=length(find(sumAllSpikes(ind)));
    spikeRate=segmentSum/(w/fs)/length(sumAllSpikes)*1000;
    slideTrain=[slideTrain; spikeRate];
    fill([w*(i-1), w*i, w*i, w*(i-1)]/fs-viewRange, [ spikeRate, spikeRate, 0, 0], 'k')
    if max(spikeRate)>maxSpikeRate
        maxSpikeRate=max(spikeRate);
    end
end
plot(stimW(:, 1)/1000, maxSpikeRate*stimW(:, 2)*1.5)
ylim([0 maxSpikeRate*1.1])
xlabel('time/s')
ylabel('Hz')