% File to test the use of degree measure of a weighted directed graph.
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


%% Counting number of nunzero arrays.
in_degree = zeros(1,N);
out_degree = zeros(1,N);
for i = 1:1:N
    in_degree(i) = length(find(nonzeros(Adj1(:,i))));
    out_degree(i) = length(find(nonzeros(Adj1(i,:))));
end
avg_indeg = mean(in_degree);
avg_outdeg = mean(out_degree);
avg = avg_indeg+avg_outdeg;

%% Calculate the degree from Graph
[deg,indeg,outdeg] = WDgraph.degree();
inavdg = WDgraph.measure(Graph.IN_DEGREEAV);
outavdg = WDgraph.measure(Graph.OUT_DEGREEAV);
avdg = WDgraph.measure(Graph.DEGREEAV);

if isequal(indeg,in_degree) && isequal(outdeg,out_degree) && isequal(deg, in_degree+out_degree)
    disp('Weigthed directed degree calculated correctly')
else
    errordlg('Weigthed directed degree NOT correct')
end

if isequal(avg_indeg,inavdg) && isequal(avg_outdeg,outavdg) && isequal(avg,avdg)
    disp('Weigthed directed average degree calculated correctly')
else
    errordlg('Weigthed directed average degree NOT correct')
end