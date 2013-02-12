% loads the data for user defined mice into workspace, collate the .csv files and process the parameters accordingly with various functions

% grabcsv

clear
addpath ('/Users/xusangyu/Tonegawa/OlfSVN/Decision Making/Branches/Sangyu/Analysis/binmix')


%ask for directory
path=input('data path?', 's')
cd (path)
folderlist=dir;

% get rid of existing /csv or /png

for i=3:length(dir)
    if strcmp(folderlist(i).name(1:3), 'csv')==1
        rmdir ('csv', 's')
    elseif strcmp(folderlist(i).name(1:3), 'png'==1)
        rmdir ('png', 's');
    end
end

batchid=path(end-5:end)

mkdir([path '/csv' ]);
mkdir([path '/png']);
folderlist= dir;

% find all csv files to put into csv folders
for i=1:length(dir)
    filename=folderlist(i).name
    if filename(1)=='d'
        cd (filename);
        Processing = filename
            mouseid=filename(11:end-14);
            mkdir ([path '/csv/' mouseid '_csv'])
        dirList = dir;
        for j=3:length(dirList)
            if dirList(j).name(end-2 : end)=='csv'
                copyfile(dirList(j).name,[path '/csv/' mouseid '_csv'])
            end
        end
    cd ..
    end
end

% process each collated folders of csv files for each mouse with scoring functions. 
cd([path '/csv' ]);

folderlist=dir;
for n=3:length(dir)
    mouseid=folderlist(n).name(1:end-4);
    csvpath = ([path '/csv/' mouseid '_csv'])
    [ACCR ACCR1 ACCR0]=scoreanalysis(csvpath, n);
    saveas(figure(n), [mouseid '_Accuracy.png']) 
    movefile([mouseid '_Accuracy.png'] , ['../../png/' mouseid '.png'])
    erroranalysis(csvpath, n);
    saveas(figure(2*n), [mouseid '_ErrorSwap.png']) 
    movefile([mouseid '_ErrorSwap.png'] , ['../../png/' mouseid '_ErrorSwap.png'])

    cd ..
end


