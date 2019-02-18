% Created by: Anthony H. Le
% Last updated: 02-18-2019

% CHE 581: Assignment 4
% Textbook Problems 21.13, 21.28, Additional Problem
% Due: 02-18-2019
%% Problem 21.13
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 21.13');

% data provided by textbook
t = [0 2 4 6 8 10 12 14 16]'; % time, s
x = [0 0.7 1.8 3.4 5.1 6.3 7.3 8.0 8.4]; % position, m
h = 2; % step size, time, s
i = 6; % index @ t = 10

% plot data to visualize function
disp('Plot generated for visualization, see Figure 1');
figure();
plot(t, x, '-*');
hold on;
xlabel('Time (s)');
ylabel('Position (m)');
hold off;

% (a) 2nd-order accurate centered finite-diff method
disp('(a) O(h^2) centered finite-difference method');
v_a = (x(i+1) - x(i-1)) / (2 * h); % velocity @ t = 10, m/s
a_a = (x(i+1) - (2 * x(i)) + x(i-1)) / (h^2); % acceleration @ t = 10, m/s^2
fprintf('    vel = %5.4f\n', v_a);
fprintf('    accel = %5.4f\n', a_a);

% (b) 2nd-order accurate forward finite-diff method
disp('(b) O(h^2) forward fiite-difference method');
v_b = (-x(i+2) + (4 * x(i+1)) - (3 * x(i))) / (2 * h); % velocity @ t = 10, m/s
a_b = (-x(i+3) + (4 * x(i+2)) - (5 * x(i+1)) + (2 * x(i))) / (h^2); % acceleration @ t = 10, m/s^2
fprintf('    vel = %5.4f\n', v_b);
fprintf('    accel = %5.4f\n', a_b);

% (c) 2nd-order accurate backward finite-diff method
disp('(c) O(h^2) backward finite-difference method');
v_c = ((3 * x(i)) - (4 * x(i-1)) + x(i-2)) / (2 * h); % velocity @ t = 10, m/s
a_c = ((2 * x(i)) - (5 * x(i-1)) + (4 * x(i-2)) - x(i-3)) / (h^2); % acceleration @ t = 10, m/s^2
fprintf('    vel = %5.4f\n', v_c);
fprintf('    accel = %5.4f\n', a_c);

disp('-------------------------------------------------');

%% Problem 21.28
close all;
clear;
clc;

disp('Problem 21.28');
disp('See Figure 1');

% data provided by textbook
time = [0 5 10 15 20 25]'; % time, min
T = [80 44.5 30.0 24.1 21.7 20.7]'; % temperature, deg C
T_a = 20; % temperature, deg C
n_a = length(time); % vec length
h = 5; % step size, min

dTdt = zeros(n_a, 1); % allocate memory for faster computing

for i = 1:n_a % mixed finite-diff method, all 2nd-order accurate
    if i == 1 % forward finite-diff method, first point
        diff = (-T(i+2) + 4 * T(i+1) - 3 * T(i)) / (2 * h);
        dTdt(i, 1) = diff;
    elseif i >= 2 && i < n_a % center finite-diff method, interior points
        diff = (T(i+1) - T(i-1)) / (2 * h);
        dTdt(i, 1) = diff;
    elseif i == n_a % backward finite-diff method, last point
        diff = (3 * T(i) - 4 * T(i-1) + T(i-2)) / (2 * h);
        dTdt(i, 1) = diff;
    end
end

% simple linear regression
p_fit = polyfit(T-T_a, dTdt, 1); % compute linear regression
y_fit = polyval(p_fit, T-T_a); % compute y fit values
y_resid = dTdt - y_fit; % residual values
SS_resid = sum(y_resid.^2); % residual sum of squares
SS_total = sum((dTdt - mean(dTdt)).^2); % total sum of squares
rsq = 1 - (SS_resid / SS_total); % compute R^2 value
fprintf('slope = %5.4f\ny-int = %5.4f\n', p_fit(1), p_fit(2));

% dT/dt vs (T-T_a) w/ linear regression
figure();
plot(T-T_a, dTdt, 'o');   
hold on;
plot(T-T_a, y_fit);
title('Linear regression relation b/w \itdT/dt & \it(T-T_{a})');
legend('data', ['linear fit\newlineR^{2} = ' num2str(rsq)]);
xlabel('\it (T - T_{a}) \rm (\circC)');
ylabel('\it dT/dt \rm (\circC/min)');
hold off;

disp('-------------------------------------------------');
