function [W]=erp(timestamps, valvestamp, spikes)

win=2000;
window=0;
W=[];
back=.2;
front=.5;
tsus=timestamps(valvestamp);
ts=tsus(find(diff(tsus)>.3)+1)*1000;
spikesMs=spikes*1000;
shootNo=1;
shootFreq=5;
% 
% a=zeros(46, 1);
% for s=1:46
% a(s)=round(rand*(max(ts)-min(ts))+min(ts));
% end
% ts=a;
%%
figure
subplot(3,2,[1,2,3,4])
hold on
for i=1:length(ts)

ind=find(spikesMs> ts(i)-back*win & spikesMs <ts(i)+front*win);
    if spikesMs(ind)-ts(i)~=0
    window=spikesMs(ind)-ts(i);
    else
        window=[];
    end
        W=[W; window];
try
    plot(window, i, 'bv', 'MarkerSize', 5, 'MarkerEdgeColor','b' , 'MarkerFaceColor', [0.4, .7, 0])
catch ME
   
end
alpha(0.5)
ylabel('trial no')
xlim([-back*win, front*win]);

end
 %%
ylim([0 i+2])
for j=1:shootNo
l=line([(j-1)/shootFreq*1000,(j-1)/shootFreq*1000], [0 i+2]);
set(l, 'Color', [.1, 1, .5], 'LineWidth', 3);
end

subplot(3,2, [5:6])

xlim([-back*win, front*win]);
hold on
bins=plotHist(W, 10, 'k', 'k',0);

xlabel('time/ms')
ylim([0 max(bins)+2])

for j=1:shootNo
l2=line([+(j-1)/shootFreq*1000,(j-1)/shootFreq*1000], [0 max(bins)+2]);
set(l2, 'Color', [.1, 1, .5], 'LineWidth', 3);
end
