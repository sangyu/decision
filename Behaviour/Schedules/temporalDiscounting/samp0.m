	%The function declaration must return a scheduleData structure, with fields:
%  .centerPokeDelay - The time, in seconds, after a center poke trial initiation before a cue is delivered.
%                     A value of 0 causes the trial to be automatically initiated, no poke event is necessary.
%                     To get "immediate" cue onset, use an arbitrarily small, but non-zero, number (ie. 0.00001).
%  .leftPokeDelay - The time, in seconds, after a successful decision, before a reward is delivered.
%                   A value of 0 causes the reward to be automatically initiated, as soon as the trial starts, no poke event is necessary.
%                   To get "immediate" reward onset, use an arbitrarily small, but non-zero, number (ie. 0.00001).
%                   Also  acts as the maximum allowed time between pokes (the inter-poke-interval; poke-in to poke-in) when counting poke events.
%                   See ".left", below.
%  .rightPokeDelay - The time, in seconds, after a successful decision, before a reward is delivered.
%                    A value of 0 causes the reward to be automatically initiated, as soon as the trial starts, no poke event is necessary.
%                    To get "immediate" reward onset, use an arbitrarily small, but non-zero, number (ie. 0.00001).
%                    Also  acts as the maximum allowed time between pokes (the inter-poke-interval; poke-in to poke-in) when counting poke events.
%                    See ".right", below.
%  .cueSamplingTime - The time, in seconds, to poke in the center to activate a trial.
%                     Poking out before the time has elapsed results in an 'abort'.
%  .rewardAVailableInterval - The time, in seconds, from the start of the trial, during which a reward is available.
%  .trialDuration - The total length of the trial, in seconds.
%                   This time elapsing without a decision results in a 'timeout'.
%                   See ".continuousTrialAvailability", below.
%  .leftValveDuration - The time, in seconds, to keep the valve open during a reward.
%                       May be a two dimensional array, where the second dimension corresponds to multiple reward deliveries.
%                       The number of leftValveDuration values should correspond to the number of leftRewardDelay values.
%  .righttValveDuration - The time, in seconds, to keep the valve open during a reward.
%                         May be a two dimensional array, where the second dimension corresponds to multiple reward deliveries.
%                        The number of rightValveDuration values should correspond to the number of rightRewardDelay values.
%  .nogoRewardMultiplier - Factor by which to increase the reward after a successful no-go trial.
%  .successSound - The per-trial specification of success tones, each value is interpreted as an index into scheduleData.soundFiles.
%                  Use 0 for no sound for a particular trial.
%  .rewardSound - The per-trial specification of reward tones, each value is interpreted as an index into scheduleData.soundFiles.
%                 Use 0 for no sound for a particular trial.
%  .punishmentInterval - The time, in seconds, after the trialDuration has elapsed, before a new trial may be initiated.
%                        Be aware that this is appended to the trialDuration, it does not replace it.
%  .punishmentSoundFiles - The full path to the sound file used for punishment (or to simply indicate a wrong decision).
%                         Set to empty to have no punishment tone.
%                         As a special case, you may specify 'whitenoise', which will result in random noise.
%                         Example: scheduleData.punishmentSoundFiles = {'C:\sounds\punish1.wav', 'C:\sounds\punish2.wav'};
%  .punishmentSounds - The per-trial specification of cue tones, each value is interpreted as an index into scheduleData.soundFiles.
%                     Use 0 for no punishment tone for a specific trial.
%  .punishmentSoundDuration - The per-trial duration of each punishment tone, in seconds.
%                            If punishmentToneDuration is more than punishmentInterval and remaining trial time, the result is an effective punishmentToneDuration
%                            equal to punishmentInterval. That is to say, punishmentInterval and trialDuration take precedence.
%                            If punishmentToneDuration is longer than the length of the provided sound file, punishmentToneDuration will be truncated to match.
%  .left - A series of flags indicating whether the left poke counts as a correct decision. Zero for false, non-zero for true.
%          Using a value greater than 1 requires multiple pokes in order to register as a success (ie. a 3 means 3 poke events are necessary).
%          In this counting mode, the leftPokeDelay is the maximum time between subsequent pokes (poke-in to poke-in), anything longer constitutes an abort.
%          When counting, the reward is delivered immediately after the last required poke is achieved and a new trial beginss.
%          If, for instance, the leftPokeDelay is 10 seconds, and left is 3, then 3 pokes are required to happen within 10 seconds.
%  .right - A series of flags indicating whether the right poke counts as a correct decision. Zero for false, non-zero for true.
%          Using a value greater than 1 requires multiple pokes in order to register as a success (ie. a 3 means 3 poke events are necessary).
%          In this counting mode, the righstPokeDelay is the maximum time between subsequent pokes (poke-in to poke-in), anything longer constitutes an abort.
%          When counting, the reward is delivered immediately after the last required poke is achieved and a new trial beginss.
%          If, for instance, the rightPokeDelay is 10 seconds, and right is 3, then 3 pokes are required to happen within 10 seconds.
%  .jitterThreshold - A time window during which a poke out is allowed, as long as a poke in occurs, with no resulting state change.
%                     This is used to smooth out jittery poke events, such as during the cue sampling.
%                     This applies to the cueSamplingTime, leftPokeDelay, and rightPokeDelay.
%  .odor1Flow - The olfactometer flow rate for odor1, in ml/min, this is used to set mixture values.
%  .odor1Valve - The valve (0-7) to be opened during the cue.
%                This may be the neutral valve, in the case where this bank is not involved in the cue.
%                If the 'Define odor valves in GUI' checkbox is checked, this value is ignored.
%  .odor2Flow - The olfactometer flow rate for odor2, in ml/min, this is used to set mixture values.
%  .odor2Valve - The valve (0-7) to be opened during the cue.
%                This may be the neutral valve, in the case where this bank is not involved in the cue.
%                If the 'Define odor valves in GUI' checkbox is checked, this value is ignored.
%  .odorNumber - The number (1-4) of the GUI defined odor to deliver.
%                If the 'Define odor valves in GUI' checkbox is not checked, this value is ignored.
%  .totalFlow - The sum of the olfactometer flow rates for odor1, odor2, and carrier, in ml/min.
%               The carrier flow is calculated using this value, to maintain an even flow rate regardless of mixture.
%  .cueDuration - The maximum length, in seconds, of the cue to be delivered.
%  .continuousTrialAvailability - A flag (0 for false, non-zero for true) which causes a new trial to become 
%                                 immediately available upon a decision event, regardless of time left in the trialDuration.
%                                 Any defined punishmentInterval still applies, before the next trial may be initiated.
%  .postTrialDelay - Time, in seconds, to wait, after a trial is finished, before making the next trial available (regardless of continuousTrialAvailability).
%                    Typically this will be set to 0, and rarely will it be more than a few hundred milliseconds (simply to limit the rate of trial initiation).
%  .requirePokeForReward - A flag (0 for false, non-zero for true) which, when true, only gives a reward if the port remains poked,
%                          otherwise, the reward is released as soon as the appropriate delay has elapsed, regardless of the poke state.
%                          Has no effect on the center poke.
%  .leftRewardDelay - A time, in seconds, after the poke has been validated (by counting or timing [see .left and .leftPokeDelay]) at which to release the reward.
%                       May be a two dimensional array, where the second dimension corresponds to multiple reward deliveries.
%                       The number of leftValveDuration values should correspond to the number of leftRewardDelay values.
%  .rightRewardDelay - A time, in seconds, after the poke has been validated (by counting or timing [see .right and .rightPokeDelay]) at which to release the reward.
%                       May be a two dimensional array, where the second dimension corresponds to multiple reward deliveries.
%                       The number of rightValveDuration values should correspond to the number of rightRewardDelay values.
%  .soundFiles - Sound file names, with fully specified paths. See .cueSounds for more information.
%                Example: scheduleData.soundFiles = {'C:\sounds\sound1.wav', 'C:\sounds\sound2.wav'};
%  .cueSounds - The per-trial specification of cue tones, each value is interpreted as an index into scheduleData.soundFiles.
%            Use 0 for no sound for a particular trial.
%  .allowTrialReinitiation - Flag (0 for false, non-zero otherwise) to indicate if reinitiation is allowed for each given trial.
%  .incrementTrialOnFailure - Flag (0 for false, non-zero otherwise) to increment the trial number if a failure (wrong decision) occurs.
%  .incrementTrialOnAbort - Flag (0 for false, non-zero otherwise) to increment the trial number if an abort (insufficient cue sampling, insufficient number of pokes) occurs.
%  .incrementTrialOnTimeout - Flag (0 for false, non-zero otherwise) to increment the trial number if a timeout (no decision within the trialDuration) occurs.
%  .cueLabels - A cell array of strings, used to label the cues in the associated video overlay.
%               Example: scheduleData.cueLabels = {'A', 'B'};
%  .cueLabelIndex - The current trial's index into the .cueLabels field.
%                   This allows a small set of labels (see above) to apply to all trials.
%                   Example: Given `.cueLabels = {'A', 'B'};`, setting `.cueLabel = [1, 2, 1, 2, 1, 1, 1];` would result in the trials being labeled (respectively):
%                            'A', 'B', 'A', 'B', 'A', 'A', 'A'
%  .cueOnTTL - When non-zero, a rising edge is issued on the center poke "valve" line, when the cue is initiated.
%              May be upgraded later to represent a programmable interval, after which the pulse will be issued.
%  .cueSampledTTL - When non-zero, a rising edge is issued on the center poke "valve" line, when the cue is completed (either by cueDuration or a poke out).
%                   May be upgraded later to represent a programmable interval, after which the pulse will be issued.
%  .correctDecisionTTL - When non-zero, a rising edge is issued on the center poke "valve" line, when a correct decision is made (poke in).
%                        May be upgraded later to represent a programmable interval, after which the pulse will be issued.
%  .incorrectDecisionTTL - When non-zero, a rising edge is issued on the center poke "valve" line, when an incorrect decision is made (poke in).
%                          May be upgraded later to represent a programmable interval, after which the pulse will be issued.
%  .rewardTTL - When non-zero, a rising edge is issued on the center poke "valve" line, when the reward is released.
%               May be upgraded later to represent a programmable interval, after which the pulse will be issued.
%
% * All values are arrays, with one element per trial, unless otherwise specified.
% * Arbitrary numeric arrays and strings may be included for storage in the header.
% * Arbitrary numeric arrays and strings may be included for storage in the header.
function scheduleData = samp0

%A pre-filled array of ones, which may be useful in creating other arrays. Of course, this variable may be ignored/removed.

%Custom seeding of the built-in Matlab random number generator (see rand), can be done here.
%Randomize the seed, so it's unique across boxes and times.
%global behaviorControlScheduleRandomizerSeeded
%if isempty(behaviorControlScheduleRandomizerSeeded) || ~behaviorControlScheduleRandomizerSeeded
%    c = clock;
%    hid = hostid;
%    if iscell(hid)
%        hid = hid{1};
%    end
%    lic = license;
%    seed = int32(sum(clock) + (c(4) & c(5)) + 10000 * sum(hid) + c(5) * str2double(lic));%If you want the same seed across boxes/initiation times, set it here.
%    fprintf(1, 'Schedule ''testjjun11'' seeding random number generator with %s...\n', num2str(seed));
%    RandStream.setDefaultStream(RandStream.create('mrg32k3a', 'Seed', int32(seed)));
%    behaviorControlScheduleRandomizerSeeded = 1;
%end

%Set a hardcoded seed, to ensure the same distribution each time.
%seed = ;
%fprintf(1, 'Schedule ''operant'' seeding random number generator with %s...\n', num2str(seed));
%RandStream.setDefaultStream(RandStream.create('mlfg6331', 'Seed', int32(seed)));


%flag, left bigger and delayed scheduleData.LR= 0; right bigger and delayed scheduleData.LR=1; 
scheduleData.N=300;
unitaryArray=ones(scheduleData.N, 1);


scheduleData.LR=1;
scheduleData.bigSize=1;
scheduleData.bigDelay=0;
scheduleData.smallSize=1;
scheduleData.smallDelay=0;
duration=10;

scheduleData.timeToShoot=0;
scheduleData.densityOfShooting=1;
scheduleData.periodOfNoShooting=[200];
scheduleData.shoot=unitaryArray;

r = randperm(scheduleData.N-1+1) - 1; 
r = 1 + r(1:round((1-scheduleData.densityOfShooting)*scheduleData.N)) ;
scheduleData.shoot(scheduleData.periodOfNoShooting)=0;
scheduleData.shoot(r)=0;
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
scheduleData.continuousTrialAvailability = 1 * unitaryArray ;

%Flag (0 for false, non-zero otherwise) to indicate if reinitiation is allowed for each given trial.
scheduleData.allowTrialReinitiation = 0 * unitaryArray;

%Flag to increment the trial number if a failure (wrong decision) occurs.
scheduleData.incrementTrialOnFailure = 0 * unitaryArray;

%Flag to increment the trial number if an abort (insufficient cue sampling, insufficient number of pokes) occurs.
scheduleData.incrementTrialOnAbort = 0 * unitaryArray;

%Flag to increment the trial number if a timeout (no decision within the trialDuration) occurs.
scheduleData.incrementTrialOnTimeout = 0 * unitaryArray;

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
scheduleData.leftPokeDelay (1:15)= 0;

%Boolean flag to indicate if left is a correct answer for each trial, 0 for false, and 1 for true.
%Values greater than 1 require multiple pokes to be counted before a success is declared.
scheduleData.left = 1 * unitaryArray;

% Right

%Time, in seconds, required in the poke to recieve a reward.
%If set to 0, the reward becomes available as soon as the trial starts.
%When counting pokes, this acts as the maximum inter-poke-interval (minimum poke frequency), defined from poke-in to poke-in.
scheduleData.rightPokeDelay = .001 * unitaryArray;
scheduleData.rightPokeDelay (1:15)= 0;


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

scheduleData.forceLightsOn = unitaryArray;
scheduleData.forceLightsOffDuringTrialAvailable = unitaryArray;
scheduleData.forceLightsOffDuringPostTrialDelay = unitaryArray;
scheduleData.forceLightsOffDuringPunishmentInterval = unitaryArray;
scheduleData.forceLightsOffDuringCueSampling = unitaryArray;
scheduleData.forceLightsOffAfterCueSampling = 0 * unitaryArray;



%% labels and TTL controls



%Arbitrary fields may be added here, which will get carried into the header data.
%scheduleData.myString = 'MY_STRING';
%scheduleData.myNumbers = [0, 1, 2, 3, 4, 5];



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
scheduleData.leftDecisionTTL = 0 * unitaryArray;
scheduleData.rightDecisionTTL = 0 * unitaryArray;
scheduleData.noResponse = 0 * unitaryArray;


switch lower(scheduleData.timeToShoot)
    case{'cueon'}
        scheduleData.cueOnTTL = scheduleData.shoot; 
    case{'cuesampled'} 
        scheduleData.cueSampledTTL = scheduleData.shoot; 
    case{'correctdecision'}
        scheduleData.correctDecisionTTL = scheduleData.shoot; 
    case{'incorrectdecision'}
        scheduleData.incorrectDecisionTTL = scheduleData.shoot; 
    case{'reward'}
        scheduleData.rewardTTL = scheduleData.shoot; 
    case{'leftdecision'}
         scheduleData.leftDecisionTTL = scheduleData.shoot; 
   case{'rightdecision'}
             scheduleData.rightDecisionTTL = scheduleData.shoot; 
    case{0};
        return;
end
return;