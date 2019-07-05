% File to test the use of distance of a weighted directed graph.
%
% See also Graph, GraphWD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

N = 5; % number of nodes
L = [0 10 2 2.5 0; 1.25 0 0 0 0; 2 5 0 2.5 0; 1.25 10 0 0 0];
ind = L~=0;
L(ind) = L(ind).^-1;
A = [L;zeros(1,N)];
%% Show the graph
figure('Position',[300 150 500 500],'Color','w')
R = 10;
theta = [0:2*pi/N:2*pi-2*pi/N];
x = R*cos(theta);
y = R*sin(theta);
hold on
plot(x,y,'.r','MarkerSize',40)
for i = 1:1:N
    for j = 1:1:N
        if A(i,j)~=0
            [X,Y,Z] = arrow3d(x(1,i),y(1,i),0,x(1,j),y(1,j),0,'HeadLength',2,'HeadWidth',0.5);
            surf(X,Y,Z,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
        else
        end
    end
end
axis off

axes('Units','Pixels','Position',[0 00 500 500])
hold on
text(60, 10, 'A','Interpreter','latex','FontSize',30)
text(0, 92, 'B','Interpreter','latex','FontSize',30)
text(-80, 65, 'C','Interpreter','latex','FontSize',30)
text(-80, -40, 'D','Interpreter','latex','FontSize',30)
text(0, -84, 'E','Interpreter','latex','FontSize',30)

text(20, 75, '0.1','Interpreter','latex','FontSize',20)
text(-45, 50, '0.5','Interpreter','latex','FontSize',20)
text(-45, -45, '0.4','Interpreter','latex','FontSize',20)

text(45, 30, '0.8','Interpreter','latex','FontSize',20)

text(17, 25, '0.5','Interpreter','latex','FontSize',20)
text(-22, 82, '0.2','Interpreter','latex','FontSize',20)
text(-60, -10, '0.4','Interpreter','latex','FontSize',20)

text(30, -10, '0.8','Interpreter','latex','FontSize',20)
text(0, 60, '0.1','Interpreter','latex','FontSize',20)

axis([-100 100 -100 100])
axis off

graph2 = GraphWD(A);
[a,b,c] = graph2.distance();
disp('In-distance node A relative to other nodes:')
disp(a(1,:))