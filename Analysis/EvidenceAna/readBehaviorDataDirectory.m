% read directory and spit out list of behavior files

function [info, D]=readBehaviorDataDirectory
D = dir;
info=zeros(length(D), 3);
for i=3:length(D)
    info(i, 1)=str2num(D(i).name(4:6));
    info(i, 2)=datenum(D(i).name(8:15), 'dd-mm-yy');
end

info(1:2, :)=[];
info(:, 2)=info(:, 2)-min(info(:, 2))+1;
info(:, 3)=[1:length(info(:, 1))];

[info(:, 2), I]=sort(info(:, 2));
info(:, 2)=round(info(:, 2));
info(:, 1)=info(I, 1);
info(:, 3)=info(I, 3);

fprintf(['\n', '  mouse   ', 'day  ', 'fileLocation \n']);
disp(info)
return
