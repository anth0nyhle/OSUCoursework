% Created by: Anthony Le
% Last updated: 03.05.2018

% KIN 523: Homework 7 - Kinetics
% Due: 03.09.18
%%
close all;
clear;

load('Jump_Data.mat');

% problem 3
M_FT = 0.76; % in kg
I_FT = 0.00439; % in kg*m^2
F_W = M_FT * 9.80655; % in N; convert mass to weight
COP_Y = 0;

RJF_X = (M_FT .* ACC_X) - F_X; % in N
RJF_Y = F_Y - F_W - (M_FT .* ACC_Y); % in N
RJM = ((COM_X - ANK_X) .* RJF_Y) - ((ANK_Y - COM_Y) .* RJF_X) + ((COP_X - COM_X) .* F_Y) - ((COP_Y - COM_Y) .* F_X) - (I_FT .* FT_ACC); % in Nm

% problem 4
RJF_SC = [];
    
for i = 1:length(frame)
    theta = FT_ANG(i);
    RotM = [cos(theta), sin(theta);
            -sin(theta), cos(theta)];
    rjf_sc = RotM * [RJF_X(i); RJF_Y(i)];
    RJF_SC = cat(2, RJF_SC, rjf_sc);
end
RJF_SC = RJF_SC';

RJF_S = RJF_SC(:, 1);
RJF_C = RJF_SC(:, 2);

% problem 5
BODY_M = 56.3; % in kg
BODY_H = 157.7 / 100; % in m
BODY_W = BODY_M * 9.80655; % in N, convert mass to weight

BODY_WH = BODY_W * BODY_H; % in Nm

% part a
norm_RJM = RJM ./ BODY_WH;

f_s = 120; % in Hz
delta_t = 1 / f_s;
time = [];

for j = 1:length(frame)
    t = frame(j) * delta_t;
    time = cat(1, time, t);
end

figure(1);
plot(time, norm_RJM);
xlabel('Time (s)');
ylabel('Normalized Moment');
xlim([0 2.4]);

% part b
norm_RJF_S = RJF_S ./ BODY_W;
norm_RJF_C = RJF_C ./ BODY_W;

figure(2);
plot(time, norm_RJF_S);
hold on;
plot(time, norm_RJF_C, '--');
xlabel('Time (s)');
ylabel('Normalized Shear or Compressive Forces');
legend('Normalized RFJ_{S}', 'Normalized RFJ_{C}');
xlim([0 2.4]);
hold off;


figure(3);
plot(time, RJF_X);
hold on;
plot(time, RJF_Y);
