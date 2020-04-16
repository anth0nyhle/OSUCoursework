% Created by: Anthony Le
% Last updated: 02.15.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.18
%% Problem 11
close all;
clear;

load('prb7_results.mat');
load('kneeang.mat'); % knee_ang

frame = ankleAng_time(:, 1);
time = ankleAng_time(:, 2);
ankle_ang = ankleAng_time(:, 3);

figure(1);
plot_dir(knee_ang, ankle_ang);
xlabel('Knee Angle (deg)');
ylabel('Ankle Angle (deg)');
title('Angle-Angle Diagram of Knee and Ankle over Time');
text(knee_ang(128, 1), ankle_ang(128, 1), 'take-off \rightarrow');
text(knee_ang(181, 1), ankle_ang(181, 1), '\leftarrow touchdown');
hold on;
plot(knee_ang(128, 1), ankle_ang(128, 1), 'o');
plot(knee_ang(181, 1), ankle_ang(181, 1), 'o');

figure(2);
plot(time, knee_ang);
hold on;
plot(time, ankle_ang);
legend('Knee Angle', 'Ankle Angle');