% File to test the use of local efficiency measure of a weighted undirected graph.
%
% See also Graph, GraphWU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create Graph and Calculate Local Efficiency
A = [0 0.1 0.2 0.1 0 0 0 0; ...
     0 0 0.5 0 0.1 0 0 0; ...
     0 0 0 0 0.2 0 0 0; ...
     0 0 0.5 0 0.1 0 0 0; ...
     0 0 0 0 0 0.1 0.5 0;...
     0 0 0 0 0 0 0 0.2;...
     0 0 0 0 0 0 0 0.8;...
     0 0 0 0 0 0 0 0];
graph = GraphWU(A);
N = graph.nodenumber();
[a,b] = graph.leff();
disp('local efficiency of nodes:')
disp(b)
disp('local efficiency of graph:')
disp(a)

%% Show the Graph 
x = [-0.5 15 15 15 30 45 45 60];
y = [-1 15 -1 -17 -1 8 -8 -1];
figure('Position',[300 150 500 500],'Color','w')
hold on
plot(x,y,'.r','MarkerSize',40)
W = num2cell(graph.A);
for j = 1:1:N
    AA = char('A'+j-1);
    if sign(x(1,j))<1
        text(x(1,j)+3*sign(x(1,j)), y(1,j)+.5*sign(y(1,j)), AA,'Interpreter','latex','FontSize',20)
    else
        text(x(1,j)+sign(x(1,j)), y(1,j)+.5*sign(y(1,j)), AA,'Interpreter','latex','FontSize',20)
    end
    for i = j:1:N
        if graph.A(i,j)~=0
            line([x(1,i),x(1,j)],[y(1,i),y(1,j)],'Color','k','LineWidth',2);
            text(mean([x(1,i) x(1,j)]), mean([y(1,i) y(1,j)])+3*sign(y(1,i)),...
                W(i,j),'Interpreter','latex','FontSize',10)
        end
    end
end
axis equal
axis off