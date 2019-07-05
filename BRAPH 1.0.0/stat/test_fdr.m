% File to test the use of fdr function.
%
% See also fdr.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

pvalues = abs(.05*randn(1,100));
q = .05;

fdr(pvalues,q)