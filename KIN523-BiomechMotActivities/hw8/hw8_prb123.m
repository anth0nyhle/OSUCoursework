% Created by: Anthony Le
% Last udpated: 03.18.2018

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
plot(frame*delta_t, P_ANK);
hold on;
plot(frame*delta_t, RJM);
plot(frame*delta_t, Ang_ANK);
plot([103 103]*delta_t, [-1400 600], '--k');
plot([128 128]*delta_t, [-1400 600], '--k');
plot([181 181]*delta_t, [-1400 600], '--k');
plot([220 220]*delta_t, [-1400 600], '--k');
plot(128*delta_t, P_ANK(129), 'o');
plot(182*delta_t, P_ANK(183), 'o');
xlim([0 288]*delta_t);
xlabel('Time (s)');
ylabel('Instantaneous Power (W)');
legend('Ankle Power', 'RJM', 'Ankle Angle');
txt1 = 'Planatarflexors generating power';
txt2 = 'Planatarflexors absorbing power';
txt3 = 'Dorsiflexors generating power';
txt4 = 'Dorsiflexors absorbing power';
set(text(194*delta_t, -1000, txt2), 'Rotation', 90);
set(text(113*delta_t, -1000, txt1), 'Rotation', 90);
set(text(50*delta_t, -1000, txt2), 'Rotation', 90);
set(text(250*delta_t, -1000, txt1), 'Rotation', 90);
hold off;

% Problem 2
% idx 129 corresponds to frame 128
sum = 0;
for i = 1:129-1 % n-1 (i.e. frame 127) 
    sum = sum + P_ANK(i);
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
plot(frame*delta_t, P_ANK);
hold on;
plot(frame*delta_t, RJM);
plot(frame*delta_t, W_FOOT)
plot(frame*delta_t, W_LEG)
plot([59 59]*delta_t, [-1400 600], '--k');
plot([84 84]*delta_t, [-1400 600], '--k');
plot([103 103]*delta_t, [-1400 600], '--k');
plot([128 128]*delta_t, [-1400 600], '--k');
plot([182 182]*delta_t, [-1400 600], '--k');
plot([188 188]*delta_t, [-1400 600], '--k');
plot([195 195]*delta_t, [-1400 600], '--k');
plot([199 199]*delta_t, [-1400 600], '--k');
plot([206 206]*delta_t, [-1400 600], '--k');
plot([214 214]*delta_t, [-1400 600], '--k');
plot([222 222]*delta_t, [-1400 600], '--k');
plot(128*delta_t, P_ANK(129), 'o');
plot(182*delta_t, P_ANK(183), 'o');
xlim([0 288]*delta_t);
xlabel('Time (s)');
ylabel('Instantaneous Power (W) or Angular Velocity (deg/s)');
legend('Ankle Power', 'RJM', 'Foot Angular Velocity', 'Leg Angular Velocity');
txt5 = 'Increasing E of foot';
txt6 = 'Decreasing E of foot';
txt7 = 'Increasing E of leg';
txt8 = 'Decreasing E of leg';
txt9 = 'Transferring E from foot \rightarrow leg';
txt10 = 'Transferring E from leg \rightarrow foot';
set(text(30*delta_t, 200, txt8), 'Rotation', 90);
set(text(75*delta_t, 200, txt8), 'Rotation', 90);
set(text(91*delta_t, 200, txt8), 'Rotation', 90);
set(text(91*delta_t, -1000, txt5), 'Rotation', 90);
set(text(97*delta_t, -1000, txt10), 'Rotation', 90);
set(text(110*delta_t, 200, txt7), 'Rotation', 90);
set(text(110*delta_t, -1000, txt5), 'Rotation', 90);
set(text(185*delta_t, 200, txt8), 'Rotation', 90);
set(text(185*delta_t, -1300, txt6), 'Rotation', 90);
set(text(190*delta_t, 200, txt8), 'Rotation', 90);
set(text(190*delta_t, -1000, txt5), 'Rotation', 90);
set(text(193*delta_t, -1000, txt10), 'Rotation', 90);
set(text(197*delta_t, -1000, txt6), 'Rotation', 90);
set(text(197*delta_t, 200, txt8), 'Rotation', 90);
set(text(203*delta_t, 200, txt8), 'Rotation', 90);
set(text(210*delta_t, 200, txt7), 'Rotation', 90);
set(text(244*delta_t, 200, txt7), 'Rotation', 90);
set(text(218*delta_t, 200, txt8), 'Rotation', 90);
hold off;