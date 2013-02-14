
function scheduleData = BinaryMixtureDelayInd6s
scheduleData.LR=0;
scheduleData.bigSize=1;
scheduleData.smallSize=1;

scheduleData.N=300;
unitaryArray = ones(scheduleData.N, 1);


scheduleData.centerPokeDelay = 0.001 * unitaryArray;
scheduleData.cueSamplingTime = 0.3* unitaryArray;
scheduleData.rewardAvailableInterval = 10*unitaryArray;
scheduleData.trialDuration = scheduleData.rewardAvailableInterval;
scheduleData.jitterThreshold = 0.01 * unitaryArray;

scheduleData.leftPokeDelay = 0.1*unitaryArray;
scheduleData.leftValveDuration = 0.03 * unitaryArray;
scheduleData.rightPokeDelay = 0.1*unitaryArray;
scheduleData.rightValveDuration = 0.03 * unitaryArray;

COC2=ceil(rand(size([unitaryArray; unitaryArray]))*4);
COC1=ceil(rand(size([unitaryArray; unitaryArray]))*4);
% C3=COC1-COC2;
% COC1(C3==0)=[];
% COC2(C3==0)=[];
choiceOfCue1=COC1(1:scheduleData.N);
choiceOfCue2=COC2(1:scheduleData.N);

scheduleData.odor1Valve = ones(size(choiceOfCue1));
scheduleData.odor2Valve = 6*ones(size(choiceOfCue2));


scheduleData.left = unitaryArray;
scheduleData.right = unitaryArray;


scheduleData.odor1Flow(choiceOfCue1 == 1) = 60;
scheduleData.odor1Flow(choiceOfCue1 == 2) = 40;
scheduleData.odor1Flow(choiceOfCue1 == 3) = 20;
scheduleData.odor1Flow(choiceOfCue1 == 4) = 0;

scheduleData.odor1Flow=scheduleData.odor1Flow';
scheduleData.leftRewardDelay=scheduleData.odor1Flow/10;



scheduleData.odor2Flow(choiceOfCue2 == 1) = 60;
scheduleData.odor2Flow(choiceOfCue2 == 2) = 40;
scheduleData.odor2Flow(choiceOfCue2 == 3) = 20;
scheduleData.odor2Flow(choiceOfCue2 == 4) = 0;

scheduleData.odor2Flow=scheduleData.odor2Flow';
scheduleData.rightRewardDelay=scheduleData.odor2Flow/10;


scheduleData.delayDiff=scheduleData.leftRewardDelay-scheduleData.rightRewardDelay;

scheduleData.bigRewardMatrix=ones(scheduleData.N,scheduleData.bigSize);
scheduleData.smallRewardMatrix=[ones(scheduleData.N,scheduleData.smallSize), zeros(scheduleData.N, scheduleData.bigSize-scheduleData.smallSize)];
scheduleData.rewardInterval=.2;


if scheduleData.LR==0
    scheduleData.leftValveDuration =.03 *scheduleData.bigRewardMatrix;
    scheduleData.leftRewardDelay= [scheduleData.leftRewardDelay, scheduleData.rewardInterval*scheduleData.bigRewardMatrix(:, 2:end)];
    scheduleData.rightValveDuration =.03 *scheduleData.smallRewardMatrix;
    scheduleData.rightRewardDelay= [scheduleData.rightRewardDelay, scheduleData.rewardInterval*scheduleData.smallRewardMatrix(:, 2:end)];
else
    scheduleData.rightValveDuration =.03 *  scheduleData.bigRewardMatrix;
    scheduleData.rightRewardDelay= [scheduleData.rightRewardDelay, scheduleData.rewardInterval*scheduleData.bigRewardMatrix(:, 2:end)];
    scheduleData.leftValveDuration =.03 *  scheduleData.smallRewardMatrix;
    scheduleData.leftRewardDelay= [scheduleData.leftRewardDelay, scheduleData.rewardInterval*scheduleData.smallRewardMatrix(:, 2:end)];
end    


scheduleData.odorNumber = [];
scheduleData.totalFlow = 1000*unitaryArray;
scheduleData.cueDuration = 4*unitaryArray;

scheduleData.continuousTrialAvailability = 0*unitaryArray;
scheduleData.requirePokeForReward = 1*unitaryArray;
scheduleData.soundFiles = {};%ie. scheduleData.soundFiles = {'C:\sounds\sound1.wav', 'C:\sounds\sound2.wav'};
scheduleData.sounds = [];
scheduleData.incrementTrialOnFailure = 1*unitaryArray;
scheduleData.incrementTrialOnAbort = 0*unitaryArray;
scheduleData.incrementTrialOnTimeout = 1*unitaryArray;
scheduleData.punishmentInterval = 0*unitaryArray;
scheduleData.postTrialDelay = 0*unitaryArray;

for i=1:scheduleData.N
scheduleData.cueLabels{i}=['L- ', num2str(scheduleData.leftRewardDelay(i)), '  ***  R- ', num2str(scheduleData.rightRewardDelay(i))];
end
scheduleData.cueLabelIndex = 1:scheduleData.N;
scheduleData.forceLightsOn = unitaryArray;
scheduleData.forceLightsOffDuringTrialAvailable = unitaryArray;
scheduleData.forceLightsOffDuringCueSampling = unitaryArray;
scheduleData.forceLightsOffAfterCueSampling = 0 * unitaryArray;
scheduleData.forceLightsOffDuringPostTrialDelay = unitaryArray;
scheduleData.forceLightsOffDuringPunishmentInterval = unitaryArray;
return;