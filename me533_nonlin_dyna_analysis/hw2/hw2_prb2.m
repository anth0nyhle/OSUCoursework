% Created by: Anthony le
% Last updated: 04.30.2018

% ME 533 - Homework 2
%% Problem 2
clear;
close all;

t = linspace(-1, 1, 10000);

% (i)
x_1 = linspace(0, 10, 10000);

x_2 = -x_1.^3 + (sin(x_1)).^4;

figure(1);
plot(x_1, x_2);
grid on;
xlim([-1, 1]);
ylim([-1, 1]);
axis square;

% (ii)
x_3 = (5 - x_1).^5;

figure(2);
plot(x_1, x_3);
grid on;
% xlim([-1, 1]);
% ylim([-1, 1]);
% axis square;

x_4 = -x_1.^3;
x_5 = sin(x_1).^4;

figure(3);
plot(t, x_4);
hold on;
plot(t, x_5);