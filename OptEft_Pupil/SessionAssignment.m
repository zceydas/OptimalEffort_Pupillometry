function [sessionName,TestType,TaskL,TaskLevel]=SessionAssignment(session,letterlist)
TaskL = 99; TaskLevel=99;sessionName=99;TestType=99;
 if session == 3
        sessionName = letterlist(1);
        TestType= 'EasyTest';
        TaskL='EasyLevel';
    elseif session == 4
        sessionName = letterlist(2);
        TestType='IntermediateTest';
        TaskL='IntLevel';
    elseif session == 5
        sessionName = letterlist(3);
        TestType='DifficultTest';
        TaskL='DifLevel';
    elseif session == 1
        sessionName = letterlist(4);
        TestType='PracticeTest';
        TaskLevel = 1;
 end
end