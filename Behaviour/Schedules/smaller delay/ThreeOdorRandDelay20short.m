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
%  .righttValveDuration - The time, in seconds, to keep the valve open during a reward.
%  .punishmentInterval - The time, in seconds, after the trialDuration has elapsed, before a new trial may be initiated.
%                        Be aware that this is appended to the trialDuration, it does not replace it.
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
%  .odor2Flow - The olfactometer flow rate for odor2, in ml/min, this is used to set mixture values.
%  .odor2Valve - The valve (0-7) to be opened during the cue.
%                This may be the neutral valve, in the case where this bank is not involved in the cue.
%  .totalFlow - The sum of the olfactometer flow rates for odor1, odor2, and carrier, in ml/min.
%               The carrier flow is calculated using this value, to maintain an even flow rate regardless of mixture.
%  .cueDuration - The maximum length, in seconds, of the cue to be delivered.
%  .continuousTrialAvailability - A flag (0 for false, non-zero for true) which causes a new trial to become 
%                                 immediately available upon a decision event, regardless of time left in the trialDuration.
%  .postTrialDelay - Time, in seconds, to wait, after a trial is finished, before making the next trial available (regardless of continuousTrialAvailability).
%                    Typically this will be set to 0, and rarely will it be more than a few hundred milliseconds (simply to limit the rate of trial initiation).
%  .requirePokeForReward - A flag (0 for false, non-zero for true) which, when true, only gives a reward if the port remains poked,
%                          otherwise, the reward is released as soon as the appropriate delay has elapsed, regardless of the poke state.
%                          Has no effect on the center poke.
%  .leftRewardDelay - A time, in seconds, after the poke has been validated (by counting or timing [see .left and .leftPokeDelay]) at which to release the reward.
%  .rightRewardDelay - A time, in seconds, after the poke has been validated (by counting or timing [see .right and .rightPokeDelay]) at which to release the reward.
%  .soundFiles - Sound file names, with fully specified paths. See .sounds for more information.
%                Example: scheduleData.soundFiles = {'C:\sounds\sound1.wav', 'C:\sounds\sound2.wav'};
%  .sounds - The per-trial specification of cue tones, each value is interpreted as an index into scheduleData.soundFiles.
%  .incrementTrialOnFailure - Flag (0 for false, non-zero otherwise) to increment the trial number if a failure (wrong decision) occurs.
%  .incrementTrialOnAbort - Flag (0 for false, non-zero otherwise) to increment the trial number if an abort (insufficient cue sampling, insufficient number of pokes) occurs.
%  .incrementTrialOnTimeout - Flag (0 for false, non-zero otherwise) to increment the trial number if a timeout (no decision within the trialDuration) occurs.
%  .cueLabels - A cell array of strings, used to label the cues in the associated video overlay.
%               Example: scheduleData.cueLabels = {'A', 'B'};
%  .cueLabelIndex - The current trial's index into the .cueLabels field.
%                   This allows a small set of labels (see above) to apply to all trials.
%                   Example: Given `.cueLabels = {'A', 'B'};`, setting `.cueLabel = [1, 2, 1, 2, 1, 1, 1];` would result in the trials being labeled (respectively):
%                            'A', 'B', 'A', 'B', 'A', 'A', 'A'
%
% * All values are arrays, with one element per trial, unless otherwise specified.
% * Arbitrary numeric arrays and strings may be included for storage in the header.
% * Arbitrary numeric arrays and strings may be included for storage in the header.
function scheduleData = ThreeOdorRandDelay20short

%Custom seeding of the built-in Matlab random number generator (see rand), can be done here.
%Randomize the seed, so it's unique across boxes and times.
global behaviorControlScheduleRandomizerSeeded
if isempty(behaviorControlScheduleRandomizerSeeded) || ~behaviorControlScheduleRandomizerSeeded
   c = clock;
   hid = hostid;
   if iscell(hid)
       hid = hid{1};
   end
   lic = license;
   seed = int32(sum(clock) + (c(4) & c(5)) + 10000 * sum(hid) + c(5) * str2double(lic));%If you want the same seed across boxes/initiation times, set it here.
   fprintf(1, 'Schedule ''dnms'' seeding random number generator with %s...\n', num2str(seed));
   RandStream.setDefaultStream(RandStream.create('mrg32k3a', 'Seed', int32(seed)));
   behaviorControlScheduleRandomizerSeeded = 1;
end

%Set a hardcoded seed, to ensure the same distribution each time.
%seed = ;
%fprintf(1, 'Schedule ''operant'' seeding random number generator with %s...\n', num2str(seed));
%RandStream.setDefaultStream(RandStream.create('mlfg6331', 'Seed', int32(seed)));



%%%%%%%%%%%%%%%%%%%%%%%%%================= Trial Setup =====================%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%A pre-filled array of ones, which may be useful in creating other arrays. Of course, this variable may be ignored/removed.
unitaryArray = ones(300, 1);

%Time, in seconds, after the trial has started, during which a reward is available.
scheduleData.rewardAvailableInterval = 4 * unitaryArray;

%Total time of the trial, from the trial start event (cue onset; centerPokeDelay achieved), until punishment or next trial.
scheduleData.trialDuration = scheduleData.rewardAvailableInterval;

%Time, in seconds, after a failed trial (after the trialDuration has elapsed), before the next trial may be initiated.
scheduleData.punishmentInterval = 0 * unitaryArray;

%Flag to allow the next trial to begin immediately, with no refractory period due to the remainder of the trialDuration.
scheduleData.continuousTrialAvailability = 0 * unitaryArray;

%Flag to increment the trial number if a failure (wrong decision) occurs.
scheduleData.incrementTrialOnFailure = 1 * unitaryArray;

%Flag to increment the trial number if an abort (insufficient cue sampling, insufficient number of pokes) occurs.
scheduleData.incrementTrialOnAbort = 0 * unitaryArray;

%Flag to increment the trial number if a timeout (no decision within the trialDuration) occurs.
scheduleData.incrementTrialOnTimeout = 1 * unitaryArray;

%Time to wait, after a trial is finished, before making the next trial available (regardless of continuousTrialAvailability).
scheduleData.postTrialDelay = 0 * unitaryArray;

%%%%%%%%%%%%%%%%%%%%%%%%%================= Center Poke =====================%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Time, in seconds, in the center poke, before the cue.
%If this delay is 0, this port is non-contingent.
scheduleData.centerPokeDelay = 0.00001 * unitaryArray;

%Time, in seconds, required in the center poke to start a valid trial.
scheduleData.cueSamplingTime = 0.2 * unitaryArray;

%Time, in seconds, that the cue is delivered (unless the animal leaves the poke, at which point delivery is stopped).
scheduleData.cueDuration = 3 * unitaryArray;

%Time, in seconds, allowed to poke out of the center poke, during the cueSamplingTime, before the trial is aborted (to smooth out jitter).
scheduleData.jitterThreshold = 0.03 * unitaryArray;

%Total flow rate (odor1 + odor2 + carrier), in ml/min.
scheduleData.totalFlow = 1000 * unitaryArray;

%Flow rate, in ml/min, for odor1, per trial.
scheduleData.odor1Flow = 60 * unitaryArray;

%Flow rate, in ml/min, for odor2, per trial.
scheduleData.odor2Flow = 60 * unitaryArray;

%Pick a cue, at random.
choiceOfCue = rand(size(unitaryArray));

%Valve number (0-7) for the first odor bank. May be the neutral valve.
scheduleData.odor1Valve = double(choiceOfCue <= 0.40);
scheduleData.odor1Valve(choiceOfCue > 0.80) = 2;

%Valve number (0-7) for the second odor bank. May be the neutral valve.
scheduleData.odor2Valve = 0 * unitaryArray;
for i = 1 : length(choiceOfCue)
    if choiceOfCue(i) > 0.40 && choiceOfCue(i) <= 0.80
        scheduleData.odor2Valve(i) = 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%================= Side Poke and Reward=====================%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Flag to only release the reward if the animal has not yet poked out, otherwise release the reward after the delay, regardless of poke state.
scheduleData.requirePokeForReward = unitaryArray;

%Time, in seconds, required in the poke to recieve a reward.
%If set to 0, the reward becomes available as soon as the trial starts.
%When counting pokes, this acts as the maximum inter-poke-interval (minimum poke frequency), defined from poke-in to poke-in.
scheduleData.leftPokeDelay = 0.1 * unitaryArray;

%Time, in seconds, required in the poke to recieve a reward.
%If set to 0, the reward becomes available as soon as the trial starts.
%When counting pokes, this acts as the maximum inter-poke-interval (minimum poke frequency), defined from poke-in to poke-in.
scheduleData.rightPokeDelay = 0.1 * unitaryArray;

%Time, in seconds, to hold the left valve open.
%Size of the reward.
scheduleData.leftValveDuration = 0.04 * unitaryArray;

%Time, in seconds, to hold the right valve open.
%Size of the reward.
%If set to 0, the reward becomes available as soon as the trial starts.
scheduleData.rightValveDuration = 0.04 * unitaryArray;

%Boolean flag to indicate if left is a correct answer for each trial, 0 for false, and 1 for true.
%Values greater than 1 require multiple pokes to be counted before a success is declared.
scheduleData.left = scheduleData.odor1Valve;
scheduleData.left(choiceOfCue > 0.80) = 1;

%Boolean flag to indicate if right is a correct answer for each trial, 0 for false, and 1 for true.
%Values greater than 1 require multiple pokes to be counted before a success is declared.
scheduleData.right = scheduleData.odor2Valve;
scheduleData.right(choiceOfCue > 0.80) = 1;

%Randomize the reward delay from 0.2 - 1.0
for i=1:length(unitaryArray)
randDelay(i) = 0.0005 * i * rand;
end


%The time, in seconds, after the poke has been validated (by counting or timing [see .left and .leftPokeDelay]) at which to release the reward.
scheduleData.leftRewardDelay = randDelay;

%The time, in seconds, after the poke has been validated (by counting or timing [see .right and .rightPokeDelay]) at which to release the reward.
scheduleData.rightRewardDelay = randDelay;

%Total time of the trial, from the trial start event (cue onset; centerPokeDelay achieved), until punishment or next trial.
scheduleData.trialDuration = scheduleData.rewardAvailableInterval;
    
%%%%%%%%%%%%%%%%%%%%%%%%%================= Sound and Video=====================%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Sound files, with fully specified paths, which may then be referenced by their array index, on a per-trial basis.
scheduleData.soundFiles = {};%ie. scheduleData.soundFiles = {'C:\sounds\sound1.wav', 'C:\sounds\sound2.wav'};

%The per-trial specification of cue tones, each value is interpreted as an index into scheduleData.soundFiles.
scheduleData.sounds = [];


%Arbitrary fields may be added here, which will get carried into the header data.
%scheduleData.myString = 'MY_STRING';
%scheduleData.myNumbers = [0, 1, 2, 3, 4, 5];

%An array of mnemonic labels for cues (to be overlayed on the video stream).
scheduleData.cueLabels = {'A', 'B', 'C'};
%Per trial index into .cueLabels, allowing a small set of labels to be applied all trials.
scheduleData.cueLabelIndex = unitaryArray;
scheduleData.cueLabelIndex(scheduleData.odor1Valve == 2) = 3;
scheduleData.cueLabelIndex(scheduleData.odor2Valve == 1) = 2;

return;