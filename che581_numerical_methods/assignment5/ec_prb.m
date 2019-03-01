% Created by: Anthony H. Le
% Last updated: 03-01-2019

% CHE 581: Assignment 5
% Extra Credit Problem
% Due: 03-01-2019
%% Extra Credit
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Extra Credit Problem');
disp('See Figure 1 & 2');

dydt = @(t, y) (y * t^2) - (1.1 * y);
y = @(t) exp((t.^3 / 3) - 1.1 .* t);

figure();
% (a) analytically
a = (0:1);
y_a = y(a);
plot(a, y_a);
title('22.1 IVP for t = 0 to 1, where y(0) = 1');
xlabel('t');
ylabel('y');
hold on;

% t_span = [0, 1];

% (b) Euler's method w/ h = 0.5, 0.25
% for h = 0.5
h_b1 = 0.5;
inv_b1 = (0:h_b1:1);
n_b1 = length(inv_b1);
y_b1 = y(0) * ones(n_b1, 1);

for i = 1:n_b1-1
   y_b1(i+1) = y_b1(i) + dydt(inv_b1(i), y_b1(i)) * h_b1; 
end

% [t_b1, y_b1] = eulode(dydt, t_span, y(0), h_b1);

plot(inv_b1, y_b1);
% plot(t_b1, y_b1);

% for h = 0.25
h_b2 = 0.25;
inv_b2 = (0:h_b2:1);
n_b2 = length(inv_b2);
y_b2 = y(0) * ones(n_b2, 1);

for i = 1:n_b2-1
   y_b2(i+1) = y_b2(i) + dydt(inv_b2(i), y_b2(i)) * h_b2; 
end

% [t_b2, y_b2] = eulode(dydt, t_span, y(0), h_b2);

plot(inv_b2, y_b2);
% plot(t_b2, y_b2);

% (c) midpoint method w/ h = 0.5
h_c = 0.5;
inv_c = (0:h_c:1);
n_c = length(inv_c);
y_c = y(0) * ones(n_c, 1);
y_predc = zeros(n_c-1, 1);

for i = 1:n_c-1
    yp_intc = dydt(inv_c(i), y_c(i));
    y_predc(i) = y_c(i) + yp_intc * (h_c / 2); % predictor, compute y @ midpoint
    yp_midc = dydt(inv_c(i)+(h_c/2), y_predc(i)); % use predictor y to predict slope @ midpoint
    y_c(i+1) = y_c(i) + yp_midc * h_c; % corrector, compute improved y
end

% [t_c, y_c] = midptode(dydt, t_span, y(0), h_c);

plot(inv_c, y_c);
% plot(t_c, y_c);

% (d) 4th-order RK method w/ h = 0.5
h_d = 0.5;
inv_d = (0:h_d:1);
n_d = length(inv_d);
y_d = y(0) * ones(n_d, 1);
k1 = zeros(n_d-1, 1);
k2 = zeros(n_d-1, 1);
k3 = zeros(n_d-1, 1);
k4 = zeros(n_d-1, 1);
y_mid1 = zeros(n_d-1, 1);
y_mid2 = zeros(n_d-1, 1);
y_end = zeros(n_d-1, 1);
phi = zeros(n_d-1, 1);

for i = 1:n_d-1
    k1(i) = dydt(inv_d(i), y_d(i)); % compute slope @ beginning of interval
    y_mid1(i) = y_d(i) + k1(i) * (h_d / 2); % compute y @ midpoint
    k2(i) = dydt(inv_d(i)+(h_d/2), y_mid1(i)); % compute slope @ midpoint
    y_mid2(i) = y_d(i) + k2(i) * (h_d / 2); % compute y @ another midpoint
    k3(i) = dydt(inv_d(i)+(h_d/2), y_mid2(i)); % compute slope @ another midpoint
    y_end(i) = y_d(i) + k3(i) * h_d; % compute y @ end of interval
    k4(i) = dydt(inv_d(i+1), y_end(i)); % compute slope @ end of interval
    phi(i) = (1 / 6) * (k1(i) + (2 * k2(i)) + (2 * k3(i)) + k4(i)); % compute average slope
    y_d(i+1) = y_d(i) + phi(i) * h_d; % compute final y prediction
end

% [t_d, y_d] = rk4ode(dydt, t_span, y(0), h_d);

plot(inv_d, y_d);
% plot(t_d, y_d);

legend('(a) analytical', '(b) Euler''s method, h = 0.5', '(b) Euler''s method, h = 0.25', '(c) midpoint method, h = 0.5', '(d) 4th-order RK method, h = 0.5');
hold off;

disp('-------------------------------------------------');
