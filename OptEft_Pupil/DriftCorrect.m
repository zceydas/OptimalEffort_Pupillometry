function [driftShift]=DriftCorrect(rect,Config,pms,display)

fixOn = 0; % continuous amount of time spent fixating on cross
doDrift = 0; % to break out of both loops
fixDur = 2;
while fixOn < fixDur
    sample = getEyelinkData();
    
    while doDrift % drift correction
        [keyIsDown,TimeStamp,keyCode] = KbCheck;
        if keyIsDown && (keyCode(Config.spacebar))
            sample = getEyelinkData();
            driftShift = [(rect(3)/2)-sample(1),(rect(4)/2)-sample(2)]; %[x,y]
            %report = '***** Drift adjusted! *****';
            %report = sprintf('x = %0.2f, y = %0.2f',driftShift(1),driftShift(2));
            doDrift = 0;
            Screen('FillRect', display.windowPtr, Config.bgcolor) % change the background color based on session
            DrawFormattedText(display.windowPtr, sprintf( '%s', '+' ), 'center', 'center', Config.fixationcolor, [100]);
            Screen('Flip',display.windowPtr);
        end
    end
    
    time1 = GetSecs();
    while ((sample(1)+driftShift(1))-rect(3)/2)^2+((sample(2)+driftShift(2))-rect(4)/2)^2 < pms.diagTol^2 && fixOn < fixDur %IsInRect(sample(1),sample(2),fixrect)
        sample = getEyelinkData();
        time2 = GetSecs();
        fixOn = time2 - time1;
    end
    
    % if not yet met the timelimit and gaze outside target circle
    [keyIsDown,TimeStamp,keyCode] = KbCheck;
    if keyIsDown && (keyCode(Config.spacebar))
        %report = '***** The participant indicates drift! *****'
        doDrift = 1;
        Screen('FillRect', display.windowPtr, Config.bgcolor) % change the background color based on session
        DrawFormattedText(display.windowPtr, sprintf( '%s', '+' ), 'center', 'center', Config.fixationcolor, [100]);
        Screen('Flip',display.windowPtr);
    end
end