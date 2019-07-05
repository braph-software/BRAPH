% File to test the use of participation measure of a binary directed graph.
%
% See also Graph, GraphBD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create Graph and Calculate P articipation
A = [0 1 0 1 0 0 0 0;...
     0 0 1 0 1 0 0 0;...
     1 0 0 0 1 0 0 0;...
     0 0 1 0 1 0 0 0;...
     0 0 0 0 0 1 1 0;...
     0 0 0 0 0 0 0 1;...
     0 0 0 0 0 0 0 1;...
     0 0 0 0 0 0 0 0];
graph = GraphBD(A,'threshold',0);
N = graph.nodenumber();
b = graph.participation();
disp('participation of nodes:')
disp(b)

%% Show the Graph 
x = [-1 15 15 15 30 45 45 60];
y = [0 15 0 -15 0 8 -8 0];
figure('Position',[300 150 500 500],'Color','w')
hold on
plot(x,y,'.r','MarkerSize',40)
for j = 1:1:N
    AA = char('A'+j-1);
    if sign(x(1,j))<1
        text(x(1,j)+3*sign(x(1,j)), y(1,j)+.5*sign(y(1,j)), AA,'Interpreter','latex','FontSize',20)
    else
        text(x(1,j)+sign(x(1,j)), y(1,j)+.5*sign(y(1,j)), AA,'Interpreter','latex','FontSize',20)
    end
    for i = 1:1:N
        if A(i,j)==1
            [X,Y,Z] = arrow3d(x(1,i),y(1,i),0,x(1,j),y(1,j),0,'HeadLength',2,'HeadWidth',0.5);
            surf(X,Y,Z,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
        end
    end
end
axis equal
axis off