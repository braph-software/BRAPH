% File to test the use of cylinder3d.
%
% See also cylinder3d.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

figure
hold on
axis equal

%% cylinder 1
% initial point 1
X1_i = 0.5;
Y1_i = 0.5;
Z1_i = 1;
% final point 1
X1_f = 4;
Y1_f = 4;
Z1_f = 4;

[x1,y1,z1] = cylinder3d(X1_i,Y1_i,Z1_i,X1_f,Y1_f,Z1_f);
cylinder1 = surf(x1,y1,z1)

%% cylinder 2
% initial point 2
X2_i = 0;
Y2_i = 5;
Z2_i = 0;
% final point 2
X2_f = 0;
Y2_f = -3;
Z2_f = -3;

[x2,y2,z2] = cylinder3d(X2_i,Y2_i,Z2_i,X2_f,Y2_f,Z2_f,'R',0.2,'N',50);
cylinder2 = surf(x2,y2,z2,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);