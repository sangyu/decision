% analysis scripts
function [exptSetup, action, summary]=runAllFolders(datapath)
%clear;
% close all;
cd (datapath)
folderlist=dir;

% get rid of existing or /fig

for i=3:length(dir)
    switch(folderlist(i).name(1:3))
        
        case{'fig'}
        rmdir ('fig', 's');
        case{'mat'}
        rmdir ('mat', 's');
        case{'.DS'}
        delete ('.DS_Store');
        case{'Box'}
        movefile([datapath '/' folderlist(i).name], [datapath '/' num2str(i-2) '.csv'])
        
    end
end

folderlist=dir;
for i=3:length(dir) 
    if length(folderlist(i).name)==5
        movefile([datapath '/' folderlist(i).name], [datapath  '/0' num2str(i-2) '.csv'])
    end
end

% make a folder for pictures

mkdir([datapath '/fig']);
mkdir([datapath '/mat']);
folderlist=dir;

% [EXPTSETUP, ACTION, SUMMARY]=SUMMARIZEDATA;
for n=1:length(folderlist)-2
    if length(folderlist(n+2).name)>3
    filename=folderlist(n+2).name
%     try
    [exptSetup(n), action(n)]=extractOlfData(filename)
%     catch me
%     end
    end
end

%%
summary=struct;
e=fieldnames(exptSetup);
a=fieldnames(action);
    for i=3:length(e)-2
        value=[];
        for j=1:length(exptSetup)
            try
            validT=action(j).validTrialNo;
            value=[value; exptSetup(j).(e{i})(1:validT, :)];
            catch
            end
        end
        summary= setfield(summary, e{i}, value);
    end
    for i=1:length(a)
        value=[];
        for j=1:length(action)
            value=[value; action(j).(a{i})];         
        end
            summary=setfield(summary, a{i}, value);        
    end
    
    
    
    
    cum=action(1).validTrials;
    for j=2:length(action)
        a=[];
        for n=1:j-1
            a=[a; action(n).validTrialNo];
        end
            cum=[cum; action(j).validTrials+sum(a)];
    end
    summary=setfield(summary, 'cumValidTrials', cum);      
    
  
end





