% sampleAdaptiveFunction - A simple example of an adaptive function (which will modify the behavior schedule in response to performance).
%
%SYNTAX
% [scheduleData, nextTrialNumber] = sampleAdaptiveFunction(scheduleData, currentTrialNumber, lastResult)
%   scheduleData - The schedule structure (as created by another, selectable, m-file).
%   currentTrialNumber - The number of the trial that has just been completed.
%   lastResult - The result of the most recently completed trial.
%    leftCorrect:    1
%    rightCorrect:   2
%    dualCorrect:    3
%    noGoCorrect:    4
%    timeOut:        0
%    goIncorrect:   -1
%    noGoIncorrect: -2
%    abort:         -3
%   nextTrialNumber - The output of this function, which determines the next trial number.
%
% NOTES
%  With the exception of the 'timeOut' result, the adaptive function will only get called if the schedule dictates
%  that the trialNumber should be incremented. For example, if `incrementOnAbort` is not set, the adaptive function
%  will not be executed when an abort occurs.
%
% Created - Timothy O'Connor 11/1/10
% Copyright - Massachussetts Institute of Technology/Picower Institute For Learning & Memory 2010
function [scheduleData, nextTrialNumber] = variableDelay10(scheduleData, currentTrialNumber, lastResult)
increment=0.25;
%Increment the trial number.
nextTrialNumber = currentTrialNumber + 1;
%Switch the left/right values the animal was correct.
if schduleData.LR==0
    if scheduleData.leftRewardDelay(nextTrialNumber)<10-increment && scheduleData.leftRewardDelay(nextTrialNumber)>increment;
        if lastResult ==1
            scheduleData.leftRewardDelay(nextTrialNumber:end)= scheduleData.leftRewardDelay(currentTrialNumber)+ increment;
        elseif lastResult==2
            scheduleData.leftRewardDelay(nextTrialNumber:end)= scheduleData.leftRewardDelay(currentTrialNumber)-increment;
        end 
    end
else
    if scheduleData.rightRewardDelay(nextTrialNumber)<10-increment && scheduleData.rightRewardDelay(nextTrialNumber)>increment
        if lastResult ==2
            scheduleData.rightRewardDelay(nextTrialNumber)= scheduleData.rightRewardDelay(nextTrialNumber)+ increment; 
        elseif lastResult==1
            scheduleData.rightRewardDelay(nextTrialNumber)= scheduleData.rightRewardDelay(nextTrialNumber)- increment;
        end
    end
end
return;