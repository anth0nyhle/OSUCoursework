% Created by: Anthony H. Le
% Last updated: 01-21-2019

% CHE 581: Assignment 1
% Textbook (4th edition) Problems 2.1-2.7, 2.17, 2.18
% Due: 01-23-2019
%%
close all; % close all figures
clear; % clear workspace
clc; % clear command window

%% Problem 2.17
t = [10 20 30 40 50 60]; % min, provided in textbook
t2 = linspace(0, 70); % min, t = 0 to 70
c = [3.4 2.6 1.6 1.3 1.0 0.5]; % ppm, provided in textbook

c_t = 4.84 * exp(-0.034 * t2); % fucntion c(t)

figure()
% plot data and function w/ plot function
subplot(1, 2, 1);
plot(t, c, 'dr', 'MarkerFaceColor', 'r'); % red-filled, diamond markers
hold on;
plot(t2, c_t, '--g'); % green, dashed line
title('Photodegradation of Aqueous Br vs Time');
xlabel('Time (t, min)');
ylabel('Br Concentration (c, ppm)');
hold off;

% plot data and function w/ semilogy function
subplot(1, 2, 2);
semilogy(t, c, 'dr', 'MarkerFaceColor', 'r'); % red-filled, diamond markers
hold on;
semilogy(t2, c_t, '--g'); % green, dashed line
title('Photodegradation of Aqueous Br vs Time');
xlabel('Time (t, min)');
ylabel('Br Concentration (c, ppm, log_{10} scale)');
hold off;