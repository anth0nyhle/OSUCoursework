% Created by: Anthony Le
% Last updated: 02.14.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.18
%% Problem 5
close all;
clear;

load('static.mat');
load('jump.mat');

% all trials were recorded @ 120 frames/s 
f_s = 120;
delta_t = 1 / f_s;

%%
time = [];

for i = 1:length(frame_j)
    t = frame_j(i) * 0.0083;
    time = cat(1, time, t);
end

%%
avgx_heel = mean(HEEX_ST);
avgy_heel = mean(HEEY_ST);

avgx_toe = mean(TOEX_ST);
avgy_toe = mean(TOEY_ST);

figure(1);
plot([avgx_heel avgx_toe], [avgy_heel avgy_toe], '-o');
hold on;
for j = 1:length(frame_j)
    plot([HEEX_J(j, 1) TOEX_J(j, 1)], [HEEY_J(j, 1) TOEY_J(j, 1)], '-o');
end
hold off;

offset_foot = -(atan2d((avgy_toe - avgy_heel), (avgx_toe - avgx_heel)));

MJ_ANG_foot = [];

for k = 1:length(frame_j)
    mj_ang = -(atan2d((TOEY_J(k, 1) - HEEY_J(k, 1)), (TOEX_J(k, 1) - HEEX_J(k, 1))));
    MJ_ANG_foot = cat(1, MJ_ANG_foot, mj_ang);
end

AJ_ANG_foot = MJ_ANG_foot - offset_foot;

%%
avgx_ank = mean(ANKX_ST);
avgy_ank = mean(ANKY_ST);

avgx_knee = mean(KNEX_ST);
avgy_knee = mean(KNEY_ST);

figure(2);
plot([avgx_ank avgx_knee], [avgy_ank avgy_knee], '-o');
hold on;
for l = 1:length(frame_j)
    plot([ANKX_J(l, 1) KNEX_J(l, 1)], [ANKY_J(l, 1) KNEY_J(l, 1)], '-o');
end
hold off;

offset_leg = atan2d((avgy_knee - avgy_ank), (avgx_knee - avgx_ank));
offset_leg = 90 - offset_leg; 

MJ_ANG_leg = [];

for m = 1:length(frame_j)
    mj_ang = atan2d((KNEY_J(m, 1) - ANKY_J(m, 1)), (KNEX_J(m, 1) - ANKX_J(m, 1)));
    MJ_ANG_leg = cat(1, MJ_ANG_leg, mj_ang);
end

MJ_ANG_leg = 90 - MJ_ANG_leg;
AJ_ANG_leg = MJ_ANG_leg - offset_leg;

%%
table_234 = [frame_j, time, AJ_ANG_foot, AJ_ANG_leg];

figure(3);
plot(time, AJ_ANG_foot, '-');
hold on;
plot(time, AJ_ANG_leg, '--');
plot(time(128, 1), AJ_ANG_foot(128, 1), 'o');
plot(time(128, 1), AJ_ANG_leg(128, 1), 'o');
plot(time(181, 1), AJ_ANG_foot(181, 1), 'o');
plot(time(181, 1), AJ_ANG_leg(181, 1), 'o');
text(time(128, 1), AJ_ANG_foot(128, 1), 'take-off \rightarrow');
text(time(128, 1), AJ_ANG_leg(128, 1), 'take-off \rightarrow');
text(time(181, 1), AJ_ANG_foot(181, 1), '\leftarrow touchdown');
text(time(181, 1), AJ_ANG_leg(181, 1), '\leftarrow touchdown');
legend('Foot', 'Leg');
xlabel('Time (s)');
ylabel('Segment Angle (deg)');
title('Segment Angle of Foot and Leg over Time');
xlim([0 2.3904]);
hold off;