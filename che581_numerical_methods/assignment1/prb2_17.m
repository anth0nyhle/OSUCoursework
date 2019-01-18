% Created by: Anthony H. Le
% Last updated: 01-17-2019

% CHE 581: Assignment 1
% Textbook (4th edition) Problems 2.1-2.7, 2.17, 2.18
% Due: 01-23-2019
%%
close all;
clear;
clc;

%% Problem 2.17
t = [10 20 30 40 50 60]; % min
c = [3.4 2.6 1.6 1.3 1.0 0.5]; % ppm

c_t = 4.84 * exp(-0.034 * t);

figure()
plot(t, c);
hold on;
title('Plot function');
hold off;

figure();
semilogy(t, c);
hold on;
title('Semilog y-axis fuction');
hold off;

figure();
semilogy(t, c_t);
hold on;
title('Semilog y-axis function; c(t)');
hold off;