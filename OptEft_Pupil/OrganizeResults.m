function [Results]=OrganizeResults(Results,sess,subjectId,session,OptEft,EasyAcc,IntAcc,DifAcc,EndTime,OptEftNums,Inv,PupilData,TestType)
if session == 2  % capacity phase
    Prep=[]; PrepAcc=[]; Prep=[OptEft(:,2) OptEft(:,5)];
    for i=1:length(unique(Prep(:,1)))
        PrepAcc(i,1)=mean(Prep((Prep(:,1)==i),1));
        PrepAcc(i,2)=mean(Prep((Prep(:,1)==i),2));
    end
    % use the capacity phase (session 2) to figure out the difficulty
    % levels needed for the following phases
    [FO G] = fit(PrepAcc(:,1),PrepAcc(:,2),'1/(1+(exp(x)*c))'); %fit a sigmoidal function
    x=[1:length(PrepAcc(:,1))];
    E=[]; I=[]; D=[];
    E=round(fzero(@(x)FO(x)-EasyAcc, 50)); I=round(fzero(@(x)FO(x)-IntAcc, 50)); D=round(fzero(@(x)FO(x)-DifAcc, 50));
    Results.Subject(subjectId).Capacity.EasyLevel =  E;
    Results.Subject(subjectId).Capacity.IntLevel =  I;
    Results.Subject(subjectId).Capacity.DifLevel =  D;
    Results.Subject(subjectId).Capacity.EndDate = EndTime;
    Results.Subject(subjectId).Capacity.Responses = OptEft;
    Results.Subject(subjectId).Capacity.Data = OptEftNums;
else
    Results.Subject(subjectId).(TestType).Session(sess).EndDate = EndTime;
    Results.Subject(subjectId).(TestType).Session(sess).Responses = OptEft;
    Results.Subject(subjectId).(TestType).Session(sess).Data = OptEftNums;
    Results.Subject(subjectId).(TestType).Session(sess).Inventory=Inv;
    Results.Subject(subjectId).(TestType).Session(sess).PupilData=PupilData;
end
end