% File to test the use of degree measure of a binary directed graph.
%
% See also Graph, GraphBD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Initializations
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
threshold = 0.5;

%% Create a Bindary Directed graph
BDgraph = GraphBD(A,'threshold',threshold);
Adj1 = BDgraph.A;
Adj1(logical(eye(size(Adj1)))) = 0;

%% Calculate the column and row sums
col_sum = sum(Adj1,1);
row_sum = sum(Adj1,2)';
avg_indeg = mean(col_sum);
avg_outdeg = mean(row_sum);
avg = avg_indeg+avg_outdeg;

%% Calculate the degree from Graph
[deg,indeg,outdeg] = BDgraph.degree();
inavdg = BDgraph.measure(Graph.IN_DEGREEAV);
outavdg = BDgraph.measure(Graph.OUT_DEGREEAV);
avdg = BDgraph.measure(Graph.DEGREEAV);

if isequal(indeg,col_sum) && isequal(outdeg,row_sum) && isequal(deg,col_sum + row_sum)
    disp('Bindary directed degree calculated correctly')
else
    errordlg('Bindary directed degree NOT correct')
end

if isequal(avg_indeg,inavdg) && isequal(avg_outdeg,outavdg) && isequal(avg,avdg)
    disp('Bindary directed average degree calculated correctly')
else
    errordlg('Bindary directed average degree NOT correct')
end