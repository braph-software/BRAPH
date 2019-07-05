% File to test the use of degree measure of a binary undirected graph.
%
% See also Graph, GraphBU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Initializations
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
threshold = 0.5;

%% Create a Bindary Undirected graph
BUgraph = GraphBU(A,'threshold',threshold);
Adj2 = BUgraph.A;
Adj2(logical(eye(size(Adj2)))) = 0;

col_sum = sum(Adj2,1);
row_sum = sum(Adj2,2)';
avg_deg = mean(col_sum);

%% Calculate the degree from Graph
deg = BUgraph.degree();
avdg = BUgraph.measure(Graph.DEGREEAV);

if isequal(col_sum,deg) && isequal(row_sum,deg)
    disp('Bindary undirected degree calculated correctly')
else
    errordlg('Bindary undirected degree NOT correct')
end

if isequal(avg_deg,avdg)
    disp('Bindary undirected average degree calculated correctly')
else
    errordlg('Bindary undirected average degree NOT correct')
end