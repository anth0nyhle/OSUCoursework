function [t, y] = rk4ode(dydt, t_span, y0, h, plot_title, plot_xlabel, plot_ylabel)
% heunode: Runge-Kutta ODE soler
% [t, y] = rk4ode(dydt, tspan, y0, h, p1, p2,...):
%          uses 4th-order Runge-Kutta method to integrate an ODE
% input:
%     dydt = name of the M-file that evaluates the ODE
%     t_span = [ti, tf] where ti and tf = initital and final values of
%     independent variable
%     y0 = initial value of dependent variable
%     h = step size
%     plot_title = plot title as string
%     plot_xlabel = x-axis label as string
%     plot_ylabel = y-axis label as string
% output:
%     t = vector of independent variable
%     y = vector of solution for dependent variable

if nargin < 4
    error('at least 4 input arguments required')
end

ti = t_span(1);
tf = t_span(2);

if ~(tf > ti)
    error('upper limit must be greater than lower')
end

t = (ti:h:tf)';
n = length(t);

if t(n) < tf
    t(n + 1) = tf;
    n = n + 1;
end

y = y0 * ones(n, 1);

for i = 1:n-1
    k1 = dydt(t(i), y(i)); % compute slope @ beginning of interval
    y_mid1 = y(i) + k1 * (h / 2); % compute y @ midpoint
    k2 = dydt(t(i)+(h/2), y_mid1); % compute slope @ midpoint
    y_mid2 = y(i) + k2 * (h / 2); % compute y @ another midpoint
    k3 = dydt(t(i)+(h/2), y_mid2); % compute slope @ another midpoint
    y_end = y(i) + k3 * h; % compute y @ end of interval
    k4 = dydt(t(i+1), y_end); % compute slope @ end of interval
    phi = (1 / 6) * (k1 + (2 * k2) + (2 * k3) + k4); % compute average slope
    y(i+1) = y(i) + phi * h; % compute final y prediction
end

figure();
plot(t, y);
title(plot_title);
xlabel(plot_xlabel);
ylabel(plot_ylabel);

end