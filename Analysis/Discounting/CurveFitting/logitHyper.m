
response=[0.8636    1.0000    1.0000
    0.6667    0.7619    0.7727
    0.3200    0.5200    0.8000
    0.1304    0.3333    0.6000
    0.0345    0.2174    0.4286
    0.0385    0.0400    0.3889]
DL=[[0; 2; 4; 8; 14; 20]];

vs=@(ds, k) (1/(1+k*ds));
vl=@(dl, k) (2/(1+k*dl));

k=[0:.01:2];
totalSquares=[];
for i=1:length(k)
    E=[];
    for j=1:length(DL)
        ds=0;
        error=(pCl(DL(j),0, k(i))-response(j, 1))^2;
        E(j)=error;
    end
    totalSquares(i)=sum(E);
end
plot(totalSquares);
[LS, I]=min(totalSquares);
kH=k(I);
PCL=[];
for i=1:length(DL)
    PCL(i)=pCl(DL(i), 0, kH);
end
%%
figure (2)
hold on
plot(DL, response(:,2), 'o');
plot(DL, PCL, '-')
