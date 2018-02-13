% Created by: Anthony Le
% Last updated: 02.12.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.18
%% Problem 4
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

avgx_ank = mean(ANKX_ST);
avgy_ank = mean(ANKY_ST);

avgx_knee = mean(KNEX_ST);
avgy_knee = mean(KNEY_ST);

plot([avgx_ank avgx_knee], [avgy_ank avgy_knee], '-o');
hold on;
for j = 1:length(frame_j)
    plot([ANKX_J(j, 1) KNEX_J(j, 1)], [ANKY_J(j, 1) KNEY_J(j, 1)], '-o');
end
hold off;

offset_ang = atan2d((avgy_knee - avgy_ank), (avgx_knee - avgx_ank));
offset_ang = 90 - offset_ang; 

MJ_ANG = [];

for k = 1:length(frame_j)
    mj_ang = atan2d((KNEY_J(k, 1) - ANKY_J(k, 1)), (KNEX_J(k, 1) - ANKX_J(k, 1)));
    MJ_ANG = cat(1, MJ_ANG, mj_ang);
end

MJ_ANG = 90 - MJ_ANG;
AJ_ANG = MJ_ANG - offset_ang;

FTAng = horzcat(frame_j, time, AJ_ANG);

figure(2);
plot(time, AJ_ANG);