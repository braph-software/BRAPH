% File to test the use of path length and characteristic path length measures of a binary undirected graph.
%
% See also Graph, GraphBU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create the Graph and Measures the path length
N = 6; % number of nodes
A = rand(N);
threshold = 0.5;
graph = GraphBU(A,'threshold',threshold);
pth = graph.pl();
cpth = graph.measure(Graph.CPL);

%% Compute path length
D = graph.distance();
pathlength = zeros(1,N);
for i = 1:1:N
    D(i,i) = inf;
    sum = 0;
    nodenum = length(nonzeros(D(i,:)~=inf));
    for j = 1:1:N
        if D(i,j)~=inf
            sum = sum+D(i,j);
        end
    end
    pathlength(i) = sum/nodenum;
end
cpathlength = mean(pathlength);

if isequaln(pth,pathlength)
    disp('Bindary undirected path length calculated correctly')
else
    errordlg('Bindary undirected path length NOT correct')
end

if isequaln(cpth,cpathlength)
    disp('Bindary undirected characteristic path length calculated correctly')
else
    errordlg('Bindary undirected characteristic path length NOT correct')
end