%% findPeaks
% takes a column of numbers a and finds the maximum of an area that exceeds
% threshold th, returns the index

function [ind]=findPeaks(a, lowerTh, upperTh, posNeg)

%%

if posNeg==1
h=1*max(a);
betweenTh=[intersect(find(a<=h*upperTh), find(a>=h*lowerTh)); length(a)];
overTh=[find(a>h*upperTh); length(a)];
else
h=min(a);
betweenTh=[intersect(find(a>=h*upperTh), find(a<=h*lowerTh)); length(a)];
overTh=[find(a<h*upperTh); length(a)];
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
