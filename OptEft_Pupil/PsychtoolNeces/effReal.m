function [MaxCorValue,CorTable] = effReal(raw,GenerateITIs,S)




for i=1:299
    
 % the ITIs come without NULL events having a row, so first we want to
 % create a row for them, that takes the value of a 0. Thus, both the
 % duration and the name of the condition take 0
    if raw(i,1)>0  && raw(i+1,1)==0
        
    elseif raw(i,1)==0  && raw(i+1,1)>0
        
    else
        
        raw=vertcat(raw(1:i,:), [0 0], raw(i+1:end,:)); % simply separate rows and plug 0 between
       
        
    end
  
    
end


% 
% meanITI=mean(raw(find(raw(:,1)==0),2)); %in order to make sure that the mean ITI obtained from optseq is 2, check mean ITI
% 
% ITIs=vertcat(raw(find(raw(:,2)<10),2), [0] ) % since there are 149 (trial-1) ITIs in total, add one 0 at the end to equate the number of rows across vectors
% 
% CondITI=[raw(find(raw(:,1)>0),1) ITIs]; % CondITI refers to each non-NULL condition that receives an ITI in between trials
% 
% 
% for i=1:15
% 
% AllITIsbyCond(:,i)=CondITI(find(CondITI(:,1)==i),2);
% 
% 
% end %check the distribution of ITIs per condition
% 
pureITIs=raw(find(raw(:,2)<10),2) % obtain the pure distribution of ITIs obtained from the optseq (this means getting rid of the 0 at the end which I plugged in previously to equate vector sizes)
% 
% 
% AdITIs=vertcat(2,pureITIs); % add an additional 2 at the end so that the mean of this vector stays the same, but the size of the vector is increased by 1, since we need as many ISIs as there are trials but there were trial-1 ITIs - read above
% for i=1:100000
%     
%     idx = randperm(length(AdITIs));
%     xperm = AdITIs(idx);
%     GenerateITIs(:,i)=xperm; % GenerateITIs is a matrix of shuffled ITIs -these are our ISIs
%     
% end

ExecuteLength=9.6+2.4; % the total duration of the execution phase including the fixations (2.4 total)
SelectDuration=3;
%Only=Both(find(Both(:,1)>0),2);
%Only=vertcat(0,Only);
FixCross = 2.4;
 
load('/Users/zceydas/Dropbox/Research/SwiCoNov2/fMRI related/USE THIS STUFF/ExecuteDurs.mat')

for i=1:S
    
    Version(i).Table(:,1)=raw(find(raw(:,1)>0),1); %condition number
    Version(i).Table(:,2)=pureITIs; %the ITI that comes before the Select phase, so the first trial is 0
    
    for k=1:150
        
        if k==1
            Version(i).Table(k,3)= 0 ; %on the first trial, the selection phase begins at time 0
        else
            Version(i).Table(k,3) = Version(i).Table(k,2)+ Version(i).Table(k-1,5) + Subject(i).Pairs(Version(i).Table(k-1,1)).Values(1,end) %+ FixCross ; %when the select phase begins: when the previous execution phase began + the duration of the execution phase + the fixation cross + ITI
            
            Subject(i).Pairs(Version(i).Table(k-1,1)).Values(1,:)=[];
        end
        
        Version(i).Table(k,4) = GenerateITIs(k,1); %the ISI between Select and Execution Phase
        
        Version(i).Table(k,5) = Version(i).Table(k,3) + Version(i).Table(k,4) + SelectDuration; %when the execution phase begins:when the selection phase begins + the duration of the selection phase + ISI between the select and execution phase
        
        
    end
    
   %column titles
   % 1) Condition number 
   % 2) The ITI between the previous trial execution phase and the Selection Phase on the current trial - so no ITI for
   %    the first trial
   % 3) Start Selection Phase (The experiment starts with the Selection
   %    Phase - thus the first trial is time 0)
   % 4) ISI that follows the Selection Phase
   % 5) Start Execution Phase
   
   Output =[];
   Output = Version(i).Table;
%    filename = sprintf('%s_%d','Output',i);
%    fid = fopen(filename, 'wt'); % Open for writing
%    for j=1:size(Output,1)
%        fprintf(fid, '%g\t%g\t%g\t%g\t%g\n', Output(j,:));
%        fprintf(fid, '\n');
%    end
%    fclose(fid);

  
    
end

save Table Version 

save Backup Version 

NamesSelect=['CondA'
'CondB'
'CondC'
'CondD'
'CondE'
'CondF'
'CondG'
'CondH'
'CondI'
'CondK'
'CondL'
'CondM'
'CondN'
'CondO'
'CondP'];

NamesExecute=['CondAE'
'CondBE'
'CondCE'
'CondDE'
'CondEE'
'CondFE'
'CondGE'
'CondHE'
'CondIE'
'CondKE'
'CondLE'
'CondME'
'CondNE'
'CondOE'
'CondPE'];

load('/Users/zceydas/Dropbox/Research/SwiCoNov2/fMRI related/USE THIS STUFF/ExecuteDurs.mat')
 
 allConds=1:30;
 combos = combntns(allConds,2);
 
for d=1:S
 
UpdateTRs = round((SubjectExecute(d)+(2.4*150)+(2*149)+(3*150)+(2*150))/2)+1; %update here based on the excel for condition specific durations
 
 
data=[];
%filename = sprintf('%s_%d','Output',d); 
 

%data = csvread(filename);
%AllData(d).Values=data; 
data=Version(d).Table;
data(:,2)=[]; 
data(:,3)=[];
 
% folderfilename = sprintf('%s_%d','SPMOutput',d); mkdir(folderfilename);
% cd(folderfilename);

matlabbatch=[];
matlabbatch{1}.spm.stats.fmri_design.dir = {pwd}; 
matlabbatch{1}.spm.stats.fmri_design.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_design.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_design.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_design.timing.fmri_t0 = 8;
matlabbatch{1}.spm.stats.fmri_design.sess.nscan = UpdateTRs; 
CounterJ(1,1:15)=0;
count=0;
for i=1:15
    count=count+1;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).name = NamesSelect(i,:);
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).onset = [data(find(data(:,1)==i),2)];
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).duration = 3;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).orth = 1;
    count=count+1;
    CounterJ(1,i)=CounterJ(1,i)+1;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).name = NamesExecute(i,:);
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).onset = [data(find(data(:,1)==i),3)];
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).duration = Subject(d).Pairs(i).Values(CounterJ(i),end);
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(count).orth = 1;
    
end

matlabbatch{1}.spm.stats.fmri_design.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_design.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_design.sess.multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_design.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_design.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_design.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_design.volt = 1;
matlabbatch{1}.spm.stats.fmri_design.global = 'None';
matlabbatch{1}.spm.stats.fmri_design.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_design.cvi = 'AR(1)';

spm_jobman('run',matlabbatch);
load('SPM.mat')

for i=1:length(combos)
CorTable(d,i)=corr(SPM.xX.X(:,combos(i,1)),SPM.xX.X(:,combos(i,2)));
end


delete('SPM.mat')


%delete(filename);
end


CorTableT=CorTable';

MaxCorValue=max(CorTableT);

save Table 


end