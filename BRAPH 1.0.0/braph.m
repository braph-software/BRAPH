% BRAPH - BRain Analysis using graPH theory
%
% This script loads all packages of the BRAPH.
%
% BRAPH packages
%   <a href="matlab:help ">utility</a> - general utility functions
%   <a href="matlab:help stat">stat</a>    - statistical analysis tools
%   <a href="matlab:help graph">graph</a>   - graph analysis tools
%   <a href="matlab:help ds">ds</a>      - data structures
%   <a href="matlab:help init">init</a>   - initial GUI
%   <a href="matlab:help atlas">atlas</a>   - brain atlas
%   <a href="matlab:help mri">mri</a>     - MRI analysis
%   <a href="matlab:help pet">pet</a>     - PET analysis
%   <a href="matlab:help fmri">fmri</a>    - fMRI analysis
%   <a href="matlab:help eeg">eeg</a>     - EEG analysis

%   Author: Mite Mijalkov & Giovanni Volpe
%   Date: 2016/01/01

clc
format long

dir = fileparts(which('braph'));

addpath(dir)
addpath([dir filesep 'utility'])
addpath([dir filesep 'stat'])
addpath([dir filesep 'graph'])
addpath([dir filesep 'ds'])
addpath([dir filesep 'init'])
addpath([dir filesep 'atlas'])
addpath([dir filesep 'mri'])
addpath([dir filesep 'pet'])
addpath([dir filesep 'fmri'])
addpath([dir filesep 'eeg'])

fprintf('\n')
fprintf(['BRAPH ' BNC.VERSION '\n'])
fprintf('BRain Analysis using graPH theory\n')
fprintf([BNC.AUTHORS '\n'])
fprintf([BNC.COPYRIGHT '\n'])
fprintf('\n')
fprintf('loaded <a href="matlab:help utils">utility</a> - general utility functions ...\n')
fprintf('loaded <a href="matlab:help stat">stat</a> - statistical analysis tools ...\n')
fprintf('loaded <a href="matlab:help graph">graph</a> - graph analysis tools ...\n')
fprintf('loaded <a href="matlab:help ds">ds</a> - data structures ...\n')
fprintf('loaded <a href="matlab:help init">init</a> - initial GUI ...\n')
fprintf('loaded <a href="matlab:help atlas">atlas</a> - brain atlas ...\n')
fprintf('loaded <a href="matlab:help mri">mri</a> - MRI analysis ...\n')
fprintf('loaded <a href="matlab:help pet">pet</a> - PET analysis ...\n')
fprintf('loaded <a href="matlab:help fmri">fmri</a> - fMRI analysis ...\n')
fprintf('loaded <a href="matlab:help eeg">eeg</a> - EEG analysis ...\n')
fprintf('\n')

GUIBraph