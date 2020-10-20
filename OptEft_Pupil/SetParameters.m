function [Config,letterperm]=SetParameters()
Config.Key=-1; % keyboard number
Config.CueDur = 3; % letter/cue duration
Config.SecFixDur = 1; % fixation cross duration after cue
Config.NoTrials=8; % number of trials in each block (except Capacity)
Config.ExpDur = 5; % experimental duration for each block
Config.CapacityDur = 100; % dummy - finishgame variable determines when this phase ends
Config.ResponseDeadline = 18; % maximum problem display time (or response deadline) - it used to be 18 when the task wasn't sequential
Config.ITImean = 2; % ITI should be centered around this mean
Config.NoResponse = .2; % don't record response within this initial interval of stimulus presentation
Config.TwoDigitRange = [10:1:99]; % 2 digit numbers should be selected from this range
Config.OneDigitRange = [1:1:9]; % 1 digit numbers should be selected from this range
Config.CapacityThreshold = .6; % accuracy threshold to break the code in the Capacity phase
Config.OrderList=[1 3 4 5]; % list of experimental conditions % 3 4 5 (easy, intermediate, difficult)
Config.OrderList=[perms(Config.OrderList) perms(Config.OrderList)];
Config.ReadTime = 3; % duration for reading prompts
Config.FixTime = 1; % duration for fixation cross unless specified otherwise
Config.FeedbackDur = 3; % feedback duration
Config.letters=['P','A','Y','Q']; letterperm=perms(Config.letters);
% Intended accuracy levels of the experimental conditions
Config.EasyAcc =.75;
Config.IntAcc =.50;
Config.DifAcc =.25;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keyboard values
KbName('UnifyKeyNames')
KeyTemp=KbName('KeyNames');
Config.rightkey = KbName('RightArrow');%'RightArrow';
Config.leftkey = KbName('LeftArrow');%LeftArrow';
Config.responseKey = KbName('return'); % return key
Config.spacebar = KbName('space'); % space
% colors from Pupil dilation in the Simon task as a marker of conflict
% processing by Henk vanSteenbergen1,2* and Guido P.H.Band1,2
% Theisoluminantcolor-schemewascreatedbyusinginkcolorsfromtheTeufel
% colorsset(TeufelandWehrhahn,2000): aslate-blue(RGB-code:
% 166, 160,198)background,adark-cyan(110,185,180)fixation,
% a khaki(188,175,81)warningcue,andasalmon(217,152,
% 158) stimulus.Usingthesecolors,weapproximatedisoluminance
% throughoutthewholetrial,althoughthiswasnotphotometrically
% verified.
% Oliva, Pupil size and search performance in low and high perceptual load
% The resulting colors had the RGB values of 69, 149, 24 for the background
% and 223, 61, 61, for the Config.letters. Under these conditions, the luminance was
% kept constant throughout the experiment at 56 cd/m2.
Config.bgcolor=[69,149,24]; %green %180,167,101]; % TotalLuminance=(0.3*x)+(0.59*y)+(0.11*z)
Config.incorrectcue=[163,93,55]; % yellowish
Config.correctcue=[44,133,173]; % blue
Config.fixationcolor=[223,61,61]; %red
Config.stimuluscolor=[223,61,61]; % red % this fixation cross can be used as a baseline pupil size measure