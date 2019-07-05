% File to test the use of PETSubject.
%
% See also PETSubject.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all;
clear all;
clc;

%% Create a PET Subject

sub = PETSubject( ...
    PETSubject.CODE,'SUB1', ...
    PETSubject.AGE,75, ...
    PETSubject.GENDER,PETSubject.GENDER_FEMALE, ...
    PETSubject.DATA,[1 2 3 4], ...
    PETSubject.NOTES,'none');

%% get subject properties

TAGS = sub.getTags()  % get tags
FORMATS = sub.getFormats()  % get formats
DEFAULTS = sub.getDefaults()  % get defaults
OPTIONS = sub.getOptions(PETSubject.GENDER)  % get options
