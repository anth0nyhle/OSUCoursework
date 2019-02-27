% Created by: Anthony H. Le
% Last updated: 02-26-2019

% CHE 581: Assignment 5
% Textbook Problems 22.1, 22.6, 22.10, 22.11, 22.12. 22.14
% Due: 02-27-2019
%% Problem 22.1
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 22.1');
disp('See pdf file for written work.');

dydt = @(y, t) y * t^2 - 1.1 * y;

% (a) analytically


% (b) Euler's method w/ h = 0.5, 0.25


% (c) midpoint method w/ h = 0.5


% (d) 4th-order RK method w/ h = 0.5


disp('-------------------------------------------------');

%% Problem 22.6
close all;
clear;
clc;

disp('Problem 22.6');

h = 0.5; % s, step size, delta t
% t_span = [0, 1000]; % s, time interval
t_span = 0:h:500;
v0 = 1500; % m/s, initial velocity @ t = 0
x0 = 0; % m, initial position @ t = 0

g0 = 9.81; % m/s^2, gravitational acceleration at earth's surface
R = 6.37 * 10^6; % m, earth's radius
dvdt = @(t, x) -g0 * (R^2 / (R + x)^2);
% dxdt = @(t, x) -g0 * (R^2 / (R + x).^2) .* t;

v = v0 * ones(length(t_span), 1);
x = x0 * ones(length(t_span), 1);

for i = 1:length(t_span)-1
    v(i+1) = v(i) + dvdt(t_span(i), x(i)) * h;
    x(i+1) = x(i) + v(i) * h;
end

max_x = max(x);
ind_x = find(x == max_x);
v_max_x = v(ind_x);

max_label = ['max height = ' num2str(max_x) ' m @ time = ' num2str(t_span(ind_x)) ' s'];

figure();
yyaxis left;
plot(t_span, v);
xlabel('Time (s)');
ylabel('Upward velocity (m/s)');
hold on;
plot(t_span(ind_x), v_max_x, '*');
yyaxis right;
plot(t_span, x);
plot(t_span(ind_x), max_x, '*');
text(t_span(ind_x)-20, max_x+30000, max_label);
ylabel('Position (m)');
grid on;
hold off;

disp('-------------------------------------------------');

%% Problem 22.10
close all;
clear;
clc;

disp('Problem 22.10');

% provided in prb 22.5
h = 5; % yrs, step size
t_span = [1950, 2050]; % yr
k_gm = 0.026; % per yr
p_max = 12000; % million people
p0 = 2555; % million people in 1950

e_critn = 0.1; % percent, corrector error criterion

dpdt = @(t, p) k_gm * (1 - (p / p_max)) * p; % function provided in prb 22.5
% y_prime = @(t, y) 4 * exp(0.8 * t) - 0.5 * y; % example 22.2

% labels for plot
title = 'World''s Population from 1950 to 2050';
xlabel = 'Year';
ylabel = 'Population (million ppl)';

[t1, p1] = heunode(dpdt, t_span, p0, h, e_critn, title, xlabel, ylabel); % calls Heun's method function file
% [t_ex, y_ex] = heunode(y_prime, [0, 4], 2, 1, 0.00001); % example 22.2

disp('-------------------------------------------------');

%% Problem 22.11
close all;
clear;
clc;

disp('Problem 22.11');

% provided in prb 22.5
h = 5; % yrs, step size
t_span = [1950, 2050]; % yr
k_gm = 0.026; % per yr
p_max = 12000; % million people
p0 = 2555; % million people in 1950

dpdt = @(t, p) k_gm * (1 - (p / p_max)) * p; % function provided in prb 22.5
% y_prime = @(t, y) 4 * exp(0.8 * t) - 0.5 * y; % example 22.2

% labels for plot
title = 'World''s Population from 1950 to 2050';
xlabel = 'Year';
ylabel = 'Population (million ppl)';

[t2, p2] = midptode(dpdt, t_span, p0, h, title, xlabel, ylabel); % calls midpoint method function file
% [t_ex, y_ex] = midptode(y_prime, [0, 4], 2, 1, 0.00001); % example 22.2

disp('-------------------------------------------------');

%% Problem 22.12
close all;
clear;
clc;

disp('Problem 22.12');

% provided in prb 22.5
h = 5; % yrs, step size
t_span = [1950, 2050]; % yr
k_gm = 0.026; % per yr
p_max = 12000; % million people
p0 = 2555; % million people in 1950

dpdt = @(t, p) k_gm * (1 - (p / p_max)) * p; % function provided in prb 22.5
% y_prime = @(t, y) 4 * exp(0.8 * t) - 0.5 * y; % example 22.2

% labels for plot
title = 'World''s Population from 1950 to 2050';
xlabel = 'Year';
ylabel = 'Population (million ppl)';

[t3, p3] = rk4ode(dpdt, t_span, p0, h, title, xlabel, ylabel); % calls midpoint method function file
% [t_ex, y_ex] = rk4ode(y_prime, [0, 4], 2, 1, 0.00001); % example 22.2

disp('-------------------------------------------------');

%% Problem 22.14
close all;
clear;
clc;

disp('Problem 22.14');

% provided coefficient values
a = 0.23; % prey growth rate
b = 0.0133; % rate characterizing the effect of predator-prey interactions on prey death
c = 0.4;  % predator death rate
d = 0.0004; % rate characterizing the effect of predator-prey interactions on predator growth

% provided data
filename = 'moose_versus_wolf.csv'; % assign filename
data = csvread(filename, 1, 0); % read .csv file, all data, 48 by 3 mat
Year = data(:, 1); % create separate 48 by 1 col vec
Moose = data(:, 2); % create separate 48 by 1 col vec
Wolves = data(:, 3); % create separate 48 by 1 col vec

% (a)
disp('(a)');

% x = number of prey (i.e., moose)
% y = number of predators (i.e., wolves)

dxdt = @(t, x, y) (a * x) - (b * x * y);
dydt = @(t, x, y) -(c * y) + (d * x * y);



% (b)
disp('(b)');


disp('-------------------------------------------------');
