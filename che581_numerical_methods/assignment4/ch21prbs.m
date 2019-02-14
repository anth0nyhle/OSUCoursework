% Created by: Anthony H. Le
% Last updated: 02-13-2019

% CHE 581: Assignment 4
% Textbook Problems 21.13, 21.28, Additional Problem
% Due: 02-18-2019
%% Problem 21.13
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 21.13');

t = [0 2 4 6 8 10 12 14 16]'; % time, s
x = [0 0.7 1.8 3.4 5.1 6.3 7.3 8.0 8.4]; % position, m
h = 2; % step size, time, s
i = 6; % index @ t = 10

figure();
plot(t, x, '-*');
hold on;
xlabel('Time (s)');
ylabel('Position (m)');
hold off;

% (a) 2nd-order correct centered finite-difference method
disp('(a) O(h^2) centered finite-difference method');
v_a = (x(i+1) - x(i-1)) / (2 * h); % velocity @ t = 10, m/s
a_a = (x(i+1) - (2 * x(i)) + x(i-1)) / (h^2); % acceleration @ t = 10, m/s^2
fprintf('vel = %5.2f\n', v_a);
fprintf('accel = %5.2f\n', a_a);

% (b) 2nd-order correct forward fiite-difference method
disp('(b) O(h^2) forward fiite-difference method');
v_b = (-x(i+2) + (4 * x(i+1)) - (3 * x(i))) / (2 * h); % velocity @ t = 10, m/s
a_b = (-x(i+3) + (4 * x(i+2)) - (5 * x(i+1)) + (2 * x(i))) / (h^2); % acceleration @ t = 10, m/s^2
fprintf('vel = %5.2f\n', v_b);
fprintf('accel = %5.2f\n', a_b);

% (c) 2nd-order correct backward finite-difference method
disp('(c) O(h^2) backward finite-difference method');
v_c = ((3 * x(i)) - (4 * x(i-1)) + x(i-2)) / (2 * h); % velocity @ t = 10, m/s
a_c = ((2 * x(i)) - (5 * x(i-1)) + (4 * x(i-2)) - x(i-3)) / (h^2); % acceleration @ t = 10, m/s^2
fprintf('vel = %5.2f\n', v_c);
fprintf('accel = %5.2f\n', a_c);

disp('-------------------------------------------------');

%% Problem 21.28
close all;
clear;
clc;

disp('Problem 21.28');


disp('-------------------------------------------------');

%% Additional Problem
close all;
clear;
clc;

disp('Additional Problem (see handout)');

f = @(xx) sin(50 .* xx) .* xx.^2;



disp('-------------------------------------------------');
