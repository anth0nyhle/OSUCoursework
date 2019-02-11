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

sig_x = 1;
sig_y = 1;
f_xy = @(x, y, sig_x, sig_y) (1 / (2 * pi * sig_x * sig_y)) * exp(-(x^2 / (2 * sig_x^2)) - (y^2 / (2 * sig_y^2)));

ax_1 = -1;
bx_1 = 1;
ay_1 = -1;
by_1 = 1;
I_1 = ;

ax_2 = -2;
bx_2 = 2;
ay_2 = -2;
by_2 = 2;
I_2 = ;

ax_3 = -3;
bx_3 = 3;
ay_3 = -3;
by_3 = 3;
I_3 = ;

disp('-------------------------------------------------');