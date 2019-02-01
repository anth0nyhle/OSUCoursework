% Created by: Anthony H. Le
% Last updated: 02-01-2019

% CHE 581: Assignment 2
% Textbook Problems 3.1, 3.2, 3.5, 3.9, 3.12, 3.13, 5.1, 5.7, 5.13
% Due: 02-01-2019
%% Problem 5.1
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 5.1');

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
    fprintf('iter: %1d  x_l: %5.4f  x_u: %5.4f  x_r: %5.4f  err: %5.4f\n', output);
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
disp('Problem 5.7 (a)');
x = linspace(-2, 6, 1000);
f_x = -12 - (21 * x) + (18 * (x.^2)) - (2.75 * (x.^3));

figure();
plot(x, f_x);
grid on;

%% Problem 5.7
close all;
clear;
clc;

% (b) bisection
disp('Problem 5.7 (b)');
x_l = -1; % initial lower bound
x_u = 0; % initial upper bound
x_rnew = x_l;
iter = 0;

while (1)
    x_rold = x_rnew;
    x_rnew = (x_u + x_l) / 2;
    if x_rnew ~=0
        eps = abs((x_rnew - x_rold) / x_rnew) * 100;
    end
    output = [iter x_l x_u x_rnew eps];
    iter = iter + 1;
    
    f_xl = -12 - (21 * x_l) + (18 * (x_l.^2)) - (2.75 * (x_l.^3));
    f_xr = -12 - (21 * x_rnew) + (18 * (x_rnew.^2)) - (2.75 * (x_rnew.^3));
    check = f_xl * f_xr;
    if check < 0
        x_u = x_rnew; % root in lower interval
    elseif check > 0
        x_l = x_rnew; % root in upper interval
    else
        eps = 0;
    end
    fprintf('iter: %1d  x_l: %5.4f  x_u: %5.4f  x_r: %5.4f  err: %5.4f\n', output);
    if eps <= 1; break; end
end

%% Problem 5.7
close all;
clear;
clc;

% (c) false position
disp('Problem 5.7 (c)');
x_l = -1; % initial lower bound
x_u = 0; % initial upper bound
x_rnew = x_l;
iter = 0;

while (1)
    x_rold = x_rnew;
    f_xl = -12 - (21 * x_l) + (18 * (x_l.^2)) - (2.75 * (x_l.^3));
    f_xu = -12 - (21 * x_u) + (18 * (x_u.^2)) - (2.75 * (x_u.^3));
    x_rnew = x_u - ((f_xu * (x_l - x_u)) / (f_xl - f_xu));
    if x_rnew ~=0
        eps = abs((x_rnew - x_rold) / x_rnew) * 100;
    end
    output = [iter x_l x_u x_rnew eps];
    iter = iter + 1;
    
    f_xr = -12 - (21 * x_rnew) + (18 * (x_rnew.^2)) - (2.75 * (x_rnew.^3));
    check = f_xl * f_xr;
    if check < 0
        x_u = x_rnew; % root in lower interval
    elseif check > 0
        x_l = x_rnew; % root in upper interval
    else
        eps = 0;
    end
    fprintf('iter: %1d  x_l: %5.4f  x_u: %5.4f  x_r: %5.4f  err: %5.4f\n', output);
    if eps <= 1; break; end
end

disp('-------------------------------------------------');

%% Problem 5.13
close all;
clear;
clc;

disp('Problem 5.13');

S_0 = 8; % moles/L
v_m = 0.7; % moles/L/d
k_s = 2.5; % moles/L
t = 0;



disp('-------------------------------------------------');
