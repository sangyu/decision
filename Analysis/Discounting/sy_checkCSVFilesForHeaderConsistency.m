function sy_checkCSVFilesForHeaderConsistency(varargin)

currentDir = pwd;
if ~isempty(varargin)
    cd(varargin{1});
end

directories = dir;
directories = directories([directories(:).isdir]);
for i = 1 : length(directories)
    if ~strcmpi(directories(i).name, '..') && ...
            ~strcmpi(directories(i).name, '.') && ...
            directories(i).name(1) ~= '.'
        eh_checkCSVFilesForHeaderConsistency(directories(i).name);
    end
end

files = dir('*.csv');
lastTrial = '';
%indices = regexpi({files(:).name}, '^[EHYJ]+_\d+_\d_+-\d+-\d+_\d+-\d+-\d+.csv');

for i = 1 : length(files)
    if ~strcmpi(files(i).name(1:3), 'EH_') && ~strcmpi(files(i).name(1:3), 'HY_') && ...
         ~strcmpi(files(i).name(1:3), 'SY_') && ~strcmpi(files(i).name(1:5), 'KEAN_')
        %fprintf(1, ' Skipping ''%s''...\n', fullfile(pwd, files(i).name));
        continue;
    end
    
    f = fopen(files(i).name, 'r');
    fprintf(1, '\n%s\n', fullfile(pwd, files(i).name));
    line = fgetl(f);
    fprintf(line)
    lineNumber = 1;
    fileBorked = 0;
    while all(line ~= -1)
        if isempty(line)
            line = fgetl(f);
            lineNumber = lineNumber + 1;
            continue;
        end
        if strfind(line, '#.soundFiles: ')
            eval(['soundFiles = ' line(14:end) ';']);
        end
        if strfind(line, '#.sounds:')
            eval(['sounds = ' line(10:end) ';']);
        end
        if strfind(line, '#.odor1Flow:');
            eval(['odor1Flow = ' line(13:end) ';']);
            odor1Flow=round(odor1Flow);
        end
        if strfind(line, '#.odor2Flow:');
            eval(['odor2Flow = ' line(13:end) ';']);
            odor2Flow=round(odor2Flow);
        end
        valve1Index = strfind(line, 'Odor1: v1@');
        valve2Index = strfind(line, 'Odor2: v6@');
        mlIndex=strfind(line, 'ml');
        if ~isempty(valve1Index) || ~isempty(valve2Index)
            if isempty(valve1Index)
                odor1 = NaN;
            else
                odor1 = round(str2double(line(valve1Index+10 : mlIndex(1)-1)));
            end
            if isempty(valve2Index)
                odor2 = NaN;
            else
                odor2 = round(str2double(line(valve2Index + 10 : mlIndex(2)-1)));
            end
            trialNum = getTrialNumber(line);
% fprintf(1, '\t@%s - %s: odor1:%s, odor2:%s - "%s"\n', num2str(lineNumber), num2str(trialNum), ...
%                     num2str(odor1Valve(trialNum)), num2str(odor2Valve(trialNum)), line);
            if (~isnan(odor1) && odor1 ~= odor1Flow(trialNum)) || ...
                    (~isnan(odor2) && odor2 ~= odor2Flow(trialNum))
                fprintf(2, ' @%s - %s: odor1Flow:%s, odor2Flow:%s - "%s"\n', num2str(lineNumber), num2str(trialNum), ...
                    num2str(odor1Flow(trialNum)), num2str(odor2Flow(trialNum)), line);
            end
        end

        if ~isempty(strfind(line, 'sounds: ')) && line(1) ~= '#'
            [trialNum, index4] = getTrialNumber(line);
            if strcmpi(soundFiles{sounds(trialNum)}, line(index4 + 1 : end))
                fprintf(2, ' %s: %s - %s\n', num2str(trialNum), soundFiles{sounds(trialNum)}, line);
            end
        end

        line = fgetl(f);
        lineNumber = lineNumber + 1;
    end
    fclose(f);
    
%     if fileBorked
%         fprintf(2, '%s: %s\n', num2str(fileBorked), fullfile(pwd, files(i).name));
%         fprintf(1, 'Deleting ''%s''...\n', files(i).name);
%         delete(files(i).name);
%     else
%         fprintf(1, '%s\n', fullfile(pwd, files(i).name));
%     end
end

cd(currentDir);

return;

%--------------------------------------------------------------------------
function [trialNum, index4] = getTrialNumber(line)

indices = find(line == ',');
if length(indices) < 4
    indices(end + 1) = length(line) + 1;
end
trialNum = str2double(line(indices(3)+1 : indices(4)-1));
index4 = indices(4);

return;