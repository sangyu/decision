function [exptSetup, action, summary]=runLatest(datapath)
%clear;
close all;

cd (datapath)
folderlist=dir;

% get rid of existing or /fig

for i=3:length(dir)
    switch(folderlist(i).name(1:3))
        case{'.DS'}
        delete ('.DS_Store');
        case{'Box'}
        movefile([datapath '/' folderlist(i).name], [datapath '/' num2str(i-2) '.csv'])
        
    end
end

folderlist=dir;
for i=3:length(dir) 
    if length(folderlist(i).name)==5
        movefile([datapath '/' folderlist(i).name], [datapath '/0' num2str(i-2) '.csv'])
    end
end

% make a folder for pictures


[exptSetup, action, summary]=summarizeData;
exptSetup(end).mouseID
% save( ['mat/' exptSetup(end).mouseID,' ' exptSetup(end).dateTime 'structures'], 'action', 'summary', 'exptSetup');

save( ['mat/' exptSetup(end).mouseID,' ' exptSetup(end).dateTime 'structures'], 'action', 'summary', 'exptSetup');
save( ['/Users/xusangyu/Tonegawa/data/Behaviour/Analysis/summaryData/' date '_mat', '/', exptSetup(end).mouseID,'_',exptSetup(end).dateTime 'structures'], 'action', 'summary', 'exptSetup')



end