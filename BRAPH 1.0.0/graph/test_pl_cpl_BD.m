% File to test the use of path length and characteristic path length measures of a binary directed graph.
%
% See also Graph, GraphBD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create the Graph and Measures the path length
N = 6; % number of nodes
A = rand(N);
threshold = 0.5;
graph = GraphBD(A,'threshold',threshold);
[pth,pth_in,pth_out] = graph.pl();
cpth = graph.measure(Graph.CPL);
in_cpth = graph.measure(Graph.IN_CPL);
out_cpth = graph.measure(Graph.OUT_CPL);

%% Compute path length
D = graph.distance();
pin = zeros(1,N);
pout = zeros(1,N);
p = zeros(1,N);
for i = 1:1:N
    D(i,i) = inf;
    sumin = 0;
    sumout = 0;
    nodeout = length(nonzeros(D(i,:)~=inf));
    nodein = length(nonzeros(D(:,i)~=inf));
    for j = 1:1:N
        if D(i,j)~=inf
            sumout = sumout+D(i,j);
        end
        
        if D(j,i)~=inf
            sumin = sumin+D(j,i);
        end
    end
    pin(i) = sumin/nodein;
    pout(i) = sumout/nodeout;
    p(i) = mean([pin(i) pout(i)]);
end
cpin = mean(pin);
cpout = mean(pout);
cp = mean(p);

if isequaln(pth_in,pin) && isequaln(pth_out,pout) && isequaln(pth,p)
    disp('Bindary directed path length calculated correctly')
else
    errordlg('Bindary directed path length NOT correct')
end

if isequaln(in_cpth,cpin) && isequaln(out_cpth,cpout) && isequaln(cpth,cp)
    disp('Bindary directed characteristic path length calculated correctly')
else
    errordlg('Bindary directed characteristic path length NOT correct')
end