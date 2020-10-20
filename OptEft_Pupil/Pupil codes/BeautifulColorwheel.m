function [data, trial, T,gazedata] = BeautifulColorwheel(varargin)
% Colorhwheel
%
% This function presents the colorwheel task - here: part 1 of the QuantifyingCC study
% The task has 5 phases:
% 1) Encoding phase
% 2) Delay 1 phase
% 3) Interference phase
% 4) Delay 2 phase
% 5) Probe phase
%
% 1) During the encoding phase,participants will see different set sizes (=1-4) of colored squares.
%    The task is to encode (=remember) the colors and locations.
%
% 3) During the interference phase, there are 2 conditions:
%       i) IGNORE (indicated by the letter 'I' in the centre): pps should ignore the new stimuli
%           and still remember the colors/locations presented during ENCODING.
%       ii) UPDATE (indicated by the letter 'U'): pps should overwrite/forget the colors/locations of the ENCDOING,
%           but ONLY remember the latest colors/locations presented during interference phase.
%
% 5) During the probe phase: colorhweel appears and a square.
%       Participants should recall the color that was presented at that location of the square:
%       during the ENCODING (for i) or during the intervening phase (for ii).
%       With a mouse click on the colorwheel, they give a response.
%
% This file calls the following (sub)functions:
%   getInfo
%   defstruct
%   trialstruct
%   getInstructions
%   showTrial

try
    switch nargin
        case 0
    %% Provides subject number and practice status as keyboard input, names of the files and which manipulation should be used. Go into this function to adapt log-file name.
    [subNo,dataFilename,dataFilenamePrelim,practice,manipulation]=getInfo;
        case 3
            subNo=varargin{1};
            practice=varargin{2};
            colordir=varargin{3};
    [subNo,dataFilename,dataFilenamePrelim,practice,manipulation]=getInfo(subNo,practice);            

        case 6
            subNo=varargin{1};
            practice=varargin{2};
            colordir=varargin{3};      
            manipulation=1;
            pms.choiceSZ=varargin{4};
            pms.choiceCondition=varargin{5};
            pms.bonus=varargin{6};
            dataFilename=sprintf('ColorFun_s%d_Redo.mat',subNo);
            dataFilenamePrelim=sprintf('CF_s%d_Redo_pre.mat',subNo);
    end

    %% set experiment parameters
    pms.language='DUTCH';
    pms.myPort='COM1';
    pms.baudrate=115200;
    pms.trackGaze=1;
    pms.numTrials = 32; % adaptable; important to be dividable by 2 (conditions) and multiple of 4 (set size)
    pms.numBlocks = 2;
    pms.Ign1Tr = char(hex2dec('6931'));
    pms.Ign3Tr = char(hex2dec('6933'));
    pms.Upd1Tr = char(hex2dec('7531'));
    pms.Upd3Tr = char(hex2dec('7533'));
    
    pms.numCondi = 2;  % 0 IGNORE, 2 UPDATE
    pms.numTrialsPr=8; %trials for practice
    pms.numBlocksPr=2; %blocks for practice
    pms.redoTrials=24; %trials for Redo
    pms.redoBlocks=1; %blocks for Redo
    pms.setsize=[1 3]; %maximum number of squares used
    
    pms.colorTrials=12; %trials for color naming task
    
    %colors
    pms.numWheelColors=512;
    
    %text
    pms.textColor           = [0 0 0];
    pms.background          = [128,128,128];
    pms.wrapAt              = 65;
    pms.spacing             = 2;
    pms.textSize            = 22;
    pms.textFont            = 'Times New Roman';
    pms.textStyle           = 1; 
    pms.ovalColor           = [0 0 0];
    pms.subNo               = subNo;
    pms.matlabVersion       = 'R2016a';
%     eyelink parameters
    pms.driftCueCol = [10 150 10, 255]; % cue that central fix changes when drifting is indicated (changes into green)
    pms.allowedResps.drift = 'left_control';
    pms.allowedResps.drift = 'c';
    pms.allowedResps.driftOK = 'd';
    pms.fixDuration = 0.75; % required fixation duration in seconds before trials initiate
    pms.diagTol = 100; % diagonal pixels of tolerance for fixation
    % timings
    pms.maxRT = 4; % max RT
    pms.encDuration = 2;    %2 seconds of encoding
    pms.encDurationIgn=2;
    pms.encDurationUpd=2;
    pms.delay1DurationPr = 2; %2 seconds of delay 1 during practice
    pms.delay1DurationUpd=2;
    pms.delay1DurationIgn=2;        
    pms.interfDurationPr = 2; %2 seconds interfering stim during practice
    pms.interfDurationIgn=2;
    pms.interfDurationUpd=2;
    pms.delay2DurationIgnPr = 2; %2 seconds of delay 2 during practice
    pms.delay2DurationUpdPr=6;
    pms.delay2DurationIgn=2;
    pms.delay2DurationUpd=6;
    pms.feedbackDuration=0.5; %feedback during colorwheel
    pms.feedbackDurationPr=1.5;
    pms.jitter = 0;
    pms.iti=0.1;
    pms.signal=0.8;
    pms.driftShift = [0,0]; % how much to adjust [x,y] for pupil drift, updated every trial
    pms.driftCueCol = [10 150 10, 255]; % cue that central fix changes when drifting is indicated
pms.trialDurationIgn=pms.encDurationIgn+pms.delay1DurationIgn+pms.interfDurationIgn+pms.delay2DurationIgn+pms.maxRT+pms.feedbackDuration;
pms.trialDurationUpd=pms.encDurationUpd+pms.delay1DurationUpd+pms.interfDurationUpd+pms.delay2DurationUpd+pms.maxRT+pms.feedbackDuration;

    if exist('colordir','var')
        pms.colordir=colordir;
    else
        pms.colordir=pwd;
    end
    
    % initialize the random number generator
    randSeed = sum(100*clock);
    
    
    %% display and screen
    % bit Added to address problem with high precision timestamping related
    % to graphics card problems
    
    % Screen settings
    Screen('Preference','SkipSyncTests', 1);
    Screen('Preference', 'VBLTimestampingMode', -1);
    Screen('Preference','TextAlphaBlending',0);
    Screen('Preference', 'VisualDebugLevel',0);
    % initialize the random number generator
    randSeed = sum(100*clock);
    delete(instrfind);
    %RandStream.setGlobalStream(RandStream('mt19937ar','seed',randSeed));
    
    HideCursor;
    ListenChar(2);%2: enable listening; but keypress to matlab windows suppressed.
    Priority(1);  % level 0, 1, 2: 1 means high priority of this matlab thread
    
    % open an onscreen window
    [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),pms.background);
    pms.xCenter=rect(3)/2;
    pms.yCenter=rect(4)/2;     
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    if pms.trackGaze
    EyelinkInitDefaults(wPtr);
    end

    
    
    %% get trialstrcutre depending on pms
    %%%%%% prepare trials
    % function to get trialstructure using pms (parameters) as input
    if practice==0
         [trial]=defstruct(pms,rect);
 %if we have already created a trial structure for all participants (like we did for the real task?)
 %then we can instead load trialFin instead and comment out the above line (MF: which line? still true?)
    elseif practice==1
         [trial]= trialstruct(pms,rect,1);   
    elseif practice==2
        [trial]=trialstruct(pms,rect,2);
    end
    %% prepare data for easy export later
    
    % log general subject and session info
    dataHeader.header ='WMcolors';
    dataHeader.randSeed = randSeed;
    dataHeader.sessionTime = fix(clock);
    dataHeader.subjectID = subNo;
    dataHeader.dataName = dataFilename;
    dataHeader.logdir = cd; %adapt logdir (MF: e.g.: fullfile(cd, 'log'))
    dataHeader.manipulation=manipulation;
    
    % initialize data set
    data.setsize=[]; %trial(:,:).setSize;
    data.trialNum=[]; %trial(:,:).number;
    data.trialtype=[]; %trial(:,:).trialType;
    data.location =[]; %trial(:,:).locations;
    data.colors = []; %trial(:,:).colors;
    data.respCoord=[];
    data.onset=[];
    data.rt=[];
    data.probeLocation = [];
    data.stdev=[];
    data.thetaCorrect=[];
    data.respDif = [];
    
    % baseline for event onset timestamps
    exptOnset = GetSecs;
    
    %% Define Text
    Screen('TextSize',wPtr,pms.textSize);
    Screen('TextStyle',wPtr,pms.textStyle);
    Screen('TextFont',wPtr,pms.textFont);
  %% Color vision task
  if practice==1
      if strcmp(pms.language,'DUTCH')
          colorVisionDUTCH(pms,wPtr,rect)
      else
   colorVision(pms,wPtr,rect)
      end
  end
    %% Experiment starts with instructions
    %%%%%%% get instructions
    % show instructions
    if strcmp(pms.language,'DUTCH')
  
          if     practice==1
           getInstructionsDUTCH(1,pms,wPtr);
    elseif practice==0
           getInstructionsDUTCH(2,pms,wPtr);
    elseif practice==2
           getInstructionsDUTCH(5,pms,wPtr);

          end
    else

    if     practice==1
           getInstructions(1,pms,wPtr);
    elseif practice==0
           getInstructions(2,pms,wPtr);
    elseif practice==2
           getInstructions(5,pms,wPtr);

    end
    end
    
    %% Experiment starts with trials
    % stimOnset = Screen(wPtr,'Flip'); CHECK onsets
    % onset = stimOnset-exptOnset;
    % run begins
    
    WaitSecs(1); % initial interval (blank screen)
    %%%%%%
    % showTrial: in this function, the trials are defined and looped
    if strcmp(pms.language,'DUTCH')
  
          if pms.trackGaze && practice==0
    [data, T, gazedata] = showTrialDUTCH(trial, pms,practice,dataFilenamePrelim,wPtr,rect); 
    else
            [data, T] = showTrialDUTCH(trial, pms,practice,dataFilenamePrelim,wPtr,rect); 
          end
    else
    if pms.trackGaze && practice==0
    [data, T, gazedata] = showTrial(trial, pms,practice,dataFilenamePrelim,wPtr,rect); 
    else
            [data, T] = showTrial(trial, pms,practice,dataFilenamePrelim,wPtr,rect); 
    end
    end
        % showTrial opens colorwheel2 and stdev function
    
        
    %% Save the data
    save(fullfile(pms.colordir,dataFilename));
    %% Close-out tasks
    if strcmp(pms.language,'DUTCH')
if practice==0
       getInstructionsDUTCH(4,pms,wPtr)   
    elseif practice==1
       getInstructionsDUTCH(3,pms,wPtr)   
    elseif practice==2
        getInstructionsDUTCH(6,pms,wPtr)
end
    else 
    if practice==0
       getInstructions(4,pms,wPtr)   
    elseif practice==1
       getInstructions(3,pms,wPtr)   
    elseif practice==2
        getInstructions(6,pms,wPtr)
    end
    end
    
   if practice~=1
    clear Screen
    Screen('CloseAll');
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
   end
catch ME
    disp(getReport(ME));
   keyboard
    
    % save data
    save(fullfile(pms.colordir,dataFilename));
    
    % close-out tasks
    Screen('CloseAll'); % close screen
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
    
end %try-catch loop
end % main function



