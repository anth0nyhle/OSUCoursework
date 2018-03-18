% Created by: Anthony Le
% Last udpated: 03.17.2018

% KIN 523: Homework 8 - Work, Power, Energy, and Force Estimation
% Due: 03.16.18
%%
close all;
clear;

load('HW8_Data.mat');

f_s = 120;
delta_t = 1 / f_s;
time = frame .* delta_t;

% Problem 1
% W_ANK = degtorad(W_ANK);
W_ANK = -(W_ANK .* (pi / 180)); % in rad/s; convert degs to rads

P_ANK = dot(RJM, W_ANK, 2);

% figure(1);
% plot(time, P_ANK);
% hold on;
% xlim([0 2.4]);
% xlabel('Time (s)');
% ylabel('Instantaneous Power (W)');
% hold off;

figure(1);
plot(frame, P_ANK);
hold on;
plot(frame, RJM);
plot(frame, Ang_ANK);
plot([103 103], [-1400 600], '--r');
plot([128 128], [-1400 600], '--r');
plot([181 181], [-1400 600], '--g');
plot([207 207], [-1400 600], '--g');
plot(128, P_ANK(129), 'o');
plot(182, P_ANK(183), 'o');
xlim([0 288]);
xlabel('Time (s)');
ylabel('Instantaneous Power (W)');
hold off;

% Problem 2
% idx 129 corresponds to frame 128
sum = 0;
for i = 1:129-1 % n-1 (i.e. frame 127) 
    sum = sum + abs(P_ANK(i));
end
Work_ANK = (P_ANK(1) + sum + P_ANK(129)) * delta_t;

% Work_ANK = [];
% for i = 1:129-1
%     work = delta_t * ((abs(P_ANK(i)) + abs(P_ANK(i+1))) / 2);
%     Work_ANK = cat(1, Work_ANK, work);
% end
% Work_ANK = sum(Work_ANK);

% Problem 3
figure(2);
plot(frame, P_ANK);
hold on;
plot(frame, W_FOOT)
plot(frame, W_LEG)
xlim([0 288]);
xlabel('Time (s)');
ylabel('Instantaneous Power (W) or Angular Velocity (deg/s)');
legend('P Ankle', '\omega Foot', '\omega Leg');
hold off;