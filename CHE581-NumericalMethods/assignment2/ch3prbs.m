% Created by: Anthony H. Le
% Last updated: 02-01-2019

% CHE 581: Assignment 2
% Textbook Problems 3.1, 3.2, 3.5, 3.9, 3.12, 3.13, 5.1, 5.7, 5.13
% Due: 02-01-2019
%% Problem 3.1
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 3.1');

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

disp('Problem 3.2');

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

disp('Problem 3.5');

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

disp('Problem 3.9');

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

disp('Problem 3.12');

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

disp('Problem 3.13');

% test for a = 0, 2, 4, -4
disp('Approximate the square root of any positive number.')
a = input('Enter a positive number: ');
x_old = input('Enter initial approximation: ');

while (1)
    if a == 0 % if input is 0
        x_new = 0;
        eps = 0;
        x_old = x_new;
        res = [x_old eps];
        fprintf('x = %5.4f   error: %5.4f\n', res);
        if eps <= 1e-4; break; end
    elseif a < 0 % if input is negative
        a1 = -a;
        x_new = (x_old + (a1 / x_old)) / 2;
        eps = abs((x_new - x_old) / x_new);
        x_old = x_new;
        res = [x_old eps];
        fprintf('x = %5.4fi   error: %5.4f\n', res); % print imaginary
        if eps <= 1e-4; break; end
    else % if input is positive
        x_new = (x_old + (a / x_old)) / 2;
        eps = abs((x_new - x_old) / x_new);
        x_old = x_new;
        res = [x_old eps];
        fprintf('x = %5.4f   error: %5.4f\n', res);
        if eps <= 1e-4; break; end
    end
end

disp('-------------------------------------------------');
