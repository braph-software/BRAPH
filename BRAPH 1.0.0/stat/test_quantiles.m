% File to test the use of quantiles function.
%
% See also quantiles.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

N = 3;  % number of variables
M = 1e+6;  % number of samples (per variable)
values = randn(M,N);

P = 100;
p = quantiles(values,P)