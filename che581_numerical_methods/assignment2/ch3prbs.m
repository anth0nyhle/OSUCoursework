% Created by: Anthony H. Le
% Last updated: 01-27-2019

% CHE 581: Assignment 2
% Textbook Problems 3.1, 3.2, 3.5, 3.9, 3.12, 3.13, 5.1, 5.7, 5.13
% Due: 02-01-2019
%% Problem 3.1
close all; % close all figures
clear; % clear workspace
clc; % clear command window

R = [0.9 1.5 1.3 1.3];
d = [1 1.25 3.8 4.0];

for i = 1:length(R)
    if d(i) > (3 * R(i))
        disp('Overtop!');
    else
        fprintf('All good; tank volume is %8.4f!\n', calc_vol(R(i), d(i)));
    end
end

disp('-------------------------------------------------');

%% Problem 3.2
close all;
clear;
clc;

int_P = 100000; % dollars
i = 0.05;
n = 10;

F_table = comp_interest(int_P, i, n);

fprintf('    n        P\n');
fprintf('%5d %10.f\n', F_table');

% N = F_table(:, 1);
% P = F_table(:, 2);
% disp(table(N, P));

disp('-------------------------------------------------');

%% Problem 3.5
close all;
clear;
clc;

x = 0.9;
odr_trm = 8;

[sine_val, sine_err] = eval_sine(x, odr_trm);

sine_table = [sine_val, sine_err];

fprintf(' sin(x)          error\n');
fprintf('%5f %20.15f\n', sine_table');

disp('-------------------------------------------------');

%% Problem 3.9
close all;
clear;
clc;

n = [0.036 0.020 0.015 0.030 0.022]';
S = [0.0001 0.0002 0.0012 0.0007 0.0003]';
B = [10 8 20 25 15]';
H = [2 1 1.5 3 2.6]';

U = (sqrt(S) ./ n) .* ((B .* H) ./ (B + (2 * H))).^(2/3);

data = [n S B H U];

fprintf('     n       S      B(m)     H(m)     U(m/s)\n');
fprintf('%8.3f %8.4f %5d %8.1f %12f\n', data');

disp('-------------------------------------------------');

%% Problem 3.12
close all;
clear;
clc;

% provided code from textbook
% tstart = 0; tend = 20; ni = 8;
% t(1) = tstart;
% y(1) = 12 + 6 * cos(2 * pi * t(1) / (tend - tstart));
% for i = 2:ni+1
%     t(i) = t(i-1) + (tend - tstart) / ni;
%     y(i) = 12 + 6 * cos(2 * pi * t(i) / (tend - tstart));
% end

ni = 8;
tstart = 0;
tend = 2.5 * ni;

t = tstart:2.5:tend;
y = 12 + 6 * cos(2 * pi * t ./ (tend - tstart));

disp('-------------------------------------------------');

%% Problem 3.13
close all;
clear;
clc;



disp('-------------------------------------------------');
