% Created by: Anthony H. Le
% Last updated: 02-01-2019

% CHE 581: Assignment 2
% Textbook Problems 3.1, 3.2, 3.5, 3.9, 3.12, 3.13, 5.1, 5.7, 5.13
% Due: 02-01-2019
%% Problem 5.1
close all; % close all figures
clear; % clear workspace
clc; % clear command window

m = 95; % kg
vel = 46; % m/s
t = 9; % s
g = 9.81; % m/s^2
x_l = 0.2; % initial lower bound
x_u = 0.5; % initial upper bound
x_rnew = x_l;
iter = 0; % iteration

while (1)
    x_rold = x_rnew;
    x_rnew = (x_u + x_l) / 2;
    if x_rnew ~=0
        eps = abs((x_rnew - x_rold) / x_rnew) * 100;
    end
    output = [iter x_l x_u x_rnew eps];
    iter = iter + 1;
    disp(output);
    
    f_cd1 = freefall_f(m, vel, t, g, x_l);
    f_cd2 = freefall_f(m, vel, t, g, x_rnew);
    check = f_cd1 * f_cd2;
    if check < 0
        x_u = x_rnew; % root in lower interval
    elseif check > 0
        x_l = x_rnew; % root in upper interval
    else
        eps = 0;
    end
    
    if eps <= 5; break; end
end
root = x_rnew;
f_cd = freefall_f(m, vel, t, g, x_rnew);

disp('-------------------------------------------------');

% plot to double check root approximation
% c_d = linspace(0.2, 0.5, 100)';
% f_cd = sqrt((g * m) ./ c_d) .* tanh(sqrt((g .* c_d ./ m )) * t) - vel;
% figure();
% plot(c_d, f_cd); grid on;

%% Problem 5.7
close all;
clear;
clc;

% (a) graph
disp('(a)');
x = linspace(-2, 6, 1000);
f_x = -12 - (21 * x) + (18 * (x.^2)) - (2.75 * (x.^3));

figure();
plot(x, f_x);
grid on;

% (b) bisection
disp('(b)');
x_l = -1; % initial lower bound
x_u = 0; % initial upper bound



% (c) false position
disp('(c)');


disp('-------------------------------------------------');

%% Problem 5.13
close all;
clear;
clc;



disp('-------------------------------------------------');
