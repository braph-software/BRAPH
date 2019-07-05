% File to test the use of global efficiency measure of a weighted undirected graph.
%
% See also Graph, GraphWU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create a Bindary Directed graph
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
graph = GraphWU(A);

%% Calculate the column and row sums
D = graph.distance();
inv_D = D.^-1;
inv_D = inv_D-diag(diag(inv_D));
sum = nansum(inv_D);
geff = sum/(N-1);

%% Calculate the degree from Graph
g = graph.geff();

if  isequal(g,geff)
    disp('Weighted undirected global efficiency calculated correctly')
else
    errordlg('Weighted undirected global efficiency NOT correct')
end