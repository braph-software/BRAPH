% File to test the use of global efficiency measure of a binary undirected graph.
%
% See also Graph, GraphBU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create a Bindary Directed graph
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
threshold = 0.5;
graph = GraphBU(A,'threshold',threshold);

%% Calculate the column and row sums
D = graph.distance();
inv_D = D.^-1;
inv_D = inv_D-diag(diag(inv_D));
sum = nansum(inv_D);
geff = sum/(N-1);

%% Calculate the degree from Graph
g = graph.geff();

if isequal(g,geff)
    disp('Bindary undirected global efficiency calculated correctly')
else
    errordlg('Bindary undirected global efficiency NOT correct')
end
