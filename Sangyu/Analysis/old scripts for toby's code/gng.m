% Analysis Script for Go/No Go
function [ACCR, ACCR1, ACCR0] = binmixanalysis(csvpath, n)
cd (csvpath)

folderlist= dir;
% for my data mouseid=folderlist(3).name(11:17)
if length(dir)>2
    
mouseid=folderlist(3).name(11:15)
ACCR=[];
ACCR1=[];
ACCR0=[];


figure (n)

subplot(3, 2, 1:4)
hold on
line([0 1], [0 1],'Color',[0.7, 0, 0])
line([0.5 0.5], [0.11 1],'Color',[.8 .8 .8])
line([0 1], [0.5 0.5],'Color',[.8 .8 .8])
plot(0.15, 0.08, 'o-', 'MarkerSize', sqrt(100), 'MarkerEdgeColor', [0.7, 0.7, 0.7], 'MarkerFaceColor', [0.9, 0.9, 0.9])
text(0.175, 0.08,'Data Point Scale: 100 Valid Responses Total','FontSize', 7, 'Color', [0.3, 0.3, 0.3])
text(0.17, 0.04, 'Labels: Days of Binmix', 'FontWeight', 'bold', 'FontSize', 8, 'Color',[0.3, 0.3, 0.3])
rectangle('Position',[0.115,0.002,0.785,0.108], 'EdgeColor', [0.8, 0.8, 0.8])
xlim([0 1]);
ylim([0 1]);
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
xlabel('Percentage of correct choices when stimulus is A')
ylabel('Percentage of correct choices when stimulus is B')



for i=3:length(dir)

    Processing = folderlist(i).name 
    load (folderlist(i).name)

%define valid and invalid(timeout) trials

alltrials=eval(folderlist(i).name(1:end-4));
validtrials=alltrials;
timeouttrialind=find(alltrials(:, 3)== 0.5);

timeouttrials=alltrials(timeouttrialind,:);
validtrials(timeouttrialind,:)=[];

%of the valid trials, label columns
trial=validtrials(:,1);
odor=validtrials(:,2);
response=validtrials(:,3);
duration=validtrials(:,4);
time=validtrials(:,5);
trialno=length(response)

%compute the accuracy of choices

grade=zeros(0, trialno);

    for n=1: trialno
        if response(n)==odor(n)
        grade(n)=1;
        else
        grade(n)=0;
        end
    end
grade=grade';

%accuracy overall
accuracy = length(find(grade))/length(grade);

%accuracy given odor 1
inda1=find(odor);
accr_1=length(find(grade(inda1)))/length(grade(inda1));

%accuracy given odor 0
inda0=find(odor==0);
accr_0=length(find(grade(inda0)))/length(grade(inda0));
plot(accr_1, accr_0, 'o', 'MarkerSize', sqrt(trialno), 'MarkerEdgeColor', [1, 0.7, 0.6], 'MarkerFaceColor', [1, 0.8, 0.9])


ACCR=[ACCR, accuracy]
ACCR1=[ACCR1, accr_1]
ACCR0=[ACCR0, accr_0]

end


%going to 1 given correct
%inds1=find(grade);
%oneaccr =length(find(odor(inds1)))/length(odor(inds1));


%going to 0 given correct
%inds0=find(grade==0);
%zeroaccr=length(find(odor(inds0)))/length(odor(inds0));

%output

scenario =char ('overall accuracy', 'P(accurate choice|stimulus=1)', 'P(accurate choice|stimulus=0)')%, 'P(stimulus=1|accurate choice)', 'P(stimulus=0|accurate choice)' )
values = [accuracy, ACCR1, ACCR0]%; oneaccr; zeroaccr]




disp(['summary of day for' mouseid]);
for m=1:length(scenario(:,1))
    disp(scenario(m,:)), disp(values(m))
end

plot(ACCR1, ACCR0, '-', 'Color', [1, 0.7, 0.6])
days=[1:length(dir)-2]';

for K = 1:length(ACCR)
  text(ACCR1(K)+0.02, ACCR0(K)+0.02,num2str(days(K)), 'FontWeight', 'bold', 'FontSize', 9, 'Color', [0.3, 0.3, 0.3])
end

title(mouseid);
hold off

subplot(3, 2, 5:6)
hold on
plot (days, ACCR, 'o-','Color', 'm','LineWidth', 2)
plot (days, ACCR1,'o-', 'Color','r')
plot (days, ACCR0,'o-', 'Color','b')
line ([0 K], [0.5 0.5], 'Color','g')
xlim([1 K])
ylim([0 1])
legend ('Overall', 'stimulus 1','stimulus 0', 'Location', 'EastOutside' )
set(gca,'DataAspectRatio',[0.5 0.25 0.5],'PlotBoxAspectRatio',[0.5 0.25 0.5]);
hold off
end



%subplot (1,2,2)
%hold on
%line([0 1], [0 1],'Color','r')
%line([0.5 0.5], [0 1],'Color',[.8 .8 .8])
%line([0 1], [0.5 0.5],'Color',[.8 .8 .8])
%plot(oneaccr, zeroaccr, '*', 'MarkerSize', 10)
%xlim([0 1]);
%ylim([0 1]);
%set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
%xlabel('Probability of stimulus being 1 when mouse chooses correctly ')
%ylabel('Probability of stimulus being 0 when mouse chooses correctly ')

