% Created by: Anthony Le
% Last updated: 04.15.2018

% ME 533 - Homework 1
%% Problem 2
clear;
close all;

[x, y] = meshgrid(-5:0.5:5, -5:0.5:5);
xdot = y + x .* (x^2 + y^2 - 1) .* sin(1 ./ (x^2 + y^2 - 1));
ydot = -x + y .* (x^2 + y^2 - 1) .* sin(1 ./ (x^2 + y^2 - 1));

figure(1);
quiver(x, y, xdot, ydot);
xlabel('x');
ylabel('y');