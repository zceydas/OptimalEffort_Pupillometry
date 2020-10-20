function [el] = EyelinkSetup(startOrStop,param)
%Local function to set up defaults for each Eyelink and start recording.
%Designed to be called before starting each block. Requires previous call
%to EyelinkInitDefaults to work appropriately

if startOrStop==1 %starting up the Eyelink
%             eyelink_dummy_open();
    el=EyelinkInitDefaults(param); %initialize the Eyelink default settings
    
    % Initialize Eyelink connection (real or dummy). The flag '1' requests
    % use of callback function and eye camera image display:
    if ~EyelinkInit([], 1)
        fprintf('Eyelink Init aborted.\n');
        cleanup;
        return;
    end
    
    % Send any additional setup commands to the tracker
    Eyelink('Command','calibration_type = HV5'); % HV5 for simpler alternative
    Eyelink('Command','recording_parse_type = GAZE');
    %perform calls to the Eyelink host to get the correct queued eye data
    Eyelink('Command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT'); %c
    % set link data (used for gaze cursor)
    Eyelink('Command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,FIXUPDATE,INPUT'); %c
    Eyelink('Command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT'); %c
    Eyelink('Command','sample_rate = 1000');
    Eyelink('Command','screen_pixel_coords = 0 0 1920 1080'); %need to fix the resolution input thing here
    Eyelink('Command','file_event_data = GAZE,VELOCITY');
    Eyelink('Command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,FIXUPDATE,INPUT'); %c
    Eyelink('Command','link_event_data = GAZE,VELOCITY');
    Eyelink('Command','saccade_velocity_threshold = 200');
    Eyelink('Command','saccade_motion_threshold = 0.15');
    % do calibration
    EyelinkDoTrackerSetup(el);
    %Eyelink('StartRecording');

    disp('Eyelink up and running!')
    
elseif startOrStop==0 %done with Eyelink for now, shut it down
    
    %reset sampling rate for other experimenter's use and shutdown the Eyelink
    Eyelink('Command','sample_rate = 250');
    Eyelink('Command','calibration_type = HV9');
    disp('....now clearing eyelink! :)');
    Eyelink('Shutdown');
    el=-1;

end

