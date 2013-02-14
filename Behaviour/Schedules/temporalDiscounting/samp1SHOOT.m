
function scheduleData = samp1SHOOT


scheduleData.N=200;
unitaryArray=ones(scheduleData.N, 1);


scheduleData.LR=1;
scheduleData.bigSize=1;
scheduleData.bigDelay=1;
scheduleData.smallSize=1;
scheduleData.smallDelay=1;
duration=5;

scheduleData.densityOfShooting=1;
scheduleData.leftDecisionTTL=unitaryArray;
scheduleData.leftDecisionTTL([1:30, 51:70, 91: 120, 151: 160])=0;


scheduleData.rightDecisionTTL=unitaryArray;
scheduleData.rightDecisionTTL([1:50, 71:90, 121:150, 161:180])=0;
scheduleData.shoot=unitaryArray;

scheduleData.rewardInterval=.1;

scheduleData.bigRewardMatrix=ones(scheduleData.N,scheduleData.bigSize);
scheduleData.smallRewardMatrix=[ones(scheduleData.N,scheduleData.smallSize), zeros(scheduleData.N, scheduleData.bigSize-scheduleData.smallSize)];

if scheduleData.LR==0
    scheduleData.leftValveDuration =.03 *scheduleData.bigRewardMatrix;
    scheduleData.leftRewardDelay= [scheduleData.bigDelay*scheduleData.bigRewardMatrix(:, 1), scheduleData.rewardInterval*scheduleData.bigRewardMatrix(:, 2:end)];
    scheduleData.rightValveDuration =.03 *scheduleData.smallRewardMatrix;
    scheduleData.rightRewardDelay= [scheduleData.smallDelay*scheduleData.smallRewardMatrix(:, 1), scheduleData.rewardInterval*scheduleData.smallRewardMatrix(:, 2:end)];
else
    scheduleData.rightValveDuration =.03 *  scheduleData.bigRewardMatrix;
    scheduleData.rightRewardDelay= [scheduleData.bigDelay*scheduleData.bigRewardMatrix(:, 1), scheduleData.rewardInterval*scheduleData.bigRewardMatrix(:, 2:end)];
    scheduleData.leftValveDuration =.03 *  scheduleData.smallRewardMatrix;
    scheduleData.leftRewardDelay= [scheduleData.smallDelay*scheduleData.smallRewardMatrix(:, 1), scheduleData.rewardInterval*scheduleData.smallRewardMatrix(:, 2:end)];
end    


%, 0*unitaryArray

%% General Setting
%Total time of the trial, from the trial start event (cue onset; centerPokeDelay achieved), until punishment or next trial.
scheduleData.trialDuration = duration  * unitaryArray;

%Time, in seconds, after the trial has started, during which a reward is available.
scheduleData.rewardAvailableInterval = duration * unitaryArray;

%Flag to allow the next trial to begin immediately, with no refractory period due to the remainder of the trialDuration.
scheduleData.continuousTrialAvailability = 0 * unitaryArray ;

%Flag (0 for false, non-zero otherwise) to indicate if reinitiation is allowed for each given trial.
scheduleData.allowTrialReinitiation = 0 * unitaryArray;

%Flag to increment the trial number if a failure (wrong decision) occurs.
scheduleData.incrementTrialOnFailure = 1 * unitaryArray;

%Flag to increment the trial number if an abort (insufficient cue sampling, insufficient number of pokes) occurs.
scheduleData.incrementTrialOnAbort = 0 * unitaryArray;

%Flag to increment the trial number if a timeout (no decision within the trialDuration) occurs.
scheduleData.incrementTrialOnTimeout = 1 * unitaryArray;

%Time to wait, after a trial is finished, before making the next trial available (regardless of continuousTrialAvailability).
scheduleData.postTrialDelay = 0 * unitaryArray;

%Sound files, with fully specified paths, which may then be referenced by their array index, on a per-trial basis.
scheduleData.soundFiles = {'C:\MouseBase\schedules\Sangyu\sounds\low.wav', 'C:\MouseBase\schedules\Sangyu\sounds\high.wav'};%ie. scheduleData.soundFiles = {'C:\sounds\sound1.wav', 'C:\sounds\sound2.wav'};

%An array of mnemonic labels for cues (to be overlayed on the video stream).
scheduleData.cueLabels = {};
%Per trial index into .cueLabels, allowing a small set of labels to be applied all trials.

scheduleData.cueLabelIndex = 0*unitaryArray;

%% Center Poke and Cues

%Time, in seconds, in the center poke, before the cue.
%If this delay is 0, this port is non-contingent.
scheduleData.centerPokeDelay = 0.0001 * unitaryArray;

%Time, in seconds, required in the center poke to start a valid trial.
scheduleData.cueSamplingTime = .2 * unitaryArray;

%Time, in seconds, that the cue is delivered (unless the animal leaves the poke, at which point delivery is stopped).
scheduleData.cueDuration = 1 * unitaryArray;

%Time, in seconds, allowed to poke out of the center poke, during the cueSamplingTime, before the trial is aborted (to smooth out jitter).
scheduleData.jitterThreshold = .01 * unitaryArray;

%Total flow rate (odor1 + odor2 + carrier), in ml/min.
scheduleData.totalFlow = 0 * unitaryArray;

%Flow rate, in ml/min, for odor1, per trial.
scheduleData.odor1Flow = 0 * unitaryArray;

%Valve number (0-7) for the first odor bank. May be the neutral valve.
%If the 'Define odor valves in GUI' checkbox is checked, this value is ignored.
scheduleData.odor1Valve = 0 * unitaryArray;

%Flow rate, in ml/min, for odor2, per trial.
scheduleData.odor2Flow = 0 * unitaryArray;

%Valve number (0-7) for the second odor bank. May be the neutral valve.
%If the 'Define odor valves in GUI' checkbox is checked, this value is ignored.
scheduleData.odor2Valve = 0 * unitaryArray;

%The number (1-4) of the GUI defined odor to deliver.
%If the 'Define odor valves in GUI' checkbox is not checked, this value is ignored.
scheduleData.odorNumber = [];


%The per-trial specification of cue tones, each value is interpreted as an index into scheduleData.soundFiles.
scheduleData.cueSounds = 0*unitaryArray;

%% Side Poke and Reward

% Left

%Time, in seconds, required in the poke to recieve a reward.
%If set to 0, the reward becomes available as soon as the trial starts.
%When counting pokes, this acts as the maximum inter-poke-interval (minimum poke frequency), defined from poke-in to poke-in.
scheduleData.leftPokeDelay = .0001 * unitaryArray;

%Boolean flag to indicate if left is a correct answer for each trial, 0 for false, and 1 for true.
%Values greater than 1 require multiple pokes to be counted before a success is declared.
scheduleData.left = 1 * unitaryArray;

% Right

%Time, in seconds, required in the poke to recieve a reward.
%If set to 0, the reward becomes available as soon as the trial starts.
%When counting pokes, this acts as the maximum inter-poke-interval (minimum poke frequency), defined from poke-in to poke-in.
scheduleData.rightPokeDelay = .001 * unitaryArray;


%Boolean flag to indicate if right is a correct answer for each trial, 0 for false, and 1 for true.
%Values greater than 1 require multiple pokes to be counted before a success is declared.
scheduleData.right = 1 * unitaryArray;



%Time, in seconds, after a failed trial (after the trialDuration has elapsed), before the next trial may be initiated.
scheduleData.punishmentInterval = 0 * unitaryArray;

% The full path to the sound files used for punishment (or to simply indicate a wrong decision).
scheduleData.punishmentSoundFiles = 0 * unitaryArray;%ie. scheduleData.soundFiles = {'C:\sounds\punish1.wav', 'C:\sounds\punish2.wav'};

%The per-trial specification of punishment tones, each value is interpreted as an index into scheduleData.punishmentSoundFiles.
scheduleData.punishmentSounds = 0 * unitaryArray;

%The per-trial duration of punishment tones, in seconds.
scheduleData.punishmentSoundDuration = 0 * unitaryArray;

%The per-trial specification of success tones, each value is interpreted as an index into scheduleData.soundFiles.
 scheduleData.successSounds = 1 * unitaryArray;

%The per-trial specification of reward tones, each value is interpreted as an index into scheduleData.soundFiles.
scheduleData.rewardSounds = 2 * unitaryArray;


%Flag to only release the reward if the animal has not yet poked out, otherwise release the reward after the delay, regardless of poke state.
scheduleData.requirePokeForReward = 1 * unitaryArray;

%Factor by which to increase the reward after a successful no-go trial.
scheduleData.nogoRewardMultiplier = 1 * unitaryArray;

scheduleData.noResponse = 0 * unitaryArray;


%% labels and TTL controls



%Arbitrary fields may be added here, which will get carried into the header data.
%scheduleData.myString = 'MY_STRING';
%scheduleData.myNumbers = [0, 1, 2, 3, 4, 5];


scheduleData.forceLightsOn = unitaryArray;
scheduleData.forceLightsOffDuringTrialAvailable = unitaryArray;
scheduleData.forceLightsOffDuringPostTrialDelay = unitaryArray;
scheduleData.forceLightsOffDuringPunishmentInterval = unitaryArray;
scheduleData.forceLightsOffDuringCueSampling = unitaryArray;
scheduleData.forceLightsOffAfterCueSampling = 0 * unitaryArray;


%When non-zero, a rising edge is issued on the center poke "valve" line, when the cue is initiated.
scheduleData.cueOnTTL = 0 * unitaryArray; 
%When non-zero, a rising edge is issued on the center poke "valve" line, when the cue is completed (either by cueDuration or a poke out).
scheduleData.cueSampledTTL = 0 * unitaryArray;
%When non-zero, a rising edge is issued on the center poke "valve" line, when a correct decision is made (poke in).
scheduleData.correctDecisionTTL = 0 * unitaryArray;
%When non-zero, a rising edge is issued on the center poke "valve" line, when an incorrect decision is made (poke in).
scheduleData.incorrectDecisionTTL = 0 * unitaryArray;
%When non-zero, a rising edge is issued on the center poke "valve" line, when the reward is released.
scheduleData.rewardTTL = 0 * unitaryArray;

return;