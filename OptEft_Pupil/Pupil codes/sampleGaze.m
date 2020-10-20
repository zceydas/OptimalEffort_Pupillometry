
function [itrack, sampleTime] = sampleGaze(driftShift,onset,duration, varargin)

%this function samples the gaze data every 0.002 sec and writes the output
%to struct itrack (fields: x, y, xdrift, ydrift, pupil size, sample times).
%As input it requires the driftshift, onset of gaze sampling, and the
%duration you want to sample gaze data. 
%
%last update by L Hofmans on March 28, 2018

itrack.driftShift = driftShift;
itrack.X = [];
itrack.Y = [];
itrack.Xdrift = [];
itrack.Ydrift = [];
itrack.pSize = [];
itrack.sampleTimes = [];
sampleTime = onset;

if nargin==3 
    while (GetSecs() - onset) < duration
        if (GetSecs() - sampleTime) >= 0.002
            sample = getEyelinkData();
            x = sample(1); y = sample(2); %get the x and y coordinates of the current eye trace
            p = sample(3); st = sample(4);
            sampleTime = GetSecs();
            itrack.X=[itrack.X;x]; itrack.Y=[itrack.Y;y]; itrack.Xdrift=[itrack.Xdrift;x+driftShift(1)]; itrack.Ydrift=[itrack.Ydrift;y+driftShift(2)]; itrack.pSize=[itrack.pSize;p]; itrack.sampleTimes=[itrack.sampleTimes;st,sampleTime-onset];
        end
    end
end

end 