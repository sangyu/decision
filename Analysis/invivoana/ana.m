%inVivoAna
clear;

%% reading the file and getting information about the experiment
filename='15108006.abf';
[d, si, h]=abfload(filename); % load the file
fs=10^6/si; % sampling frequency
elapsedTime=h.sweepLengthInPts/fs; % total time each sweep in seconds
numOfSweeps=h.lActualEpisodes; % number of sweeps performed
% %
fprintf([filename, '\n\n']) 
fprintf(['number of sweeps = ', num2str(numOfSweeps), '\n', ...
    'elapsed time each sweep = ', num2str(elapsedTime), 's\n', ...
    'sampling frequency = ', num2str(fs), 'Hz\n' ])

if mean(max(d(:, 2, :)))>0.1
    fprintf('\nStimulation = Yes\n')
else
    fprintf('\nStimulation = No\n')
end
% % Reshape data from chanel 1 and 2
D1=reshape(d(:, 1, :), [h.sweepLengthInPts numOfSweeps]);
D2=reshape(d(:, 2, :), [h.sweepLengthInPts numOfSweeps]);
% filter out 60Hz noise

% %%
figure(1)

time=[1:length(D1(:, 1))]/fs;

for i=1:numOfSweeps
% for i=[1:10,15:25, 29:50]
    
    plot(time, D1(:, i) +i*0.0005,'k' )
    hold on

D2(find(abs(D2(:, i))<0.001), i)=0;


stimStart=findPeaks(D2(:, i), 1, 3, 1, fs);
% stimStart=stimStart(1:2:length(stimStart)-1);
stimEnd=findPeaks(D2(:, i), -1, 5, 1, fs);
% stimEnd=stimEnd(2:2:length(stimEnd));

    try
        plot([stimStart, stimStart]/fs, 0.000002*[i, i+1], 'Color', [.5, .5, 0.8])

        plot([stimEnd, stimEnd]/fs, 0.000002*[i, i+1], 'Color', [.5, .5, 0.8])
        fill([stimStart, stimEnd, stimEnd, stimStart]/fs, 0.0005*[i+1, i+1, i, i], 'b', 'FaceAlpha', 1,'EdgeColor', 'none')
        alpha(0.2)
    end
end
ylim([0 numOfSweeps*0.0005])
xlabel('time/s')
ylabel('sweeps')
% %% raster



L=length(D1(:, 1));
NFFT = 2^nextpow2(L);
f = fs/2*linspace(0,1,NFFT/2+1);
Y = fft(D1,NFFT)/L;
Ystim=fft(D1(stimStart: stimEnd, :), NFFT)/L;
YunstimB=fft(D1(stimStart-(stimEnd-stimStart):stimStart, :), NFFT)/L;
YunstimA=fft(D1([stimEnd:stimEnd+(stimEnd-stimStart)], :), NFFT)/L;
Yf=Y;
near60=intersect(find(f>59.8), find(f<60.2));
below05=find(f<0.5);
forSpikes=find(f>20);
urBP=intersect(find(f>4), find(f<12));
ur4Hz=intersect(find(f>3), find(f<7));
YfurBP=Y(urBP, :);
Yspikes=Y(forSpikes, :);
Yur4Hz=Y(ur4Hz, :);
Yf(below05, :)=0;

ylp = ifft(Y, NFFT, 'symmetric')*L;
ylpSpikes = ifft(YforSpikes, NFFT, 'symmetric')*L;
ylpf = ifft(Yf, NFFT, 'symmetric')*L;
ylp = ylp(1:length(D1), :);
ylpSpikes = ylpSpikes(1:length(D1), :);
ylpf = ylpf(1:length(D1), :);
ylpurBP=ifft(YfurBP, NFFT, 'symmetric')*L;
ylpurBP = ylpurBP(1:length(D1), :);

ylp4Hz=ifft(Yur4Hz, NFFT, 'symmetric')*L;
ylp4Hz = ylp4Hz(1:length(D1), :);

ylpStim=ifft(Ystim, NFFT, 'symmetric')*L;
ylpStim = ylpStim(1:length(D1), :);

ylpUnstim=ifft(Yunstim, NFFT, 'symmetric')*L;
ylpUnstim = ylpUnstim(1:length(D1), :);


%%

figure(2)
subplot(211)
hold on
allspikes=zeros(length(D1(:, 1)),1);
percLower=-.0000000000001;
percUpper=.08;

if percLower<0
    lowerTh=percLower*min(min(D1));
else
    lowerTh=percLower*max(max(D1));
end
upperTh=percUpper*max(max(D1));

%%% disregard
    lowerTh=-0.0007;
    upperTh=-0.00015;



spikeInd=[];
waveforms=[];
halfWaveWidth=0.001; %seconds
for i=1:length(D1(1, :))
% for i=[1:10,15:25, 29:50]
    try
    [ind, W]=findPeaks(D1(:, i), lowerTh, upperTh, halfWaveWidth, fs);
    waveforms=[waveforms;W];
    spikeInd=[spikeInd; ind];
    allspikes(ind, i)=1;
    plot( ind/fs,i*ones(1, length(ind)), 'r.')
    catch
    end
end   

xlim([0 length(D1(:, 1))/fs])
% plot([stimStart, stimStart]/fs, [0, i+1], 'Color', [.5, .5, 0.8])
% plot([stimEnd, stimEnd]/fs, [0, i+1], 'Color', [.5, .5, 0.8])
try
fill([stimStart, stimEnd, stimEnd, stimStart]/fs, [length(D1(1, :)), length(D1(1, :)), 0, 0], [  0.2,  0.85,0.75], 'FaceAlpha', 1,'EdgeColor', 'none')
end
alpha(0.2)
xlabel('time/s')
ylabel('sweeps')

subplot(212)
hold on
sumAllSpikes=sum(allspikes ,2);
w=0.2*fs;
slideTrain=[];
for i=1:length(D1(:, 1))/w-1
    ind=[(i-1)*w+1:i*w];
    segmentSum=length(find(sumAllSpikes(ind)));
    spikeRate=segmentSum/(w*2/fs);
    slideTrain=[slideTrain; spikeRate];
    fill([w*(i-1), w*i, w*i, w*(i-1)]/fs, [ spikeRate, spikeRate, 0, 0], 'k')
end
xlim([0 length(D1(:, 1))/fs])
xlabel('time/s')
ylabel('firing rate/Hz')

fill([stimStart, stimEnd, stimEnd, stimStart]/fs, [40, 40, 0, 0], [  0.2,  0.85,0.75], 'FaceAlpha', 1,'EdgeColor', 'none')
alpha(0.2)

% %%
waveformsL=waveforms';
waveformsL(:, find(min(waveformsL)<lowerTh))=[];

lowpeaks=min(waveformsL);
highpeaks=max(waveformsL);
wlm=mean(lowpeaks);
wls=std(lowpeaks);
whm=mean(highpeaks);
whs=std(highpeaks);
goodInd=intersect(find(lowpeaks>wlm-wls), find(highpeaks<whm+whs));

cleanedupWaveforms=waveformsL(:,goodInd );

figure(3)
subplot(121)
plot([-halfWaveWidth*fs:halfWaveWidth*fs]/fs*1000,0-cleanedupWaveforms)
xlabel('time (ms)')
axis square
subplot(122)
plot([-halfWaveWidth*fs:halfWaveWidth*fs]/fs*1000, 0-mean(cleanedupWaveforms,2), 'Color', [  0.2,  0.85,0.75])
axis square

xlabel('time (ms)')
%% spectrogram
   %


figure(4)
subplot(121)
hold on 
for i=1:length(ylpurBP(1, :))
plot(time, ylpurBP(1:length(time), i) +i*0.00009,'k' )
try
fill([stimStart, stimEnd, stimEnd, stimStart]/fs, 0.00009*[i+1, i+1, i, i], 'b', 'FaceAlpha', 1,'EdgeColor', 'none')
end
end
alpha(0.2)

% plot(ylpurBP(:, 1), 'k')
% plot(ylp4Hz(:, 1), 'r')
xlim([0 length(ylp4Hz(:, 1))/fs])
xlabel('time/s')
ylabel('LFP bp 4Hz-12Hz')


subplot(122)
hold on 
for i=1:length(ylp4Hz(1, :))
plot(time, ylp4Hz(1:length(time), i) +i*0.00009,'k' )
try
fill([stimStart, stimEnd, stimEnd, stimStart]/fs, 0.00009*[i+1, i+1, i, i], 'b', 'FaceAlpha', 1,'EdgeColor', 'none')
end
end
alpha(0.2)

% plot(ylpurBP(:, 1), 'k')
% plot(ylp4Hz(:, 1), 'r')
xlim([0 length(ylp4Hz(:, 1))/fs])
xlabel('time/s')
ylabel('LFP bp 4Hz')
%
%% 
figure(5)
hold on
% plot(f,2*abs(Y(1:NFFT/2+1)), 'k') 
plot(f,2*abs(Ystim(1:NFFT/2+1)), 'g') 
plot(f,2*abs(YunstimA(1:NFFT/2+1)), 'r') 
plot(f,2*abs(YunstimB(1:NFFT/2+1)), 'k') 

xlim([2 100])
%%
window=2000;
nOverlap=0;
P=[];
F=0:.2:100;  

for i=1:length(ylpf(1, :))

    a=ylpf(:, i);
    [s, f, t, p]=spectrogram(a, window, nOverlap, F, fs, 'yaxis');
    P(:, :, i)=p;
%     figure(5+i)
    
% surf(t,f,10*log10(abs(p)), 'EdgeColor','none');
axis tight;
view(0,90);

end

%%
figure(6)


mp1=mean(P, 3);
mp=mean(mp1, 2);
mpStim=mean(P, 3);
try
stimRange=intersect(find(t>stimStart/fs), find(t<stimEnd/fs));
mpStim=mean(P(:, stimRange, :), 3);

end
mpStim=mean(mpStim, 2);
try
mpBeforeStim=mean(P(:, find(t<stimStart/fs), :), 3);
mpBeforeStim=mean(mpBeforeStim, 2);
mpAfterStim=mean(P(:, find(t>stimEnd/fs), :),  3);
mpAfterStim=mean(mpAfterStim, 2);
end
surf(t,f,10*log10(abs(mp1)), 'EdgeColor','none');
axis square;
view(0,90);
colorbar
% %
figure(7)
hold on
plot(F, mp, 'g')
try
plot(F, mpBeforeStim, 'k')
plot(F, mpAfterStim, 'r')
end
%%
a=ylpurBP(:, 1);
 [s, f, t, p]=spectrogram(a, window, nOverlap, F, fs, 'yaxis');
    
surf(t,f,10*log10(abs(p)), 'EdgeColor','none');
view(0,90);



figure(5)
hold on
Ystim=Y(stimStart:stimEnd, :)
plot(f,2*abs(Y(1:NFFT/2+1))) 
plot(f,2*abs(Yf(1:NFFT/2+1)), 'r') 

