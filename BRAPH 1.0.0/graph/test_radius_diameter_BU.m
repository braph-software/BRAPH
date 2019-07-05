% File to test the use of radius and diameter measures of a binary undirected graph.
%
% See also Graph, GraphBU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Binary graphs (Directed)
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
threshold = 0.7;
graph1 = GraphBU(A,'threshold',threshold);

ecc1 = graph1.eccentricity();

rad_min = min(ecc1);
diam_max = max(ecc1);

rad = graph1.radius();
diam = graph1.diameter();

if isequal(rad_min,rad) && isequal(diam_max,diam)
    disp('Bindary undirected radius and diameter calculated correctly')
else
    errordlg('Bindary undirected radius and diameter NOT correct')
end