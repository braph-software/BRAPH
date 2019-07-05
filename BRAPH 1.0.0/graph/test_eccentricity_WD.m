% File to test the use of eccentricity measure of a weighted directed graph.
%
% See also Graph, GraphWD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Weigthed graphs (Directed)
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
graph1 = GraphWD(A);

%% Calculate the distance
D1 = graph1.distance();
D1(D1==Inf) = NaN;

% Calculate the maximum of the distances
col_max1 = nanmax(D1,[],1);
row_max1 = nanmax(D1,[],2)';
ecc_max1 = max(col_max1,row_max1);

% Calculate the eccentricities from graph
[ecc1,eccin1,eccout1] = graph1.eccentricity();

if isequal(col_max1,eccin1) && isequal(row_max1,eccout1) && isequal(ecc_max1,ecc1)
    disp('Weigthed directed eccentricity calculated correctly')
else
    errordlg('Weigthed directed eccentricity NOT correct')
end