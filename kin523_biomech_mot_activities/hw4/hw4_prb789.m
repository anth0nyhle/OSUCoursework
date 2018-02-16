% Created by: Anthony Le
% Last updated: 02.15.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.18
%% Problem 7, 8, 9
close all;
clear;

load('prb3_results.mat');
load('prb4_results.mat');

frame = footAng_time(:, 1);
time = footAng_time(:, 2);
foot_ang = footAng_time(:, 3);
leg_ang = legAng_time(:, 3);
delta_t = 0.0083;

leg_ang = 90 - leg_ang;

% problem 7
ankle_ang = -((leg_ang + foot_ang) - 90);

ankleAng_time = horzcat(frame, time, ankle_ang);

% problem 8a
peak_dorflex = max(ankle_ang);

% problem 8b
peak_plantflex = min(ankle_ang);

% problem 8c
ankle_ROM = peak_dorflex - peak_plantflex;

figure(1);
plot(time, ankle_ang);
xlabel('Time (s)');
ylabel('Ankle Angle (deg)');
title('Ankle Angle over Time');

% problem 9
OMEGA = [];

for i = 2:length(time)-1
    omega = (ankle_ang(i+1) - ankle_ang(i-1)) / (2 * delta_t);
    OMEGA = cat(1, OMEGA, omega);
end

OMEGA = [0; OMEGA; 0];

ang_vec = horzcat(frame, time, OMEGA);

% problem 9a
[peak_dorflex_vec, indx_pdf_v] = max(OMEGA);

% problem 9b
[peak_plantflex_vec, indx_ppf_v] = min(OMEGA);

figure(2);
plot(time, OMEGA);
xlabel('Time (s)');
ylabel('Angular Velocity (deg-s^{-1})');
title('Angular Velocity of Ankle over Time');
hold on;
plot(time(indx_pdf_v, 1), OMEGA(indx_pdf_v, 1), 'o');
plot(time(indx_ppf_v, 1), OMEGA(indx_ppf_v, 1), 'o');
text(time(indx_pdf_v, 1), OMEGA(indx_pdf_v, 1), 'peak ankle dorsiflexion velocity \rightarrow');
text(time(indx_ppf_v, 1), OMEGA(indx_ppf_v, 1), '\leftarrow peak ankle plantarflexion velocity');
xlim([0 2.3904]);