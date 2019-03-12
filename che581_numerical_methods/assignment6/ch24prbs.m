% Created by: Anthony H. Le
% Last updated: 03-12-2019

% CHE 581: Assignment 6
% Textbook Problems 24.8, 24.11
% Due: 03-13-2019
%% Problem 24.8 (a)
% close all; % close all figures
% clear; % clear workspace
% clc; % clear command window
% 
% disp('Problem 24.8 (a) shooting method');
% 
% disp('-------------------------------------------------');

%% Problem 24.8 (b)
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 24.8 (b) finite-diff method');

bvp_24_8mod

% 6-node system
e = [0 -1 -1 -1]; % subdiagonal vec
f = [2 2 2 2]; % diagonal vec
g = [-1 -1 -1 0]; % superdiagonal vec
r = b'; % from bvp_24_8mod

% f(x) = 25 deg C/m
% dx = 2 m

%   | 2     -1       0       0      0||x1|        |f(x) * dx^2 + 40 |
%   |-1      2      -1       0      0||x2|        |f(x) * dx^2      |
%   | 0     -1       2      -1      0||x3|   =    |f(x) * dx^2      |
%   | 0      0      -1       2     -1||x4|        |f(x) * dx^2 + 200|

x = Tridiag(e, f, g, r); % calls function file

T = [T0 x Tn]; % complete x vec

fprintf(' T(0) = %5.4f\n T(2) = %5.4f\n T(4) = %5.4f\n T(6) = %5.4f\n T(8) = %5.4f\n T(10) = %5.4f\n', T);

disp('-------------------------------------------------');

%% Problem 24.11
close all;
clear;
clc;

disp('Problem 24.11');

bvp_24_11mod

% 5-node system
e = [0 -1 -1]; % subdiagonal vec
f = [5.3333 5.3333 5.333]; % diagonal vec
g = [-1 -1 0]; % superdiagonal vec
r = b'; % from bvp_24_11mod

% D = 1.5e-6 cm^2/s
% k = 5e-6 s^-1
% dx = 1 cm

%   |5.3    -1      5.3||x1|        |0.1|
%   |-1     5.3     -1 ||x2|   =    |0.0|
%   | 0     -1      5.3||x3|        |0.0|

x = Tridiag(e, f, g, r); % calls function file

A = [A0 x An]; % complete x vec

fprintf(' A(0) = %5.4f\n A(1) = %5.4f\n A(2) = %5.4f\n A(3) = %5.4f\n A(4) = %5.4f\n', A);

disp('-------------------------------------------------');
