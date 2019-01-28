% Created by: Anthony H. Le
% Last updated: 01-28-2019

% CHE 581: Assignment 2
% Textbook Problems 3.1, 3.2, 3.5, 3.9, 3.12, 3.13, 5.1, 5.7, 5.13
% Due: 02-01-2019
%% Problem 5.1
close all; % close all figures
clear; % clear workspace
clc; % clear command window

m = 95; % kg
vel = 46; % m/s
t = 9; % s
g = 9.81; % m/s^2
x_l = 0.2; % initial lower bound
x_u = 0.5; % initial upper bound
iter = 0; % iteration

while (1)
    x_rnew = (x_u - x_l) / 2;
    eps = abs((x_rnew - x_rold) / x_rnew) * 100;
    f_cd1 = freefall_f(m, vel, t, g, x_l);
    f_cd2 = freefall_f(m, vel, t, g, x_rnew);
    if f_cd1 * f_cd2 > 0
        x_l = x_rnew; % root in upper interval
    else
        x_u = x_rnew; % root in lower interval
    end
    output = [iter x_l x_u x_rnew eps];
    iter = iter + 1;
    x_rold = x_rnew;
    if eps <= 5; break; end
end

disp('-------------------------------------------------');

%% Problem 5.7
close all;
clear;
clc;



disp('-------------------------------------------------');

%% Problem 5.13
close all;
clear;
clc;



disp('-------------------------------------------------');
