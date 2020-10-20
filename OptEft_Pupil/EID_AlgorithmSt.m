function [level,CountNo,RandomPick,finishgame] = EID_AlgorithmSt(subjectId, session, trial, Results,TaskLevel,CountNo,level,accuracy,RandomPick)

finishgame =0; 
NoQuestions=5; % number of questions to ask at each level
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Staircase algorithm and difficulty set %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if session == 3 || session == 4 || session == 5
    
    
    level(trial) = TaskLevel;
    
else
    
    if trial == 1
        
        if session == 1 || session == 2 % if it's the capacity session or the training session
            
            level(trial) = 1; CountNo(trial) = 1;  % if it is the first trial, it should always be the first diffuculty level
            
            
        elseif session == 'S' % if the participant is already done with their training session (staircase algorithm)
            
            % compute the average difficulty level played in the last
            % quarter of their training session and start from that
            % difficulty level
            
            if isnan(Results.Subject(subjectId).Capacity.MeanLevel);
                level=1;
            else
                level(trial) = Results.Subject(subjectId).Capacity.MeanLevel;
            end
            
            CountNo(trial) = 1;
            
        end
        
    elseif trial > 1 % if the trial number is greater than 1, then 2 things can happen
        
        if session == 1 % if it is the training session, only use the easiest difficulty level
            
            level(trial) = 1; CountNo(trial) = 1;
            
        elseif session == 2
            
            % determine the next trial level by increasing difficulty level if the last
            % two out of two trials were correctly answered. Reduce difficulty level if
            % the last two out of two trials were incorrectly answered.
            
            if CountNo(trial-1) < NoQuestions
                
                level(trial) = level(trial-1); CountNo(trial)=CountNo(trial-1)+1;  % if the last 7 trial level has been presented only once, then repeat it on the next trial
                
            elseif CountNo(trial-1) > NoQuestions-1 % if the last 8 trials were of the same level
                
                if mean(accuracy(trial-NoQuestions:trial-1)) > 0 % check if  last 8 trials were answered with more than 0% accuracy
                    
                    level(trial) = level(trial-1) +1; CountNo(trial) =1;
                    
                else % check if  last four trials were all answered incorrectly
                    
                finishgame = 1;
                
                level = 999;
                CountNo=999;
                RandomPick=999;

                end
            end
            
        end
        
    end
    
end
end