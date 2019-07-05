% File to test the use of global efficiency measure of a weighted directed graph.
%
% See also Graph, GraphWD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create a Bindary Directed graph
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
graph = GraphWD(A);

%% Calculate the column and row sums
D = graph.distance();
inv_D = D.^-1;
inv_D = inv_D-diag(diag(inv_D));
sum_in = nansum(inv_D);
sum_out = nansum(inv_D,2)';
geff_in = sum_in/(N-1);
geff_out = sum_out/(N-1);
geff = mean(0.5*(geff_in+geff_out),1);

%% Calculate the degree from Graph
[g,gin,gout] = graph.geff();

if  isequal(gin,geff_in) && isequal(gout,geff_out) && isequal(g,geff)
    disp('Weighted directed global efficiency calculated correctly')
else
    errordlg('Weighted directed global efficiency NOT correct')
end
