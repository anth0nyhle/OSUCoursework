% Created by: Anthony Le
% Last updated: 02.12.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.2018
%% Problem 2
close all;
clear;

load('jump.mat');

% all trials were recorded @ 120 frames/s 
f_s = 120;
delta_t = 1 / f_s;

time = [];

for i = 1:length(frame_j)
    t = frame_j(i) * 0.0083;
    time = [time; t];
end

FT = horzcat(frame_j, time);