% Created by: Anthony Le
% Last updated: 02.22.2018

% KIN 523: Homework 5 - 3D Kinematics & Anthropometry
% Due: 02.22.18
%% Problem 4
close all;
clear;

load('Jump.mat');

f_s = 120;
delta_t = 1 / f_s;

time = [];
for i = 1:length(frame)
    t = frame(i) * delta_t;
    time = cat(1, time, t);
end

ANK = [ANK_X, ANK_Y];
HEE = [HEE_X, HEE_Y];
TOE = [TOE_X, TOE_Y];
HEE_tp = HEE'; % transposed
TOE_tp = TOE'; % transposed
HEE_TOE = [(TOE_X - HEE_X), (TOE_Y - HEE_Y)]; % heel to toe vec for each frame
HEE_TOE_tp = HEE_TOE';

% part a
l_FOOT = 0.254;
FOOT_CoM = [];

for i = 1:length(frame)
    unit_vec = (1 / sqrt(HEE_TOE(i, 1)^2 + HEE_TOE(i, 2)^2)) .* HEE_TOE_tp(:, i);
    foot_CoM = ((l_FOOT * 0.401) * unit_vec) + HEE_tp(:, i);
    FOOT_CoM = cat(2, FOOT_CoM, foot_CoM);
end

FOOT_CoM = FOOT_CoM';

figure(1);
plot(HEE_X, HEE_Y, '-s');
hold on;
plot(TOE_X, TOE_Y, '->');
plot(ANK_X, ANK_Y, '-o');
plot(FOOT_CoM(:, 1), FOOT_CoM(:, 2), '-x');
legend('Heel Marker', 'Toe Marker', 'Ankle Marker', 'Foot CoM');
xlabel('X Location (m)');
ylabel('Y Location (m)');
title('Marker Trajectories during Jumping Trial');

% part b
ALPHA_X = []; % accel in X direction
ALPHA_Y = []; % accel in Y direction

for i = 2:length(time)-1
    alpha_X = (FOOT_CoM(i+1, 1) - 2 * FOOT_CoM(i, 1) + FOOT_CoM(i-1, 1)) / ((delta_t)^2);
    ALPHA_X = cat(1, ALPHA_X, alpha_X);
end

ALPHA_X = [0; ALPHA_X; 0];

for j = 2:length(time)-1
    alpha_Y = (FOOT_CoM(j+1, 2) - 2 * FOOT_CoM(j, 2) + FOOT_CoM(j-1, 2)) / ((delta_t)^2);
    ALPHA_Y = cat(1, ALPHA_Y, alpha_Y);
end

ALPHA_Y = [0; ALPHA_Y; 0];

Y_accel = horzcat(frame, time, FOOT_CoM, ALPHA_Y);

figure(2);
plot(time, ALPHA_Y);
xlabel('Time (s)');
ylabel('Acceleration of Foot CoM (m s^{-2})');
title('Acceleration of Foot CoM in Global Y Direction during Jumping Trial');