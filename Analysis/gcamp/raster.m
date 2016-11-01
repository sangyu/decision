



styling;



% %%
ttlfilename = uigetfile('*.*', 'Pick CSV file for TTL');
ttlData = csvread(ttlfilename);

tracefilename = uigetfile('*.*', 'Pick CSV file for Trace');
traceData = csvread(tracefilename);



trace=traceData(:, 2);
traceBackground=traceData(:, 3);
trace=trace-traceBackground;
traceTime=traceData(:, 1);
ttlTime=ttlData(:, 1);
ttl=ttlData(:, 2);

fs=20; 
ttlfs=1000; 
expectedTTLWidth=1;
scalefactor=3;

%%



ttlInd=find(diff(ttl)==1)+1;
spuriousInd=find(diff(ttlInd)<ttlfs/10);
spuriousTTL=ttlInd(spuriousInd);
ttlInd(spuriousInd)=[];
ttlStartTime=ttlTime(ttlInd);
% %%
before=10;
after=10;
% %%
% allTraceMatrix=zeros(length(ttlInd), fs*(before+after)+1)
allSegmentCenters=[];
allTraceMatrix=[];


f10001=figure(10001)
set(f10001, 'Position', [100, 100, 1000, 700])

    subplot(4, 1, 1)
hold on
plot(traceTime, trace, 'Color', gray)
plot(ttlTime, ttl*range(trace)/scalefactor,'Color',  blue)
for i=1:length(spuriousTTL)
    plot([ttlTime(spuriousTTL(i)), ttlTime(spuriousTTL(i))], [0 range(trace)/scalefactor*5], 'r')
end
ylim([min(trace), max(trace)])
xlim([0, traceTime(end)])

    subplot(4, 1, 2:3)

hold on
for i=1:length(ttlInd)
%     for i=1
   traceSegmentInd=intersect(find(traceTime>ttlTime(ttlInd(i))-before), find(traceTime<ttlTime((ttlInd(i)))+after));
   segmentCenter=find(abs(traceTime(traceSegmentInd)-ttlTime(ttlInd(i)))==min(abs(traceTime(traceSegmentInd)-ttlTime(ttlInd(i)))))
   segmentCenterInd=traceSegmentInd(segmentCenter);
   traceTimeSegment=traceTime(traceSegmentInd)-traceTime(segmentCenterInd);
   traceSegment=trace(traceSegmentInd);
   plot(traceTimeSegment, traceSegment+i*range(trace)/scalefactor , 'Color', multipleColors(1+mod(i, length(multipleColors(:, 1))), :));
   allTraceMatrix(i, traceSegmentInd'-segmentCenterInd+fs*before+1)=traceSegment';
   allSegmentCenters(i)=segmentCenter;
end

fill1=fill([0, 0, 0.100, 0.100], [0 (i+1)*range(trace)/scalefactor, (i+1)*range(trace)/scalefactor, 0], orange);
set(fill1, 'EdgeColor', 'none')
alpha(0.5)
ylim([0 (i+1)*range(trace)/scalefactor]);

    ylabel('trials')
    xlabel('Time from center poke TTL (s)')
%     set(gca,'YTick',[1:length(ttlInd)*range(trace)/3])
%     set(gca,'YTickLabel',length(ttlInd)-[1:length(ttlInd)]+1)


    subplot(4,1,4)
    hold on
%     plot([-before:1/fs:after], mean(allTraceMatrix), 'k')
    b1=boundedline([-before:1/fs:after], mean(allTraceMatrix), std(allTraceMatrix)/sqrt(length(allTraceMatrix(:, 1))), '-k');
    fill2=fill([0, 0, 0.100, 0.100], [-range(trace), range(trace),  range(trace), -range(trace)], orange);
    set(fill2, 'EdgeColor', 'none')
    alpha(0.5)
    ylim([-range(trace)/scalefactor*0.8, range(trace)/scalefactor*1.5]);
%%
y=trace
t=traceTime
[pks,locs] = findpeaks(y)
th=mean(y)+2*std(y);
thInd=find(y(locs)>th);

figure
subplot(3, 1, 1:2)
plot(t, y, 'k')
hold on
plot(t(locs(thInd)), pks(thInd), 'r.')
plot(t, ones(length(t), 1)*th, 'b')
subplot(3, 1, 3)
plot(t(locs(thInd)), ones(length(thInd)), 'k.')