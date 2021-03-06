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
function [scheduleData, nextTrialNumber] = sampleAdaptiveFunction(scheduleData, currentTrialNumber, lastResult)

%Increment the trial number.
nextTrialNumber = currentTrialNumber + 1;
%Switch the left/right values the animal was correct.
while scheduleData.leftRewardDelay(nextTrialNumber)<7 && scheduleData.leftRewardDelay(nextTrialNumber)>0.5
    if lastResult ==1
        scheduleData.leftRewardDelay(nextTrialNumber)= scheduleData.leftRewardDelay(nextTrialNumber)+ 0.5;
    elseif scheduleData.left(currentTrialNumber)==1
        scheduleData.leftRewardDelay(nextTrialNumber)= scheduleData.leftRewardDelay(nextTrialNumber)- 0.5;
    end
end

while scheduleData.rightRewardDelay(nextTrialNumber)<7 && scheduleData.rightRewardDelay(nextTrialNumber)>0.5
    if lastResult ==2
        scheduleData.rightRewardDelay(nextTrialNumber)= scheduleData.rightRewardDelay(nextTrialNumber)+ 0.5; 
    elseif scheduleData.right(currentTrialNumber)==1
        scheduleData.rightRewardDelay(nextTrialNumber)= scheduleData.rightRewardDelay(nextTrialNumber)- 0.5;
    end
end

return;