% File to test the use of eccentricity measure of a binary directed graph.
%
% See also Graph, GraphBD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Binary graphs (Directed)
N = 5; % number of nodes
A = rand(N); % random adjacency matrix
threshold = 0.9;
graph1 = GraphBD(A,'threshold',threshold);

%% Calculate the distance
D1 = graph1.distance();
D1(D1==Inf) = NaN;
D1(D1==0) = NaN;

% Calculate the maximum of the distances
col_max1 = max(D1,[],1);
row_max1 = max(D1,[],2)';
ecc_max1 = max(col_max1,row_max1);

% Calculate the eccentricities from graph
[ecc1,eccin1,eccout1] = graph1.eccentricity();

if isequaln(col_max1,eccin1) && isequaln(row_max1,eccout1)...
   && isequaln(ecc_max1,ecc1)
    disp('Bindary directed eccentricity calculated correctly')
else
    errordlg('Bindary directed eccentricity NOT correct')
end