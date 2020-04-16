% Anthony Le
% ROB 534: SDM, Winter 2017
% HW #2: Optimization and Informative Path Planning
% 02-20-2017

% Questions
% 2. Optimization
clear all; clc; close all
%% 2(i)
A = [1, 1/3; 1, 3]; %inequality constraints
b = [1, 4]; %inequality constraints A*x <= b
f = [-1, -1]; %objective function
Aeq = []; %no equality constraints
beq = []; %no equality constraints
lb = zeros(size(f)); %lower bound of 0 for x and y
ub = []; %no upper bound

options = optimoptions('linprog', 'Algorithm', 'dual-simplex'); %options for LP solver

x = linprog(f, A, b, Aeq, beq, lb, ub, options); %outputs optimal solution of x and y for LP

% x = 0.6250
% y = 1.1250
% OPT = x + y = 1.7500 or 7/4
%% 2(ii)
