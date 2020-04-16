% Created by: Anthony Le
% Last updated: 02.12.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.2018
%% Problem 3
close all;
clear;

load('static.mat');
load('jump.mat');

% all trials were recorded @ 120 frames/s 
f_s = 120;
delta_t = 1 / f_s;

time = [];

for i = 1:length(frame_j)
    t = frame_j(i) * 0.0083;
    time = cat(1, time, t);
end

avgx_heel = mean(HEEX_ST);
avgy_heel = mean(HEEY_ST);

avgx_toe = mean(TOEX_ST);
avgy_toe = mean(TOEY_ST);

plot([avgx_heel avgx_toe], [avgy_heel avgy_toe], '-o');
hold on;
for j = 1:length(frame_j)
    plot([HEEX_J(j, 1) TOEX_J(j, 1)], [HEEY_J(j, 1) TOEY_J(j, 1)], '-o');
end
hold off;

% x = avgx_toe - avgx_heel;
% y = avgy_toe - avgy_heel;
% offset_ang = atan2d(y, x);
offset_ang = -(atan2d((avgy_toe - avgy_heel), (avgx_toe - avgx_heel)));

MJ_ANG = [];

for k = 1:length(frame_j)
    mj_ang = -(atan2d((TOEY_J(k, 1) - HEEY_J(k, 1)), (TOEX_J(k, 1) - HEEX_J(k, 1))));
    MJ_ANG = cat(1, MJ_ANG, mj_ang);
end

AJ_ANG = MJ_ANG - offset_ang;

footAng_time = horzcat(frame_j, time, AJ_ANG);

figure(2);
plot(time, AJ_ANG);