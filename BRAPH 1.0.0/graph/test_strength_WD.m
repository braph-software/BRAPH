% File to test the use of strength measure of a weighted directed graph.
%
% See also Graph, GraphWD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Initializations
N = 5; % number of nodes
A = rand(N); % random adjacency matrix

%% Create a Weighted Directed graph
WDgraph = GraphWD(A);
Adj1 = WDgraph.A;
Adj1(logical(eye(size(Adj1)))) = 0;

%% Calculate the column and row sums and calculates average strength
col_sum = sum(Adj1,1);
row_sum = sum(Adj1,2)';
avg_instrength = mean(col_sum);
avg_outstrength = mean(row_sum);
avg = avg_instrength+avg_outstrength;

%% Calculate the strenght from Graph
[str,instr,outstr] = WDgraph.strength();
inavstrng = WDgraph.measure(Graph.IN_STRENGTHAV);
outavstrng = WDgraph.measure(Graph.OUT_STRENGTHAV);
avstrng = WDgraph.measure(Graph.STRENGTHAV);

if isequal(instr,col_sum) && isequal(outstr,row_sum) && isequal(str,col_sum + row_sum)
    disp('Weighted directed strength calculated correctly')
else
    errordlg('Weighted directed strength NOT correct')
end

if isequal(avg_instrength,inavstrng) && isequal(avg_outstrength,outavstrng) && isequal(round(avg...
        ,10,'significant'),round(avstrng,10,'significant'))
    disp('Weigthed directed average strength calculated correctly')
else
    errordlg('Weigthed directed average strength NOT correct')
end