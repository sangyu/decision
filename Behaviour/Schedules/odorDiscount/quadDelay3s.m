
function scheduleData = BinaryMixtureDelayInd10s
scheduleData.LR=0;
scheduleData.bigSize=1;
scheduleData.smallSize=1;

scheduleData.N=300;
unitaryArray = ones(scheduleData.N, 1);


scheduleData.centerPokeDelay = 0.001 * unitaryArray;
scheduleData.cueSamplingTime = 0.3* unitaryArray;
scheduleData.rewardAvailableInterval = 8*unitaryArray;
scheduleData.trialDuration = scheduleData.rewardAvailableInterval;
scheduleData.jitterThreshold = 0.01 * unitaryArray;

scheduleData.leftPokeDelay = 0.1*unitaryArray;
scheduleData.leftValveDuration = 0.03 * unitaryArray;
scheduleData.rightPokeDelay = 0.1*unitaryArray;
scheduleData.rightValveDuration = 0.03 * unitaryArray;


choiceOfCue=ceil(rand(size(unitaryArray))*4);


scheduleData.odor1Flow= 60*unitaryArray;
% channel 2: caproic (left)
% channel 3: citral(left)
% channel 4: hexanol (right)
% channel 5: menthol(right)

scheduleData.odor1Valve = 0*unitaryArray;


scheduleData.odor1Valve(choiceOfCue == 1) = 1;
scheduleData.odor1Valve(choiceOfCue == 2) = 2;
scheduleData.odor1Valve(choiceOfCue == 3) = 3;
scheduleData.odor1Valve(choiceOfCue == 4) = 4;


scheduleData.left = 0*unitaryArray;
scheduleData.right = 0*unitaryArray;
scheduleData.left(choiceOfCue == 1)= 1;
scheduleData.left(choiceOfCue == 2)= 1;
scheduleData.right(choiceOfCue == 3)= 1;
scheduleData.right(choiceOfCue == 4)= 1;

scheduleData.leftRewardDelay= 0*unitaryArray;
scheduleData.rightRewardDelay= 0*unitaryArray;
scheduleData.leftRewardDelay(choiceOfCue == 2)=3;
scheduleData.leftRewardDelay(choiceOfCue == 4)=3;



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