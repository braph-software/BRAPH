% File to test the use of pvalue1 function.
%
% See also pvalue1.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

N = 3;  % number of variables
M = 1e+6;  % number of samples (per variable)

res = randn(1,N);
values = randn(M,N);

p = pvalue1(res,values)