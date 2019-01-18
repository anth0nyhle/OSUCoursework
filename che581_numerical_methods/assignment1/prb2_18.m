% Created by: Anthony H. Le
% Last updated: 01-17-2019

% CHE 581: Assignment 1
% Textbook (4th edition) Problems 2.1-2.7, 2.17, 2.18
% Due: 01-23-2019
%%
close all;
clear;
clc;

%% Problem 2.18
v = [10 20 30 40 50 60 70 80]; % m/s
F = [25 70 380 550 610 1220 830 1450]; % N

F_v = 0.2741 * v.^1.9842;

figure();
plot(v, F, "om");
hold on;
plot(v, F_v, '--k');
hold off;