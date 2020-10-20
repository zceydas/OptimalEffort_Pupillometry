%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Config,letterperm]=SetParameters(); % experimental parameters such as duration
%%% gaze stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[pms]=SetGazeParameters();
st = dbstack;
namestr = st.name;
directory=fileparts(which([namestr, '.m']));
cd(directory)
addpath(directory) % set path to necessary files
addpath(fullfile(directory,'PsychtoolNeces'))
addpath(fullfile(directory,'Pupil codes')) % pupilometry related codes are here
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
    %pms.portHandle=IOPort('OpenSerialport', pms.myPort, sprintf(' BaudRate=%i',pms.baudrate));
end

Eyelink('Stoprecording')
Screen('CloseAll');
clear all;