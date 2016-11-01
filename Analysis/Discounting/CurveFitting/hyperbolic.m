% close all
markers={'o';'^';'d';'s';'p';'h';'*' };

red=[ 0.85    0.20   0.20];
blue=[ 0.3    0.65    0.8];
orange= [0.9, 0.3,  0];
gray=[.4, .4, .4];
green=[  0.2,  0.65,0.65];
yellow=[1, 0.95, 0.4];
pink= [0.9, 0.3,  0.6];

% close all
for c=3
for test=0:1
if test==0
    if length(resultMatrix(:, 1))>5
    response=(resultMatrix(1:6, 1:length(resultMatrix(1, :))/2));
    response=(resultMatrix(1:6, [c]));
    else
    response=(resultMatrix(1:6, 1:length(resultMatrix(1, :))));
    end
else
    response=(resultMatrix(7:12, 1:length(resultMatrix(1, :))/2));
    response=(resultMatrix(7:12, [c]));

end
% DL=[0; 2; 4; 6; 8; 10];
DL=[0; 2; 4; 8; 14; 20];
DSl=[0; 2; 8];
DS=DSl(c);
vs=@(ds, k) (1/(1+k*ds));
vl=@(dl, k) (2/(1+k*dl));
pCl=@(dl, ds, k, b) (exp(b*vl(dl, k))/(exp(b*vl(dl, k))+exp(b*vs(ds, k))));
k=[0:.01:5];
b=[-5:.2:5];
totalSquares=[];
for beta=1:length(b)
    for i=1:length(k)
                E=[];
        for column=1:length(DS)
            for j=1:length(DL)
                ds=DS(column);
                error=(pCl(DL(j),DS(column), k(i), b(beta))-response(j, column))^2;
                E(j, column)=error;
            end
            totalSquares(i, beta)=sum(sum(E));
        end
    end
end
% plot(totalSquares);
[LS, I]=min(totalSquares);
[LSh, J]=min(LS);
kH=k(I(J))
bH=b(J)
PCL=[];
delay=0:0.1:DL(end);
for j=1:length(DS)
    for i=1:length(delay)
    PCL(i, j)=pCl(delay(i), DS(j), kH, bH);
    end
end
%
figure (2)
hold on
if test == 0
plot(DL, response, 'ko');
plot(delay, PCL, 'k-')
else
  plot(DL, response, 'go');
plot(delay, PCL, 'g-')  
end
for j=1:length(DS)
    for i=1:length(DL)
    y_hat(i, j)=pCl(DL(i), DS(j), kH, bH);
    end
end
%
y_mean=mean(mean(response));
Rsquare=sum(sum((y_hat-y_mean).^2))./sum(sum((response-y_mean).^2))

end
end