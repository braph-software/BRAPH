% File to test the use of radius and diameter measures of a weighted directed graph.
%
% See also Graph, GraphWD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Binary graphs (Directed)
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
graph1 = GraphWD(A);

[ecc1,eccin1,eccout1] = graph1.eccentricity();

rad_min = min(ecc1);
diam_max = max(ecc1);

rad = graph1.radius();
diam = graph1.diameter();

if isequal(rad_min,rad) && isequal(diam_max,diam)
    disp('Weighted directed radius and diameter calculated correctly')
else
    errordlg('Weighted directed radius and diameter NOT correct')
end