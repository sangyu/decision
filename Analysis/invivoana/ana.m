%inVivoAna
clear;

%% 
close all;
fs=20000;
D=[];
filename='12321017.abf'

figure(1)
for i=1:10
    [d, si, h]=abfload(filename, 'sweeps', i);
    y=d(:, 1);
    NFFT = length(y);
    Y = fft(y,NFFT);
    F = ((0:1/NFFT:1-1/NFFT)*fs).';
    Y(find(F==60))=0;
    ylp = ifft(Y,'symmetric');
    D=[D, y];
    time=[1:length(d)]/fs;
    plot(time, ylp +i*0.0005,'k' )
    hold on
end

stimStart=find(d(:, 2)==max(d(:, 2)));
stimEnd=find(d(:, 2)==min(d(:, 2)));
plot([stimStart, stimStart]/fs, 0.0005*[0.5, i+1], 'Color', [.5, .5, 0.8])
plot([stimEnd, stimEnd]/fs, 0.0005*[0.5, i+1], 'Color', [.5, .5, 0.8])
fill([stimStart, stimEnd, stimEnd, stimStart]/fs, 0.0005*[i+1, i+1, 0.5, 0.5], 'b', 'FaceAlpha', 1,'EdgeColor', 'none')
alpha(0.2)
xlabel('time/s')
ylabel('sweeps')
%% raster
figure(2)
subplot(211)
hold on
allspikes=zeros(length(D(:, 1)),1);
percLower=-.7;
percUpper=1;

if percLower<0
    lowerTh=percLower*min(min(D));
else
    lowerTh=percLower*max(max(D));
end
upperTh=percUpper*max(max(D));
spikeInd=[];
waveforms=[];

for i=1:length(D(1, :))
    try
    [ind, W]=findPeaks(D(:, i), lowerTh, upperTh, 5, fs);
    waveforms=[waveforms;W];
    spikeInd=[spikeInd; ind]
    allspikes(ind, i)=1;
    plot( ind/fs,i*ones(1, length(ind)), 'r.')
    catch
    end
end   

xlim([0 length(D(:, 1))/fs])
% plot([stimStart, stimStart]/fs, [0, i+1], 'Color', [.5, .5, 0.8])
% plot([stimEnd, stimEnd]/fs, [0, i+1], 'Color', [.5, .5, 0.8])
fill([stimStart, stimEnd, stimEnd, stimStart]/fs, [length(D(1, :)), length(D(1, :)), 0, 0], 'b', 'FaceAlpha', 1,'EdgeColor', 'none')
alpha(0.2)
xlabel('time/s')
ylabel('sweeps')

subplot(212)
hold on
sumAllSpikes=sum(allspikes ,2);
w=400;
slideTrain=[];
for i=1:length(D(:, 1))/w-1
    ind=[(i-1)*w+1:i*w];
    segmentSum=length(find(sumAllSpikes(ind)));
    spikeRate=segmentSum/(200/fs)/length(D(1, :))*1000;
    slideTrain=[slideTrain; spikeRate];
    fill([w*(i-1), w*i, w*i, w*(i-1)]/fs, [ spikeRate, spikeRate, 0, 0], 'k')
end
xlim([0 length(D(:, 1))/fs])
xlabel('time/s')
ylabel('Hz')
%% spectrogram

    
window=2000;
nOverlap=0;
F=0:2:40;  
fs=20000; 

P=[];
for i=1:length(D(1, :))

    a=D(:, i);
%     figure
%    spectrogram(a, window, nOverlap, F, fs, 'yaxis')
    [s, f, t, p]=spectrogram(a, window, nOverlap, F, fs, 'yaxis');
    P(:, :, i)=p;
end
figure(3)
subplot(121)
mp=mean(P, 3);

surf(t,f,10*log10(abs(mp)), 'EdgeColor','none');
axis tight;
view(0,90);

subplot(122)
plot(F,mean(mp, 2), '*-')
view(0,90);

