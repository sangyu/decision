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
function [scheduleData, nextTrialNumber] = variableDelay20_8(scheduleData, currentTrialNumber, lastResult)

%Increment the trial number.
nextTrialNumber = currentTrialNumber + 1;
%Switch the left/right values the animal was correct.
if scheduleData.LR==0
    if lastResult ==1
       if scheduleData.leftRewardDelay(nextTrialNumber)<20
            scheduleData.leftRewardDelay(nextTrialNumber:end)= scheduleData.leftRewardDelay(currentTrialNumber)+ 0.5;
       end
    elseif lastResult==2       
       if scheduleData.leftRewardDelay(nextTrialNumber)>8
            scheduleData.leftRewardDelay(nextTrialNumber:end)= scheduleData.leftRewardDelay(currentTrialNumber)- 0.5;
       end 
    end
else
   if lastResult ==2
       if scheduleData.rightRewardDelay(nextTrialNumber)<20
            scheduleData.rightRewardDelay(nextTrialNumber:end)= scheduleData.rightRewardDelay(currentTrialNumber)+ 0.5;
       end
    elseif lastResult==1       
       if scheduleData.rightRewardDelay(nextTrialNumber)>8
            scheduleData.rightRewardDelay(nextTrialNumber:end)= scheduleData.rightRewardDelay(currentTrialNumber)- 0.5;
       end 
    end
end