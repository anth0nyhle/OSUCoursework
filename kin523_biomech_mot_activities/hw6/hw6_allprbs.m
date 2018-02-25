% Created by: Anthony Le
% Last updated: 02.24.2018

% KIN 523: Homework 6 - Force Measurement
% Due: 03.01.18
%%
close all;
clear;

% origin of force plate coordinate system in global XYZ
% Y_0 -> -Z_0
% Z_0 -> Y_0
XZY_0 = [0.300; 0.205; 0];

cal_mat = [612.8, -2.9, 0.1, 1.4, 0.1, 0.7;
            5.5, 616.3, -3.3, -1.8, 0.2, -7.5;
            30.6, 2.7, 945.1, -2.7, -10.4, 3.5;
            0.4, -29.0, -0.7, 351.3, 1.5, 0.6;
            25.6, -0.2, -0.7, -0.7, 246.9, 0.3;
            0.8, 0.6, 0.6, 0.5, 0.6, 143.8];
        
h = 0.044; % in m

G_i = 2; % force plate amp gains

f_s = 1080; % in Hz
f_c = 120; % in Hz; 4th-order Butterworth no-lag filter

%% Problem 1
% bipolar range for 16-bit A/D -32768 to 32767

% mV per count 
mV_count = (20 / (2^16)) * 1000; % in mV

d_output = 4673; % digital output in counts
a_input = d_output * mV_count; % analog input in mV
a_input = a_input / 1000; % analog input in V

%% Problem 2
load('Forces.mat');

V_base = [0.0595, 0.0438, 0.0748, 0.0485, 0.0519, 0.0497];
V_base = repmat(V_base, 2593, 1);

V_meas = [F_x, F_y, F_z, M_x, M_y, M_z];

V_act = V_meas - V_base;

table_2 = horzcat(sample, V_act);

%% Problem 3
V_act_tp = transpose(V_act);

FM_output = []; % force and moments in N and Nm, respectively

for i = 1:length(sample)
    fm_output = cal_mat * (V_act_tp(:, i) ./ 2);
    FM_output = cat(2, FM_output, fm_output);
end

FM_output = transpose(FM_output);

table_3 = horzcat(sample, FM_output);

%% Problem 4
x_CoP = [];
y_CoP = [];

for j = 1:length(sample)
    if FM_output(j, 3) < 20
        x = 0;
        y = 0;
        x_CoP = cat(1, x_CoP, x);
        y_CoP = cat(1, y_CoP, y);
    else
        x = ((-h * FM_output(j, 1)) - FM_output(j, 5)) / FM_output(j, 3);
        y = ((-h * FM_output(j, 2)) - FM_output(j, 4)) / FM_output(j, 3);
        x_CoP = cat(1, x_CoP, x);
        y_CoP = cat(1, y_CoP, y);
    end
    
end

xyz_CoP = [x_CoP, y_CoP, zeros(2593, 1)];

table_4 = horzcat(sample, xyz_CoP);

%% Problem 5
T_z = [];

for k = 1:length(sample)
    t_z = FM_output(k, 6) - (x_CoP(k, 1) * FM_output(k, 2)) + (y_CoP(k, 1) * FM_output(k, 1));
    T_z = cat(1, T_z, t_z);
end

table_5 = horzcat(sample, T_z);

%% Problem 6
% part a
xyz_CoP_tp = transpose(xyz_CoP);

XZY_CoP = [];

RotM = [cos(90), sin(90), 0;
        sin(90), -cos(90), 0;
        0, 0, -1];

for l = 1:length(sample)
    XZY = RotM * xyz_CoP_tp(:, l) + XZY_0;
    XZY_CoP = cat(2, XZY_CoP, XZY);
end

XZY_CoP = transpose(XZY_CoP);

X_CoP = XZY_CoP(:, 1);
Z_CoP = XZY_CoP(:, 2);

% part b
F_xyz = [FM_output(:, 1), FM_output(:, 2), FM_output(:, 3)];
F_xyz_tp = transpose(F_xyz);

F_XZY = [];

for m = 1:length(sample)
    f_XZY = RotM * F_xyz_tp(:, m);
    F_XZY = cat(2, F_XZY, f_XZY);
end

F_XZY = transpose(F_XZY);

F_X = F_XZY(:, 1);
F_Y = F_XZY(:, 3);
F_Z = F_XZY(:, 2);

% part c
T_Z = [];

M_Z = (-X_CoP .* F_Y) - (h * F_X);
M_X = (-Z_CoP .* F_Y) - (h * (-F_Z));
M_Y = -FM_output(:, 6);

T_Y = M_Y - (X_CoP .* (-F_Z)) + ((-Z_CoP) .* F_X);

table_6 = horzcat(sample, X_CoP, Z_CoP, F_X, F_Y, F_Z, T_Y);

%% Problem 7
