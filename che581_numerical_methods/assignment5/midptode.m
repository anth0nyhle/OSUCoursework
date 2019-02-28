function [t, y] = midptode(dydt, t_span, y0, h, plot_title, plot_xlabel, plot_ylabel)
% midptode: Midpoint ODE soler
% [t, y] = midptode(dydt, tspan, y0, h, p1, p2,...):
%          uses midpoint method to integrate an ODE w/ iterations
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
    yp_int = dydt(t(i), y(i));
    y_pred = y(i) + yp_int * (h / 2); % predictor, compute y @ midpoint
    yp_mid = dydt(t(i)+(h/2), y_pred); % use predictor y to predict slope @ midpoint
%     yp_avg = (yp_int + yp_mid) / 2; % average initial and predicted slopes
%     y(i+1) = y(i) + yp_avg * h; % corrector, compute improved y
    y(i+1) = y(i) + yp_mid * h; % corrector, compute improved y
end

figure();
plot(t, y);
title(plot_title);
xlabel(plot_xlabel);
ylabel(plot_ylabel);

end