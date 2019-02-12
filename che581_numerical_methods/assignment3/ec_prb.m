% Created by: Anthony H. Le
% Last updated: 02-11-2019

% CHE 581: Assignment 3
% Extra Credit Problem
% Due: 02-11-2019
%% Extra Credit
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Extra Credit')

n = 4;
% sig_x = 1;
% sig_y = 1;
f_xy = @(x, y) (1 / (2 * pi * 1 * 1)) * exp(-(x^2 / (2 * 1^2)) - (y^2 / (2 * 1^2)));
f_xy1 = @(x, y) (1 / (2 * pi * 1 * 1)) * exp(-(x.^2 / (2 * 1^2)) - (y.^2 / (2 * 1^2)));

ax_1 = -1;
bx_1 = 1;
ay_1 = -1;
by_1 = 1;
I_1 = twoDtrap(f_xy, ax_1, bx_1, ay_1, by_1, n);
% I = integral2(f_xy1, ax_1, bx_1, ay_1, by_1);
fprintf('I_1 = %5.4f\n', I_1);

ax_2 = -2;
bx_2 = 2;
ay_2 = -2;
by_2 = 2;
I_2 = twoDtrap(f_xy, ax_2, bx_2, ay_2, by_2, n);
I = integral2(f_xy1, ax_2, bx_2, ay_2, by_2);
fprintf('I_2 = %5.4f\n', I_2);

ax_3 = -3;
bx_3 = 3;
ay_3 = -3;
by_3 = 3;
I_3 = twoDtrap(f_xy, ax_3, bx_3, ay_3, by_3, n);
fprintf('I_3 = %5.4f\n', I_3);

disp('-------------------------------------------------');
