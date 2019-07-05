% File to test the use of distance of a binary undirected graph.
%
% See also Graph, GraphBU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create the First Graph Type
N = 6; % number of nodes
A = [0 1 0 0 0 1; 1 0 1 0 0 0; 0 1 0 0 1 0; 0 0 0 0 0 1;0 0 1 0 0 0;1 0 0 1 0 0];
graph1 = GraphBU(A,'threshold',0.6);

%% Show the graph
figure('Position',[300 150 500 500],'Color','w')
R = 10;
theta = [pi/4:2*pi/(N-2):2*pi];
x = R*cos(theta);
x = [2*R x -2*R];
y = R*sin(theta);
y = [0 y 0];
hold on
plot(x,y,'.r','MarkerSize',40)

for j = 1:1:N
    for i = 1:1:N
        if graph1.A(i,j)==1
            line([x(1,i),x(1,j)],[y(1,i),y(1,j)],'Color','k','LineWidth',3);
        end
    end
end
axis equal
axis off

D1 = graph1.distance();
showD1 = sym(D1(1,:));
disp('Shortest path length of node A to every node equals with:')
pretty(showD1);

text(2*R+1, 0, 'A','Interpreter','latex','FontSize',20)
text(R*cos(pi/4)+1, R*sin(pi/4)+1, 'B','Interpreter','latex','FontSize',20)
text(R*cos(3*pi/4)-2, R*sin(3*pi/4)+2, 'C','Interpreter','latex','FontSize',20)
text(R*cos(5*pi/4)-2, R*sin(5*pi/4)-2, 'D','Interpreter','latex','FontSize',20)
text(R*cos(7*pi/4)+1, R*sin(7*pi/4)-1, 'E','Interpreter','latex','FontSize',20)
text(-2*R-3, 0, 'F','Interpreter','latex','FontSize',20)