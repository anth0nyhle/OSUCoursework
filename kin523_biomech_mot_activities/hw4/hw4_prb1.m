% Created by: Anthony Le
% Last updated: 02.12.2018

% KIN 523: Homework 4 - Planar Kinematics
% Due: 02.15.2018
%% Problem 1
close all;
clear;

load('static.mat');

avgx_heel = mean(HEEX_ST);
avgy_heel = mean(HEEY_ST);

avgx_toe = mean(TOEX_ST);
avgy_toe = mean(TOEY_ST);