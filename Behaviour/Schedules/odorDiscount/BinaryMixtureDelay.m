
function scheduleData = BinaryMixtureDelay
scheduleData.LR=0;

scheduleData.N=300;
%A pre-filled array of ones, which may be useful in creating other arrays. Of course, this variable may be ignored/removed.
unitaryArray = ones(scheduleData.N, 1);


%Time, in seconds, in the center poke, before the cue.
%If this delay is 0, this port is non-contingent.
scheduleData.centerPokeDelay = 0.001 * unitaryArray;

%Time, in seconds, required in the center poke to start a valid trial.
scheduleData.cueSamplingTime = 0.3* unitaryArray;



%Time, in seconds, after the trial has started, during which a reward is available.
scheduleData.rewardAvailableInterval = 12*unitaryArray;


%Total time of the trial, from the trial start event (cue onset; centerPokeDelay achieved), until punishment or next trial.
scheduleData.trialDuration = scheduleData.rewardAvailableInterval;

%Time, in seconds, allowed to poke out of the center poke, during the cueSamplingTime, before the trial is aborted (to smooth out jitter).
scheduleData.jitterThreshold = 0.01 * unitaryArray;




%----------------------------------LEFT POKE---------------


%Time, in seconds, required in the poke to recieve a reward.
%If set to 0, the reward becomes available as soon as the trial starts.
%When counting pokes, this acts as the maximum inter-poke-interval (minimum poke frequency), defined from poke-in to poke-in.
scheduleData.leftPokeDelay = 0.1*unitaryArray;


%Time, in seconds, to hold the left valve open.
%Size of the reward.
scheduleData.leftValveDuration = 0.04 * unitaryArray;


%-----------------------------------RIGHT POKE--------


%Time, in seconds, required in the poke to recieve a reward.
%If set to 0, the reward becomes available as soon as the trial starts.
%When counting pokes, this acts as the maximum inter-poke-interval (minimum poke frequency), defined from poke-in to poke-in.
scheduleData.rightPokeDelay = 0.1*unitaryArray;


%Time, in seconds, to hold the right valve open.
%Size of the reward.
%If set to 0, the reward becomes available as soon as the trial starts.
scheduleData.rightValveDuration = 0.04 * unitaryArray;



%Time, in seconds, after a failed trial (after the trialDuration has elapsed), before the next trial may be initiated.
scheduleData.punishmentInterval = 0*unitaryArray;


%---------------------REWARD LOGIC--------------

%Pick a cue, at random.
%Pick a cue, at random.
choiceOfCue = rand(size(unitaryArray));
choiceOfCue(choiceOfCue <= .125) = 1;
choiceOfCue(choiceOfCue > .125 & choiceOfCue <= .25) = 2;
choiceOfCue(choiceOfCue > .25 & choiceOfCue <= .375) = 3;
choiceOfCue(choiceOfCue > .375 & choiceOfCue <= .50) = 4;
choiceOfCue(choiceOfCue > .50 & choiceOfCue <= .625) = 5;
choiceOfCue(choiceOfCue > .625 & choiceOfCue <= .750) = 6;
choiceOfCue(choiceOfCue > .750 & choiceOfCue <= .875) = 7;
choiceOfCue(choiceOfCue > .875 & choiceOfCue < 1) = 8;

scheduleData.choiceOfCue = choiceOfCue;

%Valve number (0-7) for the first odor bank. May be the neutral valve.
%If the 'Define odor valves in GUI' checkbox is checked, this value is ignored.
scheduleData.odor1Valve = ones(size(choiceOfCue));
scheduleData.odor1Valve(choiceOfCue == 8) = 0;
%Valve number (0-7) for the second odor bank. May be the neutral valve.
%If the 'Define odor valves in GUI' checkbox is checked, this value is ignored.
scheduleData.odor2Valve = 7*ones(size(choiceOfCue));
scheduleData.odor2Valve(choiceOfCue == 1) = 0;



%Boolean flag to indicate if left is a correct answer for each trial, 0 for false, and 1 for true.
%Values greater than 1 require multiple pokes to be counted before a success is declared.
scheduleData.left = 1*unitaryArray;


%Boolean flag to indicate if right is a correct answer for each trial, 0 for false, and 1 for true.
%Values greater than 1 require multiple pokes to be counted before a success is declared.
scheduleData.right = 1*unitaryArray;



%Flow rate, in ml/min, for odor1, per trial.
scheduleData.odor1Flow(choiceOfCue == 1) = 60;
scheduleData.odor1Flow(choiceOfCue == 2) = 48;
scheduleData.odor1Flow(choiceOfCue == 3) = 41;
scheduleData.odor1Flow(choiceOfCue == 4) = 34;
scheduleData.odor1Flow(choiceOfCue == 5) = 26;
scheduleData.odor1Flow(choiceOfCue == 6) = 19;
scheduleData.odor1Flow(choiceOfCue == 7) = 12;
scheduleData.odor1Flow(choiceOfCue == 8) = 0;
scheduleData.odor1Flow=scheduleData.odor1Flow/3;

scheduleData.leftRewardDelay=scheduleData.odor1Flow/10;



%Flow rate, in ml/min, for odor2, per trial.
scheduleData.odor2Flow(choiceOfCue == 8) = 60;
scheduleData.odor2Flow(choiceOfCue == 7) = 48;
scheduleData.odor2Flow(choiceOfCue == 6) = 41;
scheduleData.odor2Flow(choiceOfCue == 5) = 34;
scheduleData.odor2Flow(choiceOfCue == 4) = 26;
scheduleData.odor2Flow(choiceOfCue == 3) = 19;
scheduleData.odor2Flow(choiceOfCue == 2) = 12;
scheduleData.odor2Flow(choiceOfCue == 1) = 0;

scheduleData.odor2Flow=scheduleData.odor2Flow/3;

scheduleData.rightRewardDelay=scheduleData.odor2Flow/10;



%The number (1-4) of the GUI defined odor to deliver.
%If the 'Define odor valves in GUI' checkbox is not checked, this value is ignored.
scheduleData.odorNumber = [];

%Total flow rate (odor1 + odor2 + carrier), in ml/min.
scheduleData.totalFlow = 1000*unitaryArray;
%scheduleData.totalFlow(1:20) = linspace(1,1000,20);

%Time, in seconds, that the cue is delivered (unless the animal leaves the poke, at which point delivery is stopped).
scheduleData.cueDuration = 4*unitaryArray;




%------------------------------------------------------------

%Flag to allow the next trial to begin immediately, with no refractory period due to the remainder of the trialDuration.
scheduleData.continuousTrialAvailability = 0*unitaryArray;

%Flag to only release the reward if the animal has not yet poked out, otherwise release the reward after the delay, regardless of poke state.
scheduleData.requirePokeForReward = 1*unitaryArray;



%Sound files, with fully specified paths, which may then be referenced by their array index, on a per-trial basis.
scheduleData.soundFiles = {};%ie. scheduleData.soundFiles = {'C:\sounds\sound1.wav', 'C:\sounds\sound2.wav'};

%The per-trial specification of cue tones, each value is interpreted as an index into scheduleData.soundFiles.
scheduleData.sounds = [];

%Flag to increment the trial number if a failure (wrong decision) occurs.
scheduleData.incrementTrialOnFailure = 1*unitaryArray;

%Flag to increment the trial number if an abort (insufficient cue sampling, insufficient number of pokes) occurs.
scheduleData.incrementTrialOnAbort = 0*unitaryArray;

%Flag to increment the trial number if a timeout (no decision within the trialDuration) occurs.
scheduleData.incrementTrialOnTimeout = 1*unitaryArray;

%Time to wait, after a trial is finished, before making the next trial available (regardless of continuousTrialAvailability).
scheduleData.postTrialDelay = 0*unitaryArray;

%Arbitrary fields may be added here, which will get carried into the header data.
%scheduleData.myString = 'MY_STRING';
%scheduleData.myNumbers = [0, 1, 2, 3, 4, 5];

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