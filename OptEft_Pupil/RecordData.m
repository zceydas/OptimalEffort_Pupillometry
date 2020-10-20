function [OptEftNums,OptEft]=RecordData(OptEftNums,OptEft,Numbers, trial,level,string1,accuracy,RT,Time0,time6,time7,time8,time9,time10,time11)

if isempty(str2num(string1)) == 0 
    answer=str2num(string1);
else % if the participant did not enter a number
    answer=999;
end

OptEftNums{trial,1}=Numbers;
OptEft(trial,1)=trial;
OptEft(trial,2)=level(trial);
OptEft(trial,3)=sum(Numbers);
OptEft(trial,4)=answer;
OptEft(trial,5)=accuracy(trial);
OptEft(trial,6)=RT;
% onsets for each event
OptEft(trial,7)=Time0; % experiment begin time
OptEft(trial,9)=time6; % PUPILOMETRY fixation cross before anticipation 
OptEft(trial,10)=time7; % PUPILOMETRY onset of anticipation
OptEft(trial,11)=time8; % PUPILOMETRY onset of fixation after anticipation
OptEft(trial,12)=time9; % question onset
OptEft(trial,13)=time10; % question end
OptEft(trial,13)=time11; % PUPILOMETRY feedback onset
end