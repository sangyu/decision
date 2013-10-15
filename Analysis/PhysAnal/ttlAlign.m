%phys align

[timestamps, ttls] = extractTTLsAndTimestampsFromNEVfile('Events.nev');
s=dec2bin(ttls);
chs=[];
for i=1:length(s(:, 1))
    chs(i)=25-log10(str2num(s(i, :)));
end
%%

filename = 'TT10_1.txt';
delimiter = ' ';
formatSpec = '%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
spiketime = dataArray{:, 1};
clearvars filename delimiter formatSpec fileID dataArray ans;