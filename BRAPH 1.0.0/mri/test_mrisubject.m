% File to test the use of MRISubject.
%
% See also MRISubject.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all;
clear all;
clc;

%% Create a MRI Subject

sub = MRISubject( ...
    MRISubject.CODE,'SUB1', ...
    MRISubject.AGE,75, ...
    MRISubject.GENDER,MRISubject.GENDER_FEMALE, ...
    MRISubject.DATA,[1 2 3 4], ...
    MRISubject.NOTES,'none');

%% get subject properties

TAGS = sub.getTags()  % get tags
FORMATS = sub.getFormats()  % get formats
DEFAULTS = sub.getDefaults()  % get defaults
OPTIONS = sub.getOptions(MRISubject.GENDER)  % get options
