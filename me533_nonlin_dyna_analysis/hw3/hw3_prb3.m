% Created by: Anthony le
% Last updated: 05.17.2018

% ME 533 - Homework 3
%% Problem 3
clear;
close all;

t = linspace(0, 1, 1000);
p = linspace(-1, 1, 1000);

a_p1 = 0.1;
a_p2 = -4;
b_p = 2;

y = (p + b_p) ./ (p.^2 + a_p1 .* p + a_p2);

figure(1);
plot(t, y);