% Before you record any data, you have to initialize the Eyelink with the
% parameters you want to use (including details about how to perform a
% calibration
EyelinkInitDefaults(pms.wid); % here pms.wid refers to the window you've opened
pms.el = EyelinkSetup(1,pms); % here pms are just parameters for my particular task
% note that the only parameter I use in EyelinkSetup is the pointer for my
% window; Also note that EyelinkSetup contains a commands to run the
% calibration rountine itself

% once you've set up Eyelink, you can start recording at any point in the
% script you like:
Eyelink('StartRecording')

% you can sample data from the Eyelink, using MATLAB (if you want to save
% data locally in your .mat data file
sample = getEyelinkData();
x = sample(1); y = sample(2); %get the x and y coordinates of the current eye trace
p = sample(3); st = sample(4);

% When you're done recording you can stop the Eyelink system and reset your
% configuration parameters
Eyelink('Stoprecording')
pms.el = EyelinkSetup(0,pms);

% During my task, participants must look at a central fixation cross for 1
% sec for the trial to proceed. Since the calibration for gaze location
% might drift over time, I've built in a drift calibration routine using
% while loops to ask whether Participants are looking at a specified
% location. They can press a spacebar (coded in param.allowedResps.drift)
% if they think they are and the trial isn't starting. That toggles into a
% second "drift correction" while loop that allows the experimenter to
% press 'd' for "drift correction" (param.allowedResos.driftOK) when they
% are satisfied that the participant is looking at the center of the
% screen, and this sets a value pair called "driftShift" which subsequently
% adjusts all future X,Y value pairs collected from the Eyelink. note that
% wRect is just the monitor window rectangle, wid, is the window ID
% pointer, parm.bkgd is a rectangle in which I want stimuli to be
% displayed.

% Ensure central fixation before showing trial
if strcmp(prac,'g') || strcmp(prac,'p')
    Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
    DrawFormattedText(param.wid,'+','center','center',param.textCol);
    vbl = Screen('Flip',param.wid); % Flip and get timestamp
    waitframes = 1;
    
    fixOn = 0; % continuous amount of time spent fixating on cross
    doDrift = 0; % to break out of both loops
    fixrect = CenterRectOnPointd([-1, -1, 1, 1]*param.ground/2,param.wRect(3)/2,param.wRect(4)/2);
    
    while fixOn < param.fixDuration
        sample = getEyelinkData();
        
        while doDrift % drift correction
            [~, ~, keyCode] = KbCheck([param.keyboards]);
            if strcmp(param.allowedResps.driftOK,KbName(keyCode));
                sample = getEyelinkData();
                driftShift = [(param.wRect(3)/2)-sample(1),(param.wRect(4)/2)-sample(2)]; %[x,y]
                %report = '***** Drift adjusted! *****';
                %report = sprintf('x = %0.2f, y = %0.2f',driftShift(1),driftShift(2));
                doDrift = 0;
                Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
                DrawFormattedText(param.wid,'+','center','center',param.textCol); % change its color back to background text color
                Screen('Flip',param.wid);
            end
        end
        
        time1 = GetSecs();
        while ((sample(1)+driftShift(1))-param.wRect(3)/2)^2+((sample(2)+driftShift(2))-param.wRect(4)/2)^2 < param.diagTol^2 && fixOn < param.fixDuration %IsInRect(sample(1),sample(2),fixrect)
            sample = getEyelinkData();
            time2 = GetSecs();
            fixOn = time2 - time1;
        end
        
        % if not yet met the timelimit and gaze outside target circle
        [~, ~, keyCode] = KbCheck([param.keyboards]);
        if strcmp(param.allowedResps.drift,KbName(keyCode));
            %report = '***** The participant indicates drift! *****'
            doDrift = 1;
            Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
            DrawFormattedText(param.wid,'+','center','center',param.driftCueCol); % change its color
            Screen('Flip',param.wid);
        end
    end
end