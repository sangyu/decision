%% raster plot
sampling=32556;
numberSpikes=length(TS);
time=(TS(end)-TS(1))/32556*1000;
timestamps=[TS-TS(1)]/32556;
plot(timestamps, 1, 'r.')