function id = getSubjectId

% Show subject id input dialogue:
dialogueTitle = 'Subject ID';
dialoguePrompt = 'Give me a subject id:';
options.WindowStyle = 'modal';
inputId = strtrim(inputdlg(dialoguePrompt, dialogueTitle, 1));

% Check validity of subject id. If input is invalid, set subject id to
% default value (999):
if ~isempty(inputId)
  id = str2double(inputId{1});
  if ~(~isnan(id) && id > 0 && rem(id, 1) == 0)
    response = questdlg(...
      {'Invalid input!'; 'Set subjet id to 999 (default value). Do you accept?'}', ...
      'Warning', 'OK', 'Cancel', 'OK');
    if strcmp(response, 'OK')
      id = 999;
    else
      id = -1;
    end
  end
end