function age = getSubjectAge

%Show subject age input dialogue:
dialogueTitle = 'Subject age & gender';
dialoguePrompt = 'Age & Gender:';
options.WindowStyle = 'modal';
inputId = strtrim(inputdlg(dialoguePrompt, dialogueTitle, 1));


  age = sprintf(inputId{1});

end