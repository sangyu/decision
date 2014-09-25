function sampStim(lastNtrials)
close all
CColor=[.3 .6 .8];
LColor=[0.3 .8 .6];
RColor=[.8 .3 0.6];
delete '.DS_Store';

% Data
allPorts={'C', 'L', 'R'};
C=[0, 0];
L=[0, 0];
R=[0, 0];

D = dir;


% Engine
% S = [D(:).name]; % you may want to eliminate . and .. first.
% [S,S] = sort(S);
% S = {D(S).name}; % Cell array of names in order by datenum.
td=[];

for i=1:length(D)
    if length(D(i).name)<5
        td=[td; i];
    end
    
end
D(td)=[];
        
n=length(D);

for i=1:length(D)
    dates(i)=getfield(D(i), 'datenum');
end

 [y, ind]=sort(dates);
 
 



figure(1)


for i=1:n


    filename=D(ind(i)).name
    i
    [exptSetup, action]=extractOlfDataStim(filename);
        side=action.side;
        
     if length(side)>lastNtrials   
    side=side(end-lastNtrials+1:end, :);
     end
    
lt=action.travelTime(find(side(:, 1)))
rt=action.travelTime(find(side(:, 2)))
figure(1)
subplot(6, n, [i, n+i, 2*n+i])

bar([1 2], [mean(lt), mean(rt)], 'FaceColor', 'none')
hold on
e=errorbar([mean(lt), mean(rt)], [std(lt), std(rt)])
set(e, 'Color','k', 'LineStyle', 'none', 'LineWidth', 1.5)
ylim([0 4])
plot(ones(1, length(lt)), lt, 'o', 'MarkerFaceColor', 'auto')
plot(2*ones(1, length(rt)), rt, 'o', 'MarkerFaceColor', 'auto')
alpha(0.3)

figure(1)
subplot(6, n, [3*n+i, 3*n+i, 5*n+i])
bar(mean(side))
end

