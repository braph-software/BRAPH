% File to test the use of degree measure of a weighted undirected graph.
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

%% Create a Bindary Directed graph
WUgraph = GraphWU(A);
Adj1 = WUgraph.A;
Adj1(logical(eye(size(Adj1)))) = 0;

%% Counting number of nunzero arrays and calculating degree and average degree
col_sum = zeros(1,N);
row_sum = zeros(1,N);
for i = 1:1:N
    col_sum(i) = length(find(nonzeros(Adj1(:,i))));
    row_sum(i) = length(find(nonzeros(Adj1(i,:))));
end
avg_deg = mean(col_sum);


%% Calculate the degree from Graph
deg = WUgraph.degree();
avdg =  WUgraph.measure(Graph.DEGREEAV);

if isequal(deg,col_sum) && isequal(deg,row_sum)
    disp('Weigthed undirected degree calculated correctly')
else
    errordlg('Weigthed undirected degree NOT correct')
end

if isequal(avg_deg,avdg)
    disp('Weigthed undirected average degree calculated correctly')
else
    errordlg('Weigthed undirected average degree NOT correct')
end