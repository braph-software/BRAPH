% File to test the use of strength measure of a weighted undirected graph.
%
% See also Graph, GraphWU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Initializations
N = 5; % number of nodes
A = rand(N); % random adjacency matrix

%% Create a Weighted Undirected graph
WUgraph = GraphWU(A);
Adj2 = WUgraph.A;
Adj2(logical(eye(size(Adj2)))) = 0;

%% Calculate the column and row sums and calculates average strength
strength1 = sum(Adj2,1);
strength2 = sum(Adj2,2)';
avg_strength = mean(strength2);

%% Calculate the strenght from Graph
str = WUgraph.strength();
avstrng = WUgraph.measure(Graph.STRENGTHAV);

if isequal(strength1,str) && isequal(strength2,str)
    disp('Weighted undirected strength calculated correctly')
else
    errordlg('Weighted undirected strength NOT correct')
end

if isequal(avg_strength,avstrng)
    disp('Weigthed undirected average strength calculated correctly')
else
    errordlg('Weigthed undirected average strength NOT correct')
end