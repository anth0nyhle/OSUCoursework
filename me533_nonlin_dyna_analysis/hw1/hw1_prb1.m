% Created by: Anthony Le
% Last updated: 04-15-2018

% Homework 1
%% Problem 1
clear;
close all;

x = linspace(0, 10, 10000);
y = 10 - 10 .* exp(-10 .* x);

plot(x, y);