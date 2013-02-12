%% Plotting of things

% plot center poke time/travel time against performance
function plotting(action, exptSetup)


color1=    [0.0422    0.4010    0.5957];

color2=    [0.8752    0.0676    0.3399];

%% Performance Plots




subplot(531)
hold on

x1= action.trials;
y1 = action.leftRewardDelay;
x2= action.trials;
y2 = action.rightRewardDelay;
legend1= 'Left';
legend2= 'Right';
smallTitle = 'Reward Delay by Side';
xL = '';
yL = 'Delay/s';
ylimit=2;
plotCurve(x1, y1, x2, y2, legend1, legend2, smallTitle, xL, yL, ylimit, color1, color2)
for i=1:length(action.partition)
    plot([action.partition(i) action.partition(i)], [0 ylimit],'-','Color', [0.5, 0.4, 0.5], 'LineWidth', 1)
end
set(gca, 'FontSize', 8)
hold off

subplot(534)
hold on

x1= action.trials;
y1 = action.leftValveDuration;
x2= action.trials;
y2 = action.rightValveDuration;
legend1= 'Left';
legend2= 'Right';
smallTitle = 'Reward Size by Side';
xL = '';
yL = 'Valve Duration/s';
ylimit = 0.1;
plotCurve(x1, y1, x2, y2, legend1, legend2, smallTitle, xL, yL, ylimit, color1, color2)


for i=1:length(action.partition)
    plot([action.partition(i) action.partition(i)], [0 ylimit],'-','Color', [0.5, 0.4, 0.5], 'LineWidth', 1)
end
set(gca, 'FontSize', 8)
hold off

subplot(537)
hold on

x1= action.trials;
y1 = action.odor1Performance*100;
x2= action.trials;
y2 = action.odor2Performance*100;
legend1= 'Left';
legend2= 'Right';
smallTitle = 'Performance by Side';
xL = '';
yL = '% Correct';
ylimit=100;
plotCurve(x1, y1, x2, y2, legend1, legend2, smallTitle, xL, yL, ylimit, color1, color2)
for i=1:length(action.partition)
    plot([action.partition(i) action.partition(i)], [0 ylimit],'-','Color', [0.5, 0.4, 0.5], 'LineWidth', 1)
end
set(gca, 'FontSize', 8)
hold off


subplot(5, 3, 10)
hold on

x1= action.trials;
y1 = action.freeOdorPreference*100;
y2 = action.timeout*100;
title('preference for left in free choice');
plot(x1, y1, '-', 'Color', color1, 'LineWidth', 1)
%plot(x1, y2, '-', 'Color', color2, 'LineWidth', 1)
set(gca, 'FontSize', 8)
%legend('Free Choice Preference for Left')
% Timeout')
xlabel('Trial No.');
ylabel('% of Trials Choosing Left');
ylimit=100;
ylim([0 ylimit]);
xlim([0 max(x1)])
for i=1:length(action.partition)
    plot([action.partition(i) action.partition(i)], [0 ylimit],'-','Color', [0.5, 0.4, 0.5], 'LineWidth', 1)
end
set(gca, 'FontSize', 8)
hold off



%% Time plots

subplot(538)
hold on

x1=action.trials(find(action.side==2)); 
y1=action.travelTime(find(action.side==2));
x2=action.trials(find(action.side==5)); 
y2=action.travelTime(find(action.side==5));


x1(find(y1>4))=[];
x2(find(y2>4))=[];

y1(find(y1>4))=[];
y2(find(y2>4))=[];


legend2= 'Right Chosen';
smallTitle = 'Travel Time between Center and Side Port';
xL = '';
yL = 'Travel Time/s';
ylimit=2;

plotDots(x1, y1, x2, y2, legend1, legend2, smallTitle, xL, yL, ylimit, color1, color2)
for i=1:length(action.partition)
    plot([action.partition(i) action.partition(i)], [0 ylimit],'-','Color', [0.5, 0.4, 0.5], 'LineWidth', 1)
end
set(gca, 'FontSize', 8)
hold off

subplot(5, 3, 9)
set(gca, 'FontSize', 8)
hold on
plotHist(y1, 0.05, color1)
plotHist(y2, 0.05, color2)
 
title('Histogram of Travel Time between Center and Side Port');









subplot(532)
hold on

x1=action.trials(find(action.side==2)); 
y1=action.cvalid(find(action.side==2));
x2=action.trials(find(action.side==5)); 
y2=action.cvalid(find(action.side==5));
legend1= 'Left Chosen';
legend2= 'Right Chosen';
smallTitle = [exptSetup.mouseID, exptSetup.dateTime 'Center Poke Time'];
xL = '';
yL = 'Center Poke Time/s';
ylimit=2;
plotDots(x1, y1, x2, y2, legend1, legend2, smallTitle, xL, yL, ylimit, color1, color2)
for i=1:length(action.partition)
    plot([action.partition(i) action.partition(i)], [0 ylimit],'-','Color', [0.5, 0.4, 0.5], 'LineWidth', 1)
end
set(gca, 'FontSize', 8)
hold off


subplot(5, 3, 3)

set(gca, 'FontSize', 8)
hold on
plotHist(y1, 0.08, color1)
plotHist(y2, 0.08, color2)
 
title('Histogram of Center Poke Time');





subplot(5, 3, 11)
hold on

x1=action.trials(find(action.score==2)); 
y1=action.travelTime(find(action.score==2));
x2=action.trials(find(action.score==5)); 
y2=action.travelTime(find(action.score==5));


x1(find(y1>4))=[];
x2(find(y2>4))=[];

y1(find(y1>4))=[];
y2(find(y2>4))=[];

legend1= 'Success';
legend2= 'Failure';
smallTitle = 'Travel Time between Center and Side Port';
xL = 'Trial No.';
yL = 'Travel Time/s';
ylimit=2;

plotDots(x1, y1, x2, y2, legend1, legend2, smallTitle, xL, yL, ylimit, color1, color2)
for i=1:length(action.partition)
    plot([action.partition(i) action.partition(i)], [0 ylimit],'-','Color', [0.5, 0.4, 0.5], 'LineWidth', 1)
end
set(gca, 'FontSize', 8)
hold off


subplot(5, 3, 12)
set(gca, 'FontSize', 8)
hold on
plotHist(y1, 0.2, color1)
plotHist(y2, 0.2, color2)
 
title('Histogram of Travel Time between Center and Side Port');
xlabel('Time/s')





subplot(535)

hold on

x1=action.trials(find(action.score==2)); 
y1=action.cvalid(find(action.score==2));
x2=action.trials(find(action.score==5)); 
y2=action.cvalid(find(action.score==5));
legend1= 'Success';
legend2= 'Failure';
smallTitle = 'Center Poke Time';
xL = '';
yL = 'Center Poke Time/s';
ylimit=2;
plotDots(x1, y1, x2, y2, legend1, legend2, smallTitle, xL, yL, ylimit, color1, color2)
for i=1:length(action.partition)
    plot([action.partition(i) action.partition(i)], [0 ylimit],'-','Color', [0.5, 0.4, 0.5], 'LineWidth', 1)
end
set(gca, 'FontSize', 8)
hold off


subplot(5, 3, 6)

set(gca, 'FontSize', 8)
hold on
plotHist(y1, 0.08, color1)
plotHist(y2, 0.08, color2)
 
title('Histogram of Center Poke Time');




%% bar graphs

leftLong=find(action.leftRewardDelay>action.rightRewardDelay);
rightLong=find(action.leftRewardDelay<action.rightRewardDelay);
leftBig=find(action.leftValveDuration>action.rightValveDuration);
rightBig=find(action.leftValveDuration<action.rightValveDuration);



subplot(5,3,13)

try

perfLong=(length(find(action.results(leftLong)==3))+length(find(action.results(rightLong)==2)))/(length(find(action.validOdors(leftLong)==1))+length(find(action.validOdors(rightLong)==0)));
perfShort=(length(find(action.results(leftLong)==2))+length(find(action.results(rightLong)==3)))/(length(find(action.validOdors(leftLong)==0))+length(find(action.validOdors(rightLong)==1)));



perfBig=(length(find(action.results(leftBig)==3))+length(find(action.results(rightBig)==2)))/(length(find(action.validOdors(leftBig)==1))+length(find(action.validOdors(rightBig)==0)));
perfSmall=(length(find(action.results(leftBig)==2))+length(find(action.results(rightBig)==3)))/(length(find(action.validOdors(leftBig)==0))+length(find(action.validOdors(rightBig)==1)));






% leftPerfLeftLong=length(find(action.results(leftLong)==3))./length(find(action.validOdors(leftLong)==1));
% rightPerfLeftLong=length(find(action.results(leftLong)==2))./length(find(action.validOdors(leftLong)==0));
% 
% leftPerfRightLong=length(find(action.results(rightLong)==3))./length(find(action.validOdors(rightLong)==1));
% rightPerfRightLong=length(find(action.results(rightLong)==2))./length(find(action.validOdors(rightLong)==0));

% leftPerfLeftBig=length(find(action.results(leftBig)==3))./length(find(action.validOdors(leftBig)==1));
% rightPerfLeftBig=length(find(action.results(leftBig)==2))./length(find(action.validOdors(leftBig)==0));
% 
% leftPerfRightBig=length(find(action.results(rightBig)==3))./length(find(action.validOdors(rightBig)==1));
% rightPerfRightBig=length(find(action.results(rightBig)==2))./length(find(action.validOdors(rightBig)==0));
% 


bar([perfShort, perfLong,perfBig, perfSmall])
ylim([0 1])
title('Performance for short, long, big, small trials')
catch ME
end



subplot(5, 3, 15)
reactionLong=[action.travelTime(leftLong).*action.left(leftLong);action.travelTime(rightLong).*action.right(rightLong)];
reactionShort=[action.travelTime(leftLong).*action.right(leftLong);action.travelTime(rightLong).*action.left(rightLong)];
reactionBig=[action.travelTime(leftBig).*action.left(leftBig);action.travelTime(rightBig).*action.right(rightBig)];
reactionSmall=[action.travelTime(leftBig).*action.right(leftBig);action.travelTime(rightBig).*action.left(rightBig)];

reactionLong= mean(reactionLong(find(reactionLong)));
reactionShort= mean(reactionShort(find(reactionShort)));
reactionBig= mean(reactionBig(find(reactionBig)));
reactionSmall= mean(reactionSmall(find(reactionSmall)));





bar([reactionShort, reactionLong, reactionBig, reactionSmall])

subplot(5, 3, 14)
try

freeLong=(length(find(action.sidedOdor(leftLong)==4))+length(find(action.sidedOdor(rightLong)==7)))/(length(find(action.validOdors(leftLong)==2))+length(find(action.validOdors(rightLong)==2)));
freeShort=(length(find(action.sidedOdor(leftLong)==7))+length(find(action.sidedOdor(rightLong)==4)))/(length(find(action.validOdors(leftLong)==2))+length(find(action.validOdors(rightLong)==2)));

freeBig=(length(find(action.sidedOdor(leftBig)==4))+length(find(action.sidedOdor(rightBig)==7)))/(length(find(action.validOdors(leftBig)==2))+length(find(action.validOdors(rightBig)==2)));
freeSmall=(length(find(action.sidedOdor(leftBig)==7))+length(find(action.sidedOdor(rightBig)==4)))/(length(find(action.validOdors(leftBig)==2))+length(find(action.validOdors(rightBig)==2)));



bar([freeShort, freeLong, freeBig, freeSmall])
ylim([0 1])

title('Preference for the side that is short, long, big, small')
catch ME
end




end




% Plot preferences around the partition
% if length(action.partition) >0
%     ardParTrialPref=[];
%     meanArdParTrialPref=[];
%     for i=1:length(action.partition)
%         window=action.partition(i)-9:action.partition(i)+5
%         if window(end)>length(action.side)
%             window(find(length(action.side))+1:end)=[]
%         end
%         meanArdParTrialPref(i)=length(find(action.sidedOdor(window)==4))/length(find(action.results(window)==4))
%     end
% bar(meanArdParTrialPref)
% title('Proportion of Left choices on free trials, 20 trials around switch')





