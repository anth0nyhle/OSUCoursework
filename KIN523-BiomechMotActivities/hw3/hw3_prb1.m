% Created by: Anthony Le
% Last updated: 02.06.2018

% KIN 523: Homework 3 - Signal Processing
% Due: 02.06.2018
%% Problem 1
close all;
clear;

% part a
f_c = 5; % in Hz; cut-off freq
f_s = 60; % in frames/s; sampling freq
T = 1 / f_s; % in s per frame; sampling period

Omega_C = tan(pi * (f_c / f_s)) / 0.802;

a_0 = (Omega_C^2) / (1 + sqrt(2) * Omega_C + Omega_C^2);
a_1 = 2 * a_0;
a_2 = a_0;

b_1 = (2 * (1 - Omega_C^2)) / (1 + sqrt(2) * Omega_C + Omega_C^2);
b_2 = 1 - (a_0 + a_1 + a_2 + b_1);

% part b
k = linspace(24, 28, 5);
X_kT = [559.65; 569.50; 589.97; 610.15; 626.80];
% X_kT_back = flipud(X_kT); % flipped the X_kT vector for backpropagation
Y1_kT = [538.17; 547.19]; % two data points before missing data
Y2_kT = [629.36; 608.56]; % two data points after missing data

% forwards filtering
for i = 3:5
    y1_kT = a_0 * X_kT(i) + a_1 * X_kT(i-1) + a_2 * X_kT(i-2) + b_1 * Y1_kT(i-1) + b_2 * Y1_kT(i-2);
    Y1_kT = cat(1, Y1_kT, y1_kT);
end

Y1_kT_back = flipud(Y1_kT); % flipped the Y1_kT vector for backpropagation

% backwards filtering
for j = 3:5
    y2_kT = a_0 * Y1_kT_back(j) + a_1 * Y1_kT_back(j-1) + a_2 * Y1_kT_back(j-2) + b_1 * Y2_kT(j-1) + b_2 * Y2_kT(j-2);
    Y2_kT = cat(1, Y2_kT, y2_kT);
end

Y2_kT = flipud(Y2_kT); % reverse order back to original