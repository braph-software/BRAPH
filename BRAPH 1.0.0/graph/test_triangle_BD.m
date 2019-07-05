% File to test the use of triangle measure of a binary directed graph.
%
% See also Graph, GraphBD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% number of triangles.
A = [0 0 1 0; 1 0 0 1; 0 1 0 1;0 0 0 0]
Threshold = 0;
graph = GraphBD(A,'threshold',Threshold);
tr = graph.triangles();
N = graph.nodenumber();
display('triangles around node A equals with:')
disp(tr(1,1))
display('triangles around node D equals with:')
disp(tr(1,4))

%% Show the graph
figure('Position',[300 150 500 500],'Color','w')
R = 10;
theta = [0:2*pi/N:2*pi-2*pi/N];
x = R*cos(theta);
y = R*sin(theta);
hold on
plot(x,y,'.r','MarkerSize',40)
for j = 1:1:N
    AA = char('A'+j-1);
    if sign(x(1,j))<1
        text(x(1,j)+3*sign(x(1,j)), y(1,j)+.5*sign(y(1,j)), AA,'Interpreter','latex','FontSize',30)
    else
        text(x(1,j)+sign(x(1,j)), y(1,j)+.5*sign(y(1,j)), AA,'Interpreter','latex','FontSize',30)
    end
    for i = 1:1:N
        if graph.A(i,j)==1
            [X,Y,Z] = arrow3d(x(1,i),y(1,i),0,x(1,j),y(1,j),0,'HeadLength',2,'HeadWidth',0.5);
            surf(X,Y,Z,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
        end
    end
end
axis equal
axis off