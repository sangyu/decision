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
function [scheduleData, nextTrialNumber] = variableDelay15(scheduleData, currentTrialNumber, lastResult)
increment=.5;
lower=scheduleData.bigDelay;
upper=12;
responsivity=0.2;
%Increment the trial number.
nextTrialNumber = currentTrialNumber + 1;
%Switch the left/right values the animal was correct.
if scheduleData.LR==0
    if lastResult ==1
       if scheduleData.leftRewardDelay(nextTrialNumber)<upper && rand<responsivity
            scheduleData.leftRewardDelay(nextTrialNumber:end, 1)= scheduleData.leftRewardDelay(currentTrialNumber, 1)+ increment;
       end
    elseif lastResult==2       
       if scheduleData.leftRewardDelay(nextTrialNumber)>lower && rand<responsivity
            scheduleData.leftRewardDelay(nextTrialNumber:end, 1)= scheduleData.leftRewardDelay(currentTrialNumber, 1)- increment;
       end 
    end
       scheduleData.trialDuration(nextTrialNumber:end, 1)= scheduleData.leftRewardDelay(nextTrialNumber, 1)+4;
   scheduleData.rewardAvailableInterval(nextTrialNumber:end, 1)=scheduleData.trialDuration(nextTrialNumber:end, 1);
   
else
   if lastResult ==2
       if scheduleData.rightRewardDelay(nextTrialNumber)<upper && rand<responsivity
            scheduleData.rightRewardDelay(nextTrialNumber:end, 1)= scheduleData.rightRewardDelay(currentTrialNumber, 1)+ increment;
       end
    elseif lastResult==1       
       if scheduleData.rightRewardDelay(nextTrialNumber)>lower && rand<responsivity
            scheduleData.rightRewardDelay(nextTrialNumber:end, 1)= scheduleData.rightRewardDelay(currentTrialNumber, 1)- increment;
       end 
   
   
   scheduleData.trialDuration(nextTrialNumber:end, 1)= scheduleData.rightRewardDelay(nextTrialNumber, 1)+4;
   scheduleData.rewardAvailableInterval(nextTrialNumber:end, 1)=scheduleData.trialDuration(nextTrialNumber:end, 1);
   end
end