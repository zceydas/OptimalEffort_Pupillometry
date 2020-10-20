function [Inv] = EndScreen2(display, rect,session,Config)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% End Screen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Inv=999;
stimuluscolor=[0 0 0] % black font
Screen('TextSize', display.windowPtr, 30);

if session == 3 || session == 4|| session == 5 || session == 1
    %
    position1=999; position2=999; position3=999; position4=999;
    position5=999; position6=999; position7=999; position8=999; position9=999;
    
    DrawFormattedText(display.windowPtr, sprintf('%s\n%s\n%s\n%s\n', ...
        'Respond to the following questions by using your mouse. ', ...
        'Based on your agreement with the statements regarding', ...
        'the last summation block only. Move your mouse to your', ...'
        'rating. Then click with your mouse to move onto the next question.',...
        'Now, press a key to continue.'), 'center', 'center', stimuluscolor, [100],[],[],[1.25]);
    Screen('Flip',display.windowPtr);WaitSecs(.5); KbStrokeWait(Config.Key);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', '+' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); WaitSecs(.5);
    %
    endPoints = {'Disagree', 'Agree'};
    [position1, RespTime1, answer1] = slideScale2(display.windowPtr, sprintf('I would love to solve math questions of that kind.'), rect, endPoints);
    WaitSecs(.2);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', 'Press a key to continue.' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    %
    endPoints = {'Disagree', 'Agree'};
    [position2, RespTime2, answer2] = slideScale2(display.windowPtr, sprintf('I was strongly involved in the task.'), rect, endPoints);
    WaitSecs(.2);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', 'Press a key to continue.' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    %
    endPoints = {'Disagree', 'Agree'};
    [position3, RespTime3, answer3] = slideScale2(display.windowPtr, sprintf('I was thrilled.'), rect, endPoints);
    WaitSecs(.2);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', 'Press a key to continue.' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    %
    endPoints = {'Disagree', 'Agree'};
    [position4, RespTime4, answer4] = slideScale2(display.windowPtr, sprintf('The task was boring.'), rect, endPoints);
    WaitSecs(.2);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', 'Press a key to continue.' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    %
    endPoints = {'Disagree', 'Agree'};
    [position5, RespTime5, answer5] = slideScale2(display.windowPtr, sprintf('I had the necessary skill to solve the calculations successfully.'), rect, endPoints);
    WaitSecs(.2);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', 'Press a key to continue.' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    %
    endPoints = {'Disagree', 'Agree'};
    [position6, RespTime6, answer6] = slideScale2(display.windowPtr, sprintf('Task demands were well matched to my ability.'), rect, endPoints);
    WaitSecs(.2);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', 'Press a key to continue.' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    %
    endPoints = {'Disagree', 'Agree'};
    [position7, RespTime7, answer7] = slideScale2(display.windowPtr, ...
        sprintf('%s\n%s\n%s\n%s\n', ...
        'During the task all thoughts on task-irrelevant issues', ...
        'that I am personally concerned with were extinguished.'), rect, endPoints);
    WaitSecs(.2);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', 'Press a key to continue.' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    %
    endPoints = {'Disagree', 'Agree'};
    [position8, RespTime8, answer8] = slideScale2(display.windowPtr, ...
        sprintf('%s\n%s\n%s\n%s\n', ...
        'During the task my consciousness was completely', ...
        'focused on solving the math calculations.'), rect, endPoints);
    WaitSecs(.2);
    %
    DrawFormattedText(display.windowPtr, sprintf( '%s', 'Press a key to continue.' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); KbStrokeWait(Config.Key);
    endPoints = {'Disagree', 'Agree'};
    [position9, RespTime9, answer9] = slideScale2(display.windowPtr, sprintf('Time passed really quickly.'), rect, endPoints);
    WaitSecs(.2);
    %
    Inv(1,1)=(position1/2+50)/100;
    Inv(1,2)=(position2/2+50)/100;
    Inv(1,3)=(position3/2+50)/100;
    Inv(1,4)=(position4/2+50)/100;
    Inv(1,5)=(position5/2+50)/100;
    Inv(1,6)=(position6/2+50)/100;
    Inv(1,7)=(position7/2+50)/100;
    Inv(1,8)=(position8/2+50)/100;
    Inv(1,9)=(position9/2+50)/100;
    
    DrawFormattedText(display.windowPtr, sprintf( '%s', '+' ), 'center', 'center', stimuluscolor, [100]);
    Screen('Flip',display.windowPtr); WaitSecs(.5);
elseif session == 2
    
    DrawFormattedText(display.windowPtr, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
        'This is the end of the Staircase Phase.', ...
        'For the following 30 minutes, you will perform', ...
        '4 different levels of arithmetic summations.', ...
        '(press a key to continue)'), 'center', 'center', stimuluscolor, [100],[],[],[1.25]);
    Screen('Flip',display.windowPtr);
    WaitSecs(.5); KbStrokeWait(Config.Key);
    
end



end