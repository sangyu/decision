%% PCA on waveforms
Filename='TT6.ntt';



FieldSelection(1) = 1;
FieldSelection(2) = 1;
FieldSelection(3) = 1;
FieldSelection(4) = 1;
FieldSelection(5) = 1;
ExtractHeader = 1;
ExtractMode = 1;
ModeArray=[]; %all.
[TimeStamps, ScNumbers, CellNumbers, Params, DataPoints,header] = Nlx2MatSpike_v3( Filename, FieldSelection, ExtractHeader, ExtractMode, ModeArray );
N=length(DataPoints(1, 1, :));

which Nlx2MatSpike_v3
spikes=squeeze(DataPoints(:,1,1:N));
spikes2=squeeze(DataPoints(:,2,1:N));
spikes3=squeeze(DataPoints(:,3,1:N));
spikes4=squeeze(DataPoints(:,4,1:N));

%%
% [coeff1, score1, lambda1]=princomp(spikes');
% [coeff2, score2, lambda2]=princomp(spikes2');
% [coeff3, score3, lambda3]=princomp(spikes3');
% [coeff4, score4, lambda4]=princomp(spikes4');
% pc1=score1(:,1);
% pc2=score3(:,1);
% figure
% plot(pc1, pc2, 'r.', 'MarkerSize', 4.5)
% xlabel('pc1');
% ylabel('pc2');
% %%
% 
% a1=find(-4<pc1<0);
% d1=squeeze(DataPoints(:, 1, a1));
% 
% a2=find(2<pc1<4);
% d2=squeeze(DataPoints(:, 1, a2));
% 
% figure
% subplot(121)
% hold on
% plot(d1, 'Color', [.9, .7 , .8])
% plot(mean(d1, 2), 'Color', [.7, 0, 0], 'LineWidth', 2)
% subplot(122)
% hold on
% plot(d2, 'Color', [.9, .7 , .8])
% plot(mean(d2, 2), 'Color', [.7, 0, 0], 'LineWidth', 2)
% 
% 


%%
clusterInd=zeros(1,length(TS));
for i=1:length(TS)
clusterInd(i)=find(TimeStamps==TS(i)*100);
end
waveforms=spikes4(:, clusterInd);
figure
hold on
plot(waveforms, 'Color', [.8, .8, .8]);
plot(mean(waveforms, 2), 'LineWidth', 2, 'Color', [1, .2, .5]);
%  ylim([min(mean(waveforms))-500, max(mean(waveforms))+500])