% File to test the use of distance of a weighted undirected graph.
%
% See also Graph, GraphWU.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Creating Adjacency Matrix
N = 5; % number of nodes
L = [0 10 2 2.5 0; 10 0 5 2 0; 2 5 0 2.5 0; 2.5 2 2.5 0 0];
ind = L~=0;
L(ind) = L(ind).^-1;
A = [L;zeros(1,N)];
graph1 = GraphWU(A);
%% Show the graph
figure('Position',[300 150 500 500],'Color','w')
R = 10;
theta = [0:2*pi/N:2*pi-2*pi/N];
x = R*cos(theta);
y = R*sin(theta);
hold on
plot(x,y,'.r','MarkerSize',40)
W = num2cell(A);
for i = 1:1:N
    AA = char('A'+i-1);
    if sign(x(1,i))<1
        text(x(1,i)+2*sign(x(1,i)), y(1,i)+.5*sign(y(1,i)), AA,'Interpreter','latex','FontSize',20)
    else
        text(x(1,i)+sign(x(1,i)), y(1,i)+.5*sign(y(1,i)), AA,'Interpreter','latex','FontSize',20)
    end
    for j = i:1:N
        if sign(x(1,i))<1
            text(x(1,i)+2*sign(x(1,i)), y(1,i)+.5*sign(y(1,i)), AA,'Interpreter','latex','FontSize',20)
        else
            text(x(1,i)+sign(x(1,i)), y(1,i)+.5*sign(y(1,i)), AA,'Interpreter','latex','FontSize',20)
        end
        
        if A(i,j)~=0
            line([x(1,i),x(1,j)],[y(1,i),y(1,j)],'Color','k','LineWidth',3);
            text(mean([x(1,i) x(1,j)])+sign(x(1,i)), mean([y(1,i) y(1,j)])-.5*sign(y(1,i)),...
                W(i,j),'Interpreter','latex','FontSize',10)
        end
    end
end
axis off
axes('Units','Pixels','Position',[0 00 500 500])

axis([-100 100 -100 100])
axis off

D1 = graph1.distance();
showD1 = sym(D1);
pretty(showD1);