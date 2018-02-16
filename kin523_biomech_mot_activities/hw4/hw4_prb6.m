% Created by: Anthony Le
% Last updated: 02.14.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.18
%% Problem 6
close all;
clear;

load('prb3_results.mat');

frame = footAng_time(:, 1);
time = footAng_time(:, 2);
foot_ang = footAng_time(:, 3);
delta_t = 0.0083;

ALPHA = [];

for i = 2:length(time)-1
    alpha = (foot_ang(i+1) - 2 * foot_ang(i) + foot_ang(i-1)) / ((delta_t)^2);
    ALPHA = cat(1, ALPHA, alpha);
end

ALPHA = [0; ALPHA; 0];

ang_acc = horzcat(frame, time, ALPHA);

figure(1);
plot(time, ALPHA);
xlabel('Time (s)');
ylabel('Angular Acceleration (deg-s^{-2})');
title('Angular Acceletration of Foot Segment over Time');
xlim([0 2.3904]);