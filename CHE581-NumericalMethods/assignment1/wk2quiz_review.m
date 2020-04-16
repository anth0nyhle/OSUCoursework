% Created by: Anthony H. Le
% Last updated: 01-18-2019

% Week 2 Quiz Review
% Textbook Chapter 3
%%
close all;
clear;

g = 9.81;
m = 68.1;
t = 12;
cd = 0.25;

v = sqrt(g * m / cd) * tanh(sqrt(g * cd / m) * t);

