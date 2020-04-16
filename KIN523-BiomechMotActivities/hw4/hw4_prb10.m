% Created by: Anthony Le
% Last updated: 02.15.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.18
%% Problem 10
close all;
clear;

load('prb3_results.mat');
load('prb4_results.mat');
load('prb7_results.mat');

frame = footAng_time(:, 1);
time = footAng_time(:, 2);
foot_ang = footAng_time(:, 3);
leg_ang = legAng_time(:, 3);
ankle_ang = ankleAng_time(:, 3);

figure(1);
plot(time, foot_ang);
hold on;
plot(time, ankle_ang, '--');
xlabel('Time (s)');
ylabel('Angle of Foot or Ankle (deg)');
title('Ankle Motion of Foot and Ankle over Time');
legend('Foot', 'Ankle')
plot(time(128, 1), foot_ang(128, 1), 'o');
plot(time(181, 1), foot_ang(181, 1), 'o');
plot(time(128, 1), ankle_ang(128, 1), 'o');
plot(time(181, 1), ankle_ang(181, 1), 'o');
xlim([0 2.3904]);