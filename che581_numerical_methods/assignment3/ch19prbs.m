% Created by: Anthony H. Le
% Last updated: 02-07-2019

% CHE 581: Assignment 3
% Textbook Problems 4.2, 4.4, 4.11, 19.2, 19.12, 19.16
% Due: 02-08-2019
%% Problem 19.2
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 19.2');

% x = linspace(0, 4, 100)';
a = 0; % lower limit
b = 4; % upper limit
f_x = @(x) (1 - exp(-x)); % function

% (a)
disp('(a)');
% anlytically
disp('  See comments in ch19prbs.m or work in the pdf included');

% I_a = integral(f_x, a, b);
fprintf('  n = 1: I = %5.4f\n', I_a);

% (b)
disp('(b)');
% single trap rule
n_b = 1;
[I_b, S_b] = trap(f_x, a, b, n_b);
fprintf('  n = 1: I = %5.4f\n', I_b);
% I_b2 = (b - a) * ((f_x(a) + f_x(b)) / 2);

% (c)
disp('(c)');
% composite trap rule w/ n = 2, 4
n_c1 = 2; % 2 segments
n_c2 = 4; % 4 segments
[I_c1, S_c1] = trap(f_x, a, b, n_c1);
[I_c2, S_c2] = trap(f_x, a, b, n_c2);
fprintf('  n = 2: I = %5.4f\n', I_c1);
fprintf('  n = 4: I = %5.4f\n', I_c2);

% (d)
disp('(d)');
% single Simpson's 1/3 rule
n_d = 2; % need 3 equally spaced points, 2 segments
[I_d, S_d] = simp_onethird(f_x, a, b, n_d);
fprintf('  n = 2: I = %5.4f\n', I_d);
% x_0 = a;
% x_2 = b;
% x_1 = (x_0 + x_2) / 2;
% I_d2 = (b - a) * ((f_x(x_0) + (4 * f_x(x_1)) + f_x(x_2)) / 6);

% (e)
disp('(e)');
% composite Simpson's 1/3 rule w/ n = 4
n_e = 4; % need 5 equally spaced points, 4 segments
[I_e, S_e] = simp_onethird(f_x, a, b, n_e);
fprintf('  n = 4: I = %5.4f\n', I_e);

% (f)
disp('(f)');
% single Simpson's 3/8 rule
n_f = 3; % need 4 equally spaced points, 3 segment
[I_f, S_f] = simp_threeeight(f_x, a, b, n_f);
fprintf('  n = 4: I = %5.4f\n', I_f);

% (g)
disp('(g)');
% composite Simpson's rule w/ n = 5
n_g = 5; % need 6 equally spaced points
h = (b - a) / n_g; % spacing
x_0 = a;
x_2 = a + (2 * h);
x_5 = b;
% conjunction of single Simpson's 1/3 and 3/8 rules
[I_g1, S_g1] = simp_onethird(f_x, x_0, x_2, 2); % single Simpson's 1/3 rule, 2 segments
[I_g2, S_g2] = simp_threeeight(f_x, x_2, x_5, 3); % single Simpson's 3/8 rule, 3 segments
I_g = I_g1 + I_g2; % conjunction sum
fprintf('  n = 5: I = %5.4f\n', I_g);

disp('-------------------------------------------------');

%% Problem 19.12
close all;
clear;
clc;

disp('Problem 19.12');


disp('-------------------------------------------------');

%% Problem 19.16
close all;
clear;
clc;

disp('Problem 19.16');


disp('-------------------------------------------------');
