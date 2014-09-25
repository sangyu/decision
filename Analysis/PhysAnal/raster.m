%% raster plot
sampling=32000;
numberSpikes=length(TS);
time=(TS(end)-TS(1))/sampling*1000;
timestamps=[TS-TS(1)]/sampling;
plot(timestamps, 1, 'r.')