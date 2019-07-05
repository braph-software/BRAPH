% File to test the use of distance of a binary directed graph.
%
% See also Graph, GraphBD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create the First Graph Type
N = 10; % number of nodes
connect = ones(1,N-1);
A = diag(connect,1);
A(N,1) = 1;
graph1 = GraphBD(A,'threshold',0);

%% Show the graph
figure('Position',[300 150 500 500],'Color','w')
R = 10;
theta = [0:2*pi/N:2*pi-2*pi/N];
x = R*cos(theta);
y = R*sin(theta);
hold on
plot(x,y,'.r','MarkerSize',40)
for i = 1:1:N
    if i==N
        [X,Y,Z] = arrow3d(x(1,end),y(1,end),0,x(1,1),y(1,1),0,'HeadLength',2,'HeadWidth',0.5);
        surf(X,Y,Z,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
    else
        [X,Y,Z] = arrow3d(x(1,i),y(1,i),0,x(1,i+1),y(1,i+1),0,'HeadLength',2,'HeadWidth',0.5);
        surf(X,Y,Z,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
    end
end
axis equal
axis off

D1 = graph1.distance();
showD1 = sym(D1);
pretty(showD1);