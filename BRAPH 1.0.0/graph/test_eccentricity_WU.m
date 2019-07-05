% File to test the use of eccentricity measure of a weighted undirected graph.
%
% See also Graph, GraphWU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Weigthed graphs (Directed)
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
graph1 = GraphWU(A);

%% Calculate the distance
D1 = graph1.distance();
D1(D1==Inf) = NaN;

% Calculate the maximum of the distances
col_max1 = nanmax(D1,[],1);
row_max1 = nanmax(D1,[],2)';

% Calculate the eccentricities from graph
ecc1 = graph1.eccentricity();

if isequal(col_max1,ecc1) && isequal(row_max1,ecc1)
    disp('Weigthed undirected and undirected eccentricity calculated correctly')
else
    errordlg('Weigthed undirected and undirected eccentricity NOT correct')
end