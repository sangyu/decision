%% findPeaks
% takes a column of numbers a and finds the maximum of an area that exceeds
% threshold th, returns the index

function [ind, waveforms]=findPeaks(a, lowerTh, upperTh, halfWaveWidth, fs)

%%
posNeg=lowerTh/upperTh>0;
if posNeg==1
betweenTh=[intersect(find(a<=upperTh), find(a>=lowerTh)); length(a)];
overTh=[find(a>upperTh); length(a)];
else
betweenTh=[intersect(find(a>=upperTh), find(a<=lowerTh)); length(a)];
overTh=[find(a<upperTh); length(a)];
end
segmentBorder=[0; find(diff(betweenTh)>1)];
peakInd=[];
for i=1:length(segmentBorder)-1
    seg=betweenTh(segmentBorder(i)+1):betweenTh(segmentBorder(i+1));
    if posNeg==1
    peak=find(a(seg)==max(a(seg)));
    else
    peak=find(a(seg)==min(a(seg)));
    end
    if length(peak)>1
        peak=peak(round(length(peak)/2));
    end
        peakInd=[peakInd; seg(peak)];
end
repeats=find(diff(peakInd)<10);
repeats=[repeats;repeats+1];
peakInd(repeats)=[];
% figure
% plot(a)
% hold on
% plot(peakInd,a(peakInd), 'r.')
% plot([0 length(a)],[h*lowerTh, h*lowerTh],  'g')
% plot([0 length(a)],[h*upperTh, h*upperTh],  'r')
ind=peakInd;
halfWaveWidth=halfWaveWidth/1000;

for i=1:length(ind)

    if ind(i)-halfWaveWidth*fs<0
        waveforms(i, :)=[zeros(1, halfWaveWidth*fs-ind(i)+1), a(1:ind(i)+halfWaveWidth*fs)'];
    elseif ind(i)+halfWaveWidth*fs>length(a)
        waveforms(i, :)=[a(ind(i)+halfWaveWidth*fs: end)', zeros(1, halfWaveWidth*fs+ind(i)-length(a)+1),];
    else
        waveforms(i, :)=a(ind(i)-halfWaveWidth*fs:ind(i)+halfWaveWidth*fs)';
    end
end


return


