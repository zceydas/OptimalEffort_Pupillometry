function [Results]=Wrapper()
% This script was written on August 25, 2020 @ DCCN
% The task is based on the Marie Curie proposal 2019.
% The task starts with the Capacity Phase.
% Every subject ID needs to have completed the Capacity Phase before
% task levels can be assigned.
% Capacity phase ends when all last 5 questions of the same level
% has been answered incorrectly.
% Capacity results are interpolated by a sigmoidal function.
% In the Performance phase, based on each participant's capacity,
% Simple, Easy, Intermediate, Difficult tasks are assigned.
% During the cue period, during the fixation crosses and the accuracy
% screens, we measure pupil dilation.
%
% FirstSession variable stands for the session number to initate the task
% from. The first session is always the capacity session, however, if
% some subject ID entered the capacity phase before, and you'd like to
% start from the 2nd session (task levels), you can do so.
clear all
codeversion = 'Pupilometry_OptEft';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Randomize Number Generators
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cccc = clock;
s = RandStream('mt19937ar','Seed',cccc (6));
turns = randi(s,100);
for i = 1:turns
    randsample(10,5);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Set Directory %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st = dbstack;
namestr = st.name;
directory=fileparts(which([namestr, '.m']));
cd(directory)
addpath(directory) % set path to necessary files
addpath(fullfile(directory,'PsychtoolNeces'))
addpath(fullfile(directory,'Pupil codes')) % pupilometry related codes are here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Set Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Config,letterperm]=SetParameters(); % experimental parameters such as duration
%%% gaze stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[pms]=SetGazeParameters();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Subject info %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subjectId=input('What is subject ID? ');
pupil=input('Are you recording pupil size (0/1)? ');
FirstSession=input('Which session to start from? (1 for Capacity, else for rest): ');
letterlist=letterperm(mod(subjectId,length(letterperm))+1,:);
Config.OrderList=Config.OrderList(mod(subjectId,length(Config.OrderList))+1,:); %
Config.OrderList=[2 Config.OrderList]; %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Setup Screen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PsychDebugWindowConfiguration(0,0.5); % transparrent setting for debugging
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
display.dist = 60;  %cm
display.width = 39; %cm
[myScreen, rect] = Screen('OpenWindow', 0);
display = OpenWindow(display);
Priority(MaxPriority(0));
HideCursor;	% Hide the mouse cursor
centerX = display.resolution(1)/2;
centerY = display.resolution(2)/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Start Experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CountNo=[]; level=[]; accuracy=[]; RandomPick=[];
tic % report experimental duration starting from here
Time0=GetSecs;
for olist = FirstSession:length(Config.OrderList)
    beginTime = datestr(now);
    load OptimalEffort
    session=Config.OrderList(olist);
    [sessionName,TestType,TaskL,TaskLevel]=SessionAssignment(session,letterlist);
    %%%% Categorize sessions under Capacity, Simple, Easy, Intermediate,
    %%%% Difficult task epochs
    if session == 2 % first training session with the easiest task (level 1)
        sessionName = 2; % dummy variable
        Results.Subject(subjectId).ID = subjectId;
        Results.Subject(subjectId).Capacity.BeginDate = beginTime;
        Results.Subject(subjectId).OrderList = Config.OrderList; % condition order in time
        Results.Subject(subjectId).CodeVersion=codeversion;
        Results.Subject(subjectId).LetterList = letterlist; % easy, intermediate, difficult and practice session Config.letters
        TaskLevel = 1; % dummy variable
        TestType='Capacity';
    else
        if isfield(Results.Subject(subjectId),(TestType)) && ~isempty(Results.Subject(subjectId).(TestType)) % if never entered this session, start anew
            sess=length(Results.Subject(subjectId).(TestType).Session)+1;
        else
            sess=1;
        end
        Results.Subject(subjectId).(TestType).Session(sess).BeginDate = beginTime;
        if session>1
            TaskLevel=Results.Subject(subjectId).Capacity.(TaskL);
        end
    end
    %%%%%%%%%%%% Session specific parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % total task duration should be under 1 hr
    if session == 2; ExperimentDuration = Config.CapacityDur*60 ; % not really 30 minutes, this is so that the experiment stops when the participant is at most 60% accurate
    else; ExperimentDuration = Config.ExpDur*60 ; end % experimental duration, 3 minutes, as in Ulrich
    %%%%%%%%%%%% Instruction Screen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    PupilometryInstScreen(olist,session, sessionName, display,Config)
    if session ~= 2 && pupil == 1 % Calibrate in the beginning of each block
        %%% gaze stuff %%%
        if pms.trackGaze
            EyelinkInitDefaults(display.windowPtr);
        end
        if pms.trackGaze
            % KbStrokeWait
            %     [pktdata, treceived] = IOPort('Read', myport, 1, 1);
            % IOPort('ConfigureSerialPort')
            driftShift = pms.driftShift;
            pms.el = EyelinkSetup(1,display.windowPtr);
            Eyelink('StartRecording')
            Screen('Flip',display.windowPtr)
            if olist == 2
                pms.portHandle=IOPort('OpenSerialport', pms.myPort, sprintf(' BaudRate=%i',pms.baudrate));
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%% Begin Experiments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    accuracy=[]; trial=0; OptEft=[]; OptEftNums=[]; PupilData=[];
    ExperimentStart = GetSecs;
    finishgame=0;
    while GetSecs < ExperimentStart + ExperimentDuration
        Screen('TextSize', display.windowPtr, 45);
        trial = trial + 1;
        if trial == 1
            ITI = 8; % set ITI mean above, and jitter arround it
        else
            if ITI < 2  % if the remainin ITI is smaller than 2 seconds, make it 2 seconds for pupil recovery time
                ITI = 2;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%% Staircase algorithm and difficulty set %%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [level,CountNo,RandomPick,finishgame] = EID_AlgorithmSt(subjectId, session, trial, Results,TaskLevel,CountNo,level,accuracy,RandomPick);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % generate numbers based on difficulty level
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % pick two digit numbers for the first summands. If the level is an odd
        % number, then divide it by 2 and then add one. That means, even number
        % levels will have as many 2 digit numbers to sum as their level number
        % minus one. If it's an odd number level, then also add a one digit number
        % as the last summand
        if finishgame == 0 % capacity phase will end when the finishgame == 1, meaning all 8 questions of the same level has been answered incorrectly
            if session == 1
                Numbers=[Config.OneDigitRange(randi(length(Config.OneDigitRange),1,1)) Config.OneDigitRange(randi(length(Config.OneDigitRange),1,1))];
            else
                Numbers=[Config.TwoDigitRange(randi(length(Config.TwoDigitRange),floor(level(trial)/2)+1,1)) Config.OneDigitRange(randi(length(Config.OneDigitRange),mod(level(trial),2),1))];
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%% Stimulus presentation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            time6=999; time7=999; time8=999; time9=999; time10=999; time11=999;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % print fixation cross before number presentation
            Screen('FillRect', display.windowPtr, Config.bgcolor) % change the background color based on session
            DrawFormattedText(display.windowPtr, sprintf( '%s', '+' ), 'center', 'center', Config.fixationcolor, [100]);
            Screen('Flip',display.windowPtr); time6=GetSecs-Time0; % fixation start
            % put DriftCorrect function here -->
            % [driftShift]=DriftCorrect(rect,Config,pms,display);
            if session ~= 2 && pupil == 1
                %%% gaze stuff %%%
                [itrack_encoding] = sampleGaze(driftShift,GetSecs,ITI);
                PupilData(trial).FirstFix=itrack_encoding;
            else
                WaitSecs(ITI);
            end
            % PRINT TASK CUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if session ~= 2
                DrawFormattedText(display.windowPtr, sprintf( '%s', sessionName ), 'center', 'center', Config.stimuluscolor, [100]);
                Screen('Flip',display.windowPtr); time7=GetSecs-Time0; % anticipation start
                if pupil == 1
                    %%% gaze stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [itrack_encoding] = sampleGaze(driftShift,GetSecs,Config.CueDur);
                    PupilData(trial).Cue=itrack_encoding;
                else
                    WaitSecs(Config.CueDur);
                end
            end
            if session ~= 2
                % FIXATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                DrawFormattedText(display.windowPtr, sprintf( '%s', '+' ), 'center', 'center', Config.fixationcolor, [100]);
                Screen('Flip',display.windowPtr); time8=GetSecs-Time0; %fixation start
                if pupil == 1
                    %%% gaze stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [itrack_encoding] = sampleGaze(driftShift,GetSecs,Config.SecFixDur);
                    PupilData(trial).SecondFix=itrack_encoding;
                else
                    WaitSecs(Config.SecFixDur);
                end
            end
            % print question %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ds=[];
            for n=1:length(Numbers)-1
                ds=['%d + ' ds];
            end
            ds=[ds '%d ='];
            Screen('FillRect', display.windowPtr, Config.bgcolor);
            DrawFormattedText(display.windowPtr, sprintf(ds, Numbers), 'center', 'center', Config.stimuluscolor, [100]);
            time9=GetSecs-Time0; %question start
            % get free response %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Start=GetSecs; accuracy(trial) = 0;
            string1='empty';
            string1 = GetEchoString(display.windowPtr, 'ANSWER:', centerX-285, centerY+75, Config.stimuluscolor, 100,1,Config.Key,Start + Config.ResponseDeadline);%
            Screen('Flip',display.windowPtr);
            End=GetSecs; time10=GetSecs-Time0; %question end
            RT=[];RT=End-Start;
            % Evaluate and display response accuracy %%%%%%%%%%%%%%%%%%%%%%
            [accuracy,time11]=AccuracyFeedback(RT,Config.ResponseDeadline,string1,accuracy,trial,Numbers,display,Config.correctcue,Config.incorrectcue,Time0,centerX,centerY);
            %%% gaze stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if session ~= 2 && pupil == 1
                [itrack_encoding] = sampleGaze(driftShift,GetSecs,Config.FeedbackDur);
                PupilData(trial).Feedback=itrack_encoding;
            else
                WaitSecs(Config.FeedbackDur);
            end
            FeedbackEnd=GetSecs;
            TotalTaskTime=FeedbackEnd-Start;
            %%%%%%%%%% Determine ITI duration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if session == 2; ITI = 2 +rand;
            else ITI = Config.ResponseDeadline + Config.FeedbackDur - TotalTaskTime + 3; end
            % record data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [OptEftNums,OptEft]=RecordData(OptEftNums,OptEft,Numbers, trial,level,string1,accuracy,RT,Time0,time6,time7,time8,time9,time10,time11);            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ITI in experimental blocks should total to total deadline time
            if session ~= 2
                if trial == Config.NoTrials % the last trial
                    DrawFormattedText(display.windowPtr, sprintf( '%s', '+' ), 'center', 'center', Config.fixationcolor, [100]);
                    Screen('Flip',display.windowPtr);
                    if pupil == 1
                        %%% gaze stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [itrack_encoding] = sampleGaze(driftShift,GetSecs,ITI);
                        PupilData(trial).LastFix=itrack_encoding;
                    else
                        WaitSecs(ITI);
                    end
                    break
                end
            end
        else
            break
        end
    end
    % inventory answers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Inv] = EndScreen2(display, rect,session,Config);
    % save data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    EndTime = datestr(now);
    if session == 2; sess=99;
    else
    end
    [Results]=OrganizeResults(Results,sess,subjectId,session,OptEft,Config.EasyAcc,Config.IntAcc,Config.DifAcc,EndTime,OptEftNums,Inv,PupilData,TestType);
    save OptimalEffort Results
    % end the experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if olist == length(Config.OrderList)
        Screen('TextSize', display.windowPtr, 30);
        DrawFormattedText(display.windowPtr, sprintf('%s\n%s\n%s\n%s', ...
            'Thank you for your participation!'), 'center', 'center', [0 0 0], [100]);
        Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    end
end
Eyelink('Stoprecording')
Screen('CloseAll');
toc
ListenChar(0);
ShowCursor;

