% Created by: Anthony Le
% Last updated: 02.04.2018

% KIN 523: Homework 3 - Signal Processing
% Due: 02.06.2018
%% Problem 4a
close all;
clear;

load('FilterData.mat');
% Time col vector in s
% LANK col vector in m
% LTOE col vector in m

f_c = 10; % in Hz; cut-off freq
f_s = 120; % in frames/s; sampling freq
T = 1 / f_s; % in s per frame; sampling period

Omega_C = tan(pi * (f_c / f_s)) / 0.802;

a_0 = (Omega_C^2) / (1 + sqrt(2) * Omega_C + Omega_C^2);
a_1 = 2 * a_0;
a_2 = a_0;

b_1 = (2 * (1 - Omega_C^2)) / (1 + sqrt(2) * Omega_C + Omega_C^2);
b_2 = 1 - (a_0 + a_1 + a_2 + b_1);

% part a
X_kT_Toe = LTOE;
Y1_kT_Toe = [0.063026; 0.063019];

for i = 3:289
    y1_kT_toe = a_0 * X_kT_Toe(i) + a_1 * X_kT_Toe(i-1) + a_2 * X_kT_Toe(i-2) + b_1 * Y1_kT_Toe(i-1) + b_2 * Y1_kT_Toe(i-2);
    Y1_kT_Toe = cat(1, Y1_kT_Toe, y1_kT_toe);
end

Y1_kT_Toe_back = flipud(Y1_kT_Toe);
Y2_kT_Toe = [Y1_kT_Toe_back(1, 1); Y1_kT_Toe_back(2, 1)];

for j = 3:289
    y2_kT_toe = a_0 * Y1_kT_Toe_back(j) + a_1 * Y1_kT_Toe_back(j-1) + a_2 * Y1_kT_Toe_back(j-2) + b_1 * Y2_kT_Toe(j-1) + b_2 * Y2_kT_Toe(j-2);
    Y2_kT_Toe = cat(1, Y2_kT_Toe, y2_kT_toe);
end

Y2_kT_Toe = flipud(Y2_kT_Toe);

N = 289;

R_f_c_Toe = sqrt((1 / N) * sum((X_kT_Toe - Y2_kT_Toe).^2));

figure(1)
subplot(2, 1, 1);
plot(Time, X_kT_Toe);
hold on;
plot(Time, Y1_kT_Toe);
plot(Time, Y2_kT_Toe);
hold off;