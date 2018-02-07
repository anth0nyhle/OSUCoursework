% Created by: Anthony Le
% Last updated: 02.06.2018

% KIN 523: Homework 3 - Signal Processing
% Due: 02.06.2018
%% Problem 2
close all;
clear;

time = [0.7000; 0.7167; 0.7333; 0.7500; 0.7667]; % in sec
knee_ang = [30.2; 31.3; 33.9; 37.8; 43.2]; % in deg

t_0 = time(3); % before desired time
t_1 = time(4); % after desired time
t = 0.7417; %desired time

x_t_0 = knee_ang(3); % knee angle before desired time
x_t_1 = knee_ang(4); % knee angle after desired time

% linear interpolation equation
x_t = ((t_1 - t) / (t_1 - t_0)) * x_t_0 + ((t - t_0) / (t_1 - t_0)) * x_t_1;