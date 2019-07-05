close all
clear all
clc

%% Load Atlas

[file,path,filterindex] = uigetfile(GUI.BAE_EXTENSION,GUI.BAE_MSG_GETFILE);
% load file
if filterindex
    filename = fullfile(path,file);
    tmp = load(filename,'-mat','atlas','selected','BUILT');
    if isa(tmp.atlas,'BrainAtlas')
        atlas = tmp.atlas;
        BUILT = tmp.BUILT;
        
        disp(['Loaded brain atlas ' filename])
    else
        disp('Failed to load brain atlas.')
        return
    end
    clear file path filename filterindex tmp;
else
    disp('Failed to load brain atlas.')
    return
end

%% Load Groups of Subjects

T = input('Repetition time in seconds: ')

cohort = EEGCohort(atlas);
cohort.loadfrommat()
cohort.setProp(EEGCohort.T,T)

while ~exist('stop')
    YN = input('Add new group? (Y/N) ','S');
    
    switch lower(YN)
        
        case 'y'
            cohorttmp = EEGCohort(atlas);
            cohorttmp.loadfrommat()
            % add subjects
            for i = 1:1:cohorttmp.length()
                cohort.add(cohorttmp.get(i))
            end
            % add group
            cohort.addgroup()
            cohort.addtogroup(cohort.groupnumber(),[cohort.length:-1:cohort.length-cohorttmp.length()+1])
            
            gr = cohort.getGroup(cohort.groupnumber());
            gr.setProp(Group.NAME,cohorttmp.getGroup(1).getProp(Group.NAME))
            cohort.disp
        otherwise
            stop = true;
    end
end

%% Save EEGCohort

% select file
[file,path,filterindex] = uiputfile('*.mat');
% save file
if filterindex
    filename = fullfile(path,file);
	save(filename,'cohort');

    disp(['Saved EEG cohort ' filename])
end
