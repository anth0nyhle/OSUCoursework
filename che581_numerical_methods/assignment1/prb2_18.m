% Created by: Anthony H. Le
% Last updated: 01-21-2019

% CHE 581: Assignment 1
% Textbook (4th edition) Problems 2.1-2.7, 2.17, 2.18
% Due: 01-23-2019
%%
close all; % close all figures
clear; % clear workspace
clc; % clear command window

%% Problem 2.18
v = [10 20 30 40 50 60 70 80]; % m/s, provided in textbook
v2 = linspace(0, 100); % m/s, v = 0 to 100
F = [25 70 380 550 610 1220 830 1450]; % N, provided in textbook

F_v = 0.2741 * v2.^1.9842; % function F(v)

figure();
% plot data and fuction w/ plot function
plot(v, F, 'om', 'MarkerFaceColor', 'm'); % megenta-filled, circle markers
hold on;
plot(v2, F_v, '-.k'); % black, dash-dotted line
title('Wind Tunnel Force vs Velocity');
xlabel('Velocity (\it{v}, \rm{m/s})');
ylabel('Force (F, N)');
hold off;