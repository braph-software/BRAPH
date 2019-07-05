% File to test the use of eccentricity measure of a binary undirected graph.
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

%% Calculate the distance
D1 = graph1.distance();
D1(D1==Inf) = NaN;
D1(D1==0) = NaN;

% Calculate the maximum of the distances
col_max1 = nanmax(D1,[],1);
row_max1 = nanmax(D1,[],2)';

% Calculate the eccentricities from graph
ecc1 = graph1.eccentricity();

if isequaln(col_max1,ecc1) && isequaln(row_max1,ecc1)
    disp('Bindary undirected and undirected eccentricity calculated correctly')
else
    errordlg('Bindary undirected and undirected eccentricity NOT correct')
end