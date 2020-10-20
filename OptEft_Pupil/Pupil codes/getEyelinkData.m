function [sample] = getEyelinkData()
%% Function to return queried Eyelink data from Eyelink host
%Author: James Wilmott November 2016    
%Designed to return a single eye trace sample as well as the structure of full
%eye trace data. Requires Eyelink connection to be initialized and set up as
%well as calibrated.

eye_used = Eyelink('EyeAvailable');
%eye_used=1; %0 left eye    1; %right eye

%get and return the 
if(Eyelink( 'NewFloatSampleAvailable') >= 0)
    evt=Eyelink('NewestFloatSample');
    xPix = evt.gx(eye_used+1);
    yPix = evt.gy(eye_used+1);
    pa = evt.pa(eye_used+1);
    %pt = DP.scrP2D(xPix,yPix);
    %x = pt(1);
    %y = pt(2);
    time = evt.time;
else
    disp('ERROR: Could not access Eyelink data; no samples available!');
    xPix=-1000;
    yPix=-1000;
    %x = -1000;
    %y = -1000;
    pa = 999;
    time = 0;
end

sample = [xPix,yPix,pa,time]; %return the x and y coordinates of the latest gaze sample in pixels (otherwise use conversion to dva), pupil size, and time


end

