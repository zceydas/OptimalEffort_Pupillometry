function [resp,onLeft,choiceOnset,choiceRT,onTop,itrack] = showDmTrial(trial,adjDel,offerAmt,exptOnset,pms,datum,prac)

driftShift = pms.driftShift;
% Ensure central fixation before showing trial
fixOn = 0; % continuous amount of time spent fixating on cross
doDrift = 0; % to break out of both loops
fixrect = CenterRectOnPointd([-1, -1, 1, 1]*pms.ground/2,pms.wRect(3)/2,pms.wRect(4)/2);

while fixOn < pms.fixDuration
    sample = getEyelinkData();

    while doDrift % drift correction
        [~, ~, keyCode] = KbCheck([pms.keyboards]);
        if strcmp(pms.allowedResps.driftOK,KbName(keyCode));
            sample = getEyelinkData();
            driftShift = [(pms.wRect(3)/2)-sample(1),(pms.wRect(4)/2)-sample(2)]; %[x,y]
            %report = '***** Drift adjusted! *****';
            %report = sprintf('x = %0.2f, y = %0.2f',driftShift(1),driftShift(2));
            doDrift = 0;
            Screen('FillRect',pms.wid,[pms.bkgd*ones(1,3),255]);
            DrawFormattedText(pms.wid,'+','center','center',pms.textCol); % change its color back to background text color
            Screen('Flip',pms.wid);
        end
    end

    time1 = GetSecs();
    while ((sample(1)+driftShift(1))-pms.wRect(3)/2)^2+((sample(2)+driftShift(2))-pms.wRect(4)/2)^2 < pms.diagTol^2 && fixOn < pms.fixDuration %IsInRect(sample(1),sample(2),fixrect)
        sample = getEyelinkData();
        time2 = GetSecs();
        fixOn = time2 - time1;
    end

    % if not yet met the timelimit and gaze outside target circle
    [~, ~, keyCode] = KbCheck([pms.keyboards]);
    if strcmp(pms.allowedResps.drift,KbName(keyCode));
        %report = '***** The participant indicates drift! *****'
        doDrift = 1;
        Screen('FillRect',pms.wid,[pms.bkgd*ones(1,3),255]);
        DrawFormattedText(pms.wid,'+','center','center',pms.driftCueCol); % change its color
        Screen('Flip',pms.wid);
    end
end

% display the offers
offerOnset = Screen('Flip',pms.wid,[],1);
choiceOnset = offerOnset-exptOnset;

responded = [];
itrack.driftShift = driftShift;
itrack.X = [];
itrack.Y = [];
itrack.Xdrift = [];
itrack.Ydrift = [];
itrack.pSize = [];
itrack.sampleTimes = [];
sampleTime = offerOnset;
while isempty(responded) && (GetSecs() - offerOnset) < pms.chcDuration
    if (strcmp(prac,'g') || strcmp(prac,'p')) && (GetSecs() - sampleTime) >= 0.002
        sample = getEyelinkData();
        x = sample(1); y = sample(2); %get the x and y coordinates of the current eye trace
        p = sample(3); st = sample(4);
        sampleTime = GetSecs();
        itrack.X=[itrack.X;x]; itrack.Y=[itrack.Y;y]; itrack.Xdrift=[itrack.Xdrift;x+driftShift(1)]; itrack.Ydrift=[itrack.Ydrift;y+driftShift(2)]; itrack.pSize=[itrack.pSize;p]; itrack.sampleTimes=[itrack.sampleTimes;st,sampleTime-offerOnset];
    end
end