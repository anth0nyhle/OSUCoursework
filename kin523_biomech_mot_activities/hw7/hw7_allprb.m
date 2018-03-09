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

RJF_X = (M_FT .* ACC_X) - F_X;
RJF_Y = F_Y - F_W - (M_FT .* ACC_Y);
RJM = ((COM_X - ANK_X) .* RJF_Y) - ((ANK_Y - COM_Y) .* RJF_X) + ((COP_X - COM_X) .* F_Y) + ((COM_Y - COP_Y) .* F_X) - (I_FT .* FT_ACC);

% problem 5
BODY_M = 56.3; % in kg
BODY_H = 157.7 / 100; % in m
BODY_W = BODY_M * 9.80655; % in N, convert mass to weight