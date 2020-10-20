function [accuracy,time11]=AccuracyFeedback(RT,ResponseDeadline,string1,accuracy,trial,Numbers,display,correctcue,incorrectcue,Time0,centerX,centerY)
if RT >= ResponseDeadline
    accuracy(trial)=8;
elseif isempty(str2num(string1))
    accuracy(trial)=9;
end

% evaluate response accuracy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(str2num(string1)) && accuracy(trial) < 10
    if str2num(string1) == sum(Numbers)
        accuracy(trial)=1;
    else
        accuracy(trial)=0;
    end
elseif accuracy(trial)==8 % if the participant missed the deadline
    string1 = ['88888']; % dummy coded error
elseif accuracy(trial)==9 % if the participant entered a non-numeric value
    string1 = ['99999']; % dummy coded error
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% give performance feedback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('TextSize', display.windowPtr, 45);
Screen('BlendFunction', display.windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA'); % needed to display png transparent background

if accuracy(trial)==1
    [img, map, alphachannel] = imread('CorrectSignColor.png');
    img(:, :, 4) = alphachannel;
    texture2 = Screen('MakeTexture', display.windowPtr, img);
    Screen('DrawTexture', display.windowPtr, texture2, [], [centerX - 50, centerY - 40, centerX + 50, centerY + 60]);
    % DrawFormattedText(display.windowPtr, 'Correct', 'center', 'center', correctcue, [100]);
elseif accuracy(trial)==0
    [img, map, alphachannel] = imread('IncorrectSignColor.png');
    img(:, :, 4) = alphachannel;
    texture2 = Screen('MakeTexture', display.windowPtr, img);
    Screen('DrawTexture', display.windowPtr, texture2, [], [centerX - 50, centerY - 40, centerX + 50, centerY + 60]);
    % DrawFormattedText(display.windowPtr, 'Incorrect', 'center', 'center', incorrectcue, [100]);
elseif accuracy(trial)==9
    DrawFormattedText(display.windowPtr, 'Only enter numeric responses! ', 'center', 'center', incorrectcue, [100]);
    accuracy(trial)=0;
elseif accuracy(trial)==8
[img, map, alphachannel] = imread('Clock.png');
    img(:, :, 4) = alphachannel;
    texture2 = Screen('MakeTexture', display.windowPtr, img);
    Screen('DrawTexture', display.windowPtr, texture2, [], [centerX - 50, centerY - 40, centerX + 50, centerY + 60]);
        accuracy(trial)=0;
end
Screen('Flip',display.windowPtr); time11=GetSecs-Time0;
end