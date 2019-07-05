% File to test the use of triangle measure of a weighted undirected graph.
%
% See also Graph, GraphWU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Number of triangles.
N = 4;
A = rand(N);
graph = GraphWU(A);
tr = graph.triangles();
B = graph.A;
B = B-diag(diag(B));
%% Calculating number of triangles.
triang = zeros(1,N);
for i = 1:1:N;
    for j = 1:1:N
        if i~=j
            for k = 1:1:N
               if i~=k && j~=k
                   triang(i) = triang(i)+(B(i,j)^(1/3)*B(i,k)^(1/3)*B(k,j)^(1/3));
               end
            end
        end
    end
    triang(i) = 0.5*triang(i);
end

if isequal(round(triang,10,'significant'),round(tr,10,'significant'))
    disp('Weighted undirected triangles calculated correctly')
else
    errordlg('Weighted undirected triangles NOT correct')
end