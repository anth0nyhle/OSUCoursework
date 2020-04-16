% Created by: Anthony le
% Last updated: 04.30.2018

% ME 533 - Homework 2
%% Problem 1
clear;
close all;

% (i)
% ||x||^2 = 1
% 2-norm
x_1 = linspace(-1, 1, 1000);
x_2 = sqrt(1 - x_1.^2);

figure(1);
subplot(2, 2, 1);
plot(x_1, x_2, 'b');
hold on;
plot(x_1, -x_2, 'b');
xlim([-1.2, 1.2]);
ylim([-1.2, 1.2]);
axis square
grid on;
hold off;

% (ii)
% ||x||^2 = 1
x_3 = sqrt(1 - x_1.^2) ./ 5;

subplot(2, 2, 2);
plot(x_1, x_3, 'b');
hold on;
plot(x_1, -x_3, 'b');
xlim([-1.2, 1.2]);
ylim([-1.2, 1.2]);
axis square
grid on;
hold off;

% (iii)
% ||x|| = 1
% 1-norm
x_4 = abs(1 - abs(x_1));

subplot(2, 2, 3);
plot(x_1, x_4, 'b');
hold on;
plot(x_1, -x_4, 'b');
xlim([-1.2, 1.2]);
ylim([-1.2, 1.2]);
axis square
grid on;
hold off;

% (iv)
% ||x|| = 1
% inf-norm
x_5 = ones(1000, 1);

subplot(2, 2, 4);
plot(x_1, x_5, 'b');
hold on;
plot(x_1, -x_5, 'b');
plot(x_5, x_1, 'b');
plot(-x_5, x_1, 'b');
xlim([-1.2, 1.2]);
ylim([-1.2, 1.2]);
axis square
grid on;
hold off;

figure(2);
plot(x_1, x_2, 'b');
hold on;
plot(x_1, -x_2, 'b');
plot(x_1, x_3, 'r');
plot(x_1, -x_3, 'r');
plot(x_1, x_4, 'g');
plot(x_1, -x_4, 'g');
plot(x_1, x_5, 'm');
plot(x_1, -x_5, 'm');
plot(x_5, x_1, 'm');
plot(-x_5, x_1, 'm');
xlim([-1.2, 1.2]);
ylim([-1.2, 1.2]);
axis square
grid on;
hold off;