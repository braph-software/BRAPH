% File to test the use of triangle measure of a binary undirected graph.
%
% See also Graph, GraphBU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% number of triangles.
N = 5;
A = rand(N);
Threshold = 0.5;
graph = GraphBU(A,'threshold',Threshold);
tr = graph.triangles();
display('triangles around node A equals with:')
disp(tr(1,1))

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
            line([x(1,i),x(1,j)],[y(1,i),y(1,j)],'Color','k','LineWidth',3);
        end
    end
end
axis equal
axis off