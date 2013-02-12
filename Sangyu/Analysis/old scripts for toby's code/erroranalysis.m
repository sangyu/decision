% Error and swap la la la

function  erroranalysis(csvpath, n)
cd (csvpath)

folderlist= dir;
% for my data mouseid=folderlist(3).name(11:17)
if length(dir)>2
    
mouseid=folderlist(3).name(11:15)

WSW=[];
CSW=[];

figure (2*n)

subplot(3, 2, 1:4)
hold on
line([0 1], [0 1],'Color',[0.7, 0, 0])
line([0.5 0.5], [0.11 1],'Color',[.8 .8 .8])
line([0 1], [0.5 0.5],'Color',[.8 .8 .8])

text(0.175, 0.08,'Data Point Scale: 100 Valid Responses Total','FontSize', 7, 'Color', [0.3, 0.3, 0.3])
text(0.17, 0.04, 'Labels: Days of Binmix', 'FontWeight', 'bold', 'FontSize', 8, 'Color',[0.3, 0.3, 0.3])
rectangle('Position',[0.115,0.002,0.785,0.108], 'EdgeColor', [0.8, 0.8, 0.8])
xlim([0 1]);
ylim([0 1]);
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
xlabel('Percentage of swap following a wrong response')
ylabel('Percentage of swap following a correct response')



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



% find trials that were mistakes
swap=[];

for swp=1:length(response)-1
    if response(swp)==response(swp+1)
        swap(swp)=0;
    else
        swap(swp)=1;
    end
end
swap = swap';
swap = [0; swap];

swap_after_wrong=swap(find(grade(1:end-1)==0)+1)
swap_after_correct=swap(find(grade(1:end-1))+1)

wrong_swap=length(find(swap_after_wrong))/length(swap_after_wrong)
correct_swap=length(find(swap_after_correct))/length(swap_after_correct)


plot(wrong_swap, correct_swap, 'o',  'MarkerEdgeColor', [1, 0.7, 0.6], 'MarkerFaceColor', [1, 0.8, 0.9])
%going to 1 given correct
%inds1=find(grade);
%oneaccr =length(find(odor(inds1)))/length(odor(inds1));


%going to 0 given correct
%inds0=find(grade==0);
%zeroaccr=length(find(odor(inds0)))/length(odor(inds0));

%output

WSW=[WSW, wrong_swap];
CSW=[CSW, correct_swap]
end
plot(WSW, CSW, '-', 'Color', [1, 0.7, 0.6])
days=[1:length(dir)-2]';

for K = 1:length(WSW)
  text(WSW(K)+0.02, CSW(K)+0.02,num2str(days(K)), 'FontWeight', 'bold', 'FontSize', 9, 'Color', [0.3, 0.3, 0.3])
end


title(mouseid);
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

