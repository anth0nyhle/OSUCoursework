% Created by: Anthony H. Le
% Last updated: 03-11-2019

% CHE 581: Assignment 6
% Textbook Problems 24.8, 24.11
% Due: 03-13-2019
%% Problem 24.8 (a)
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 24.8 (a) shooting method');

disp('-------------------------------------------------');

%% Problem 24.8 (b)
close all;
clear;
clc;

disp('Problem 24.8 (b) finite-diff method');

bvp_24_8mod

e = [0 -1 -1 -1];
f = [2 2 2 2];
g = [-1 -1 -1 0];
r = b';

x = Tridiag(e, f, g, r);

T = [T0 x Tn];

fprintf(' T(0) = %5.4f\n T(2) = %5.4f\n T(4) = %5.4f\n T(6) = %5.4f\n T(8) = %5.4f\n T(10) = %5.4f\n', T);

disp('-------------------------------------------------');

%% Problem 24.11
close all;
clear;
clc;

disp('Problem 24.11');

bvp_24_11mod

e = [0 -1 -1];
f = [5.3333 5.3333 5.333];
g = [-1 -1 0];
r = b';

x = Tridiag(e, f, g, r);

A = [A0 x An];

fprintf(' A(0) = %5.4f\n A(1) = %5.4f\n A(2) = %5.4f\n A(3) = %5.4f\n A(4) = %5.4f\n', A);

disp('-------------------------------------------------');
