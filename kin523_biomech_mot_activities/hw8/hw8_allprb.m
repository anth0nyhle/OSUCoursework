% Created by: Anthony Le
% Last udpated: 03.17.2018

% KIN 523: Homework 8 - Work, Power, Energy, and Force Estimation
% Due: 03.16.18
%%
close all;
clear;

load('HW8_Data.mat');

W_ANK = degtorad(W_ANK);

P_ANK = dot(RJM, W_ANK, 2);

figure(1);
plot(P_ANK);
