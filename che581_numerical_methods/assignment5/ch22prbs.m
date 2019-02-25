% Created by: Anthony H. Le
% Last updated: 02-25-2019

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

h = 1; % s, step size, delta t
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



disp('-------------------------------------------------');

%% Problem 22.11
close all;
clear;
clc;

disp('Problem 22.11');



disp('-------------------------------------------------');

%% Problem 22.12
close all;
clear;
clc;

disp('Problem 22.12');



disp('-------------------------------------------------');

%% Problem 22.14
close all;
clear;
clc;

disp('Problem 22.14');



disp('-------------------------------------------------');
