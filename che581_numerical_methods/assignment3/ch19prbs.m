% Created by: Anthony H. Le
% Last updated: 02-11-2019

% CHE 581: Assignment 3
% Textbook Problems 4.2, 4.4, 4.11, 19.2, 19.12, 19.16
% Due: 02-11-2019
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
% analytically
disp('  See comments under Problem 19.2 (a) in ch19prbs.m');
% F(x) = x + exp(-x) + C % antiderivative of f(x) with constant, C
% integral of f(x) from x = 0 to 4
% I_a = F(b) - F(a)
% I_a = F(4) - F(0)
% I_a = (4 + exp(-4)) - (0 + exp(0))
% I_a = (4 + exp(-4)) - 1
I_a = 3 + exp(-4); % = 3.0183
% I_a = integral(f_x, a, b);
fprintf('         I = %5.4f\n', I_a);

% (b)
disp('(b)');
% single trap rule
n_b = 1;
[I_b, S_b] = trap(f_x, a, b, n_b);
e_tb = ((I_a - I_b) / I_a) * 100; % true percent relative error
fprintf('  n = 1: I = %5.4f  error: %5.2f\n', I_b, e_tb);
% I_b2 = (b - a) * ((f_x(a) + f_x(b)) / 2);

% (c)
disp('(c)');
% composite trap rule w/ n = 2, 4
n_c1 = 2; % 2 segments
n_c2 = 4; % 4 segments
[I_c1, S_c1] = trap(f_x, a, b, n_c1);
[I_c2, S_c2] = trap(f_x, a, b, n_c2);
e_tc1 = ((I_a - I_c1) / I_a) * 100; % true percent relative error
e_tc2 = ((I_a - I_c2) / I_a) * 100; % true percent relative error
fprintf('  n = 2: I = %5.4f  error: %5.2f\n', I_c1, e_tc1);
fprintf('  n = 4: I = %5.4f  error: %5.2f\n', I_c2, e_tc2);

% (d)
disp('(d) single Simpsons 1/3 rule');
% single Simpson's 1/3 rule
n_d = 2; % need 3 equally spaced points, 2 segments
[I_d, S_d] = simp_onethird(f_x, a, b, n_d);
e_td = ((I_a - I_d) / I_a) * 100; % true percent relative error
fprintf('  n = 2: I = %5.4f  error: %5.2f\n', I_d, e_td);
% x_0 = a;
% x_2 = b;
% x_1 = (x_0 + x_2) / 2;
% I_d2 = (b - a) * ((f_x(x_0) + (4 * f_x(x_1)) + f_x(x_2)) / 6);

% (e)
disp('(e) composite Simpsons 1/3 rule');
% composite Simpson's 1/3 rule w/ n = 4
n_e = 4; % need 5 equally spaced points, 4 segments
[I_e, S_e] = simp_onethird(f_x, a, b, n_e);
e_te = ((I_a - I_e) / I_a) * 100; % true percent relative error
fprintf('  n = 4: I = %5.4f  error: %5.2f\n', I_e, e_te);

% (f)
disp('(f) single Simpsons 3/8 rule');
% single Simpson's 3/8 rule
n_f = 3; % need 4 equally spaced points, 3 segment
[I_f, S_f] = simp_threeeight(f_x, a, b, n_f);
e_tf = ((I_a - I_f) / I_a) * 100; % true percent relative error
fprintf('  n = 4: I = %5.4f  error: %5.2f\n', I_f, e_tf);

% (g)
disp('(g) composite Simpsons rule');
% composite Simpson's rule w/ n = 5
n_g = 5; % need 6 equally spaced points
h = (b - a) / n_g; % spacing
x_0 = a;
x_2 = a + (2 * h);
x_5 = b;
% conjunction of single Simpson's 1/3 and 3/8 rules
[I_g1, S_g1] = simp_onethird(f_x, x_0, x_2, 2); % single Simpson's 1/3 rule, 2 segments
[I_g2, S_g2] = simp_threeeight(f_x, x_2, x_5, 3); % single Simpson's 3/8 rule, 3 segments
I_g = I_g1 + I_g2; % sum
e_tg = ((I_a - I_g) / I_a) * 100; % true percent relative error
fprintf('  n = 5: I = %5.4f  error: %5.2f\n', I_g, e_tg);

disp('-------------------------------------------------');

%% Problem 19.12
close all;
clear;
clc;

disp('Problem 19.12');
a = 0; % lower limit
b = 11; % upper limit, x = 11
M_0 = 0;
V_x = @(x) 5 + (0.25 * x.^2);
% M = M_0 + V_x;

% (a)
disp('(a) analytical');
% analytically
disp('  See comments under Problem 19.12 (a) in ch19prbs.m');
% F(x) = (5 * x) + ((0.25 / 3) * x^3) + C % antiderivative of f(x) with constant, C
% integral of f(x) from x = 0 to 4
% M_a = F(b) - F(a)
% M_a = F(11) - F(0)
% M_a = (5 * 11) + ((0.25 / 3) * 11^3) - (5 * 0) + ((0.25 / 3) * 0^3)
M_a = 55 + ((0.25 / 3) * 1331) - 0; % = 165.9167
% M_a = integral(V_x, a, b);
fprintf('          M = %5.4f\n', M_a);

% (b)
disp('(b) trapezoidal rule');
% composite trap rule w/ n = 11
n_b = 11; % 11 segments
[M_b, Sb] = trap(V_x, a, b, n_b);
fprintf('  n = 11: M = %5.4f\n', M_b);

% (c)
disp('(c) composite Simpsons rule');
% composite Simpson's rule w/ n = 11
n_g = 11; % need 11 equally spaced points
h = (b - a) / n_g; % spacing
x_0 = a;
x_8 = a + (8 * h);
x_11 = b;
% conjunction of single Simpson's 1/3 and 3/8 rules
[M_c1, Sc1] = simp_onethird(V_x, x_0, x_8, 8); % single Simpson's 1/3 rule, 8 segments
[M_c2, Sc2] = simp_threeeight(V_x, x_8, x_11, 3); % single Simpson's 3/8 rule, 3 segments
M_c = M_c1 + M_c2; % sum
fprintf('  n = 11: M = %5.4f\n', M_c);

disp('-------------------------------------------------');

%% Problem 19.16
close all;
clear;
clc;

disp('Problem 19.16');
t = [0 10 20 30 35 40 45 50]'; % min
Q = [4 4.8 5.2 5.0 4.6 4.3 4.3 5.0]'; % m^3/min
c = [10 35 55 52 40 37 32 34]'; % mg/m^3
n = length(t); % number of data points, 8 points
M = zeros(n-1, 1); % n-1, number of segments, 7 segments
% f(x) = Q * c

% trap rule
for i = 1:n-1
    w = t(i+1) - t(i); % width
    avg_h = ((Q(i) * c(i)) + (Q(i+1) * c(i+1))) / 2; % avg height
    m = w * avg_h; % segment area
    M(i, 1) = m; % store computed area
end

I = sum(M); % mg, sum of all segment areas
fprintf('  M = %5.4f mg\n', I);

disp('-------------------------------------------------');
