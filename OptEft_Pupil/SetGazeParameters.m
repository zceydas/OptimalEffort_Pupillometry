function [pms]=SetGazeParameters()
pms.myPort='COM1';
pms.baudrate=115200;
pms.trackGaze=1;
pms.driftCueCol = [10 150 10, 255]; % cue that central fix changes when drifting is indicated (changes into green)
pms.allowedResps.drift = 'left_control';
pms.allowedResps.drift = 'c';
pms.allowedResps.driftOK = 'd';
pms.fixDuration = 0.75; % required fixation duration in seconds before trials initiate
pms.diagTol = 100; % diagonal pixels of tolerance for fixation
pms.driftShift = [0,0]; % how much to adjust [x,y] for pupil drift, updated every trial
pms.driftCueCol = [10 150 10, 255]; % cue that central fix changes when drifting is indicated