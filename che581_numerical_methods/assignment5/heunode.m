function [t, y] = heunode(dydt, t_span, y0, h, e_critn, plot_title, plot_xlabel, plot_ylabel)
% heunode: Heun ODE soler
% [t, y] = heunode(dydt, tspan, y0, h, p1, p2,...):
%          uses Heun's method to integrate an ODE w/ iterations
% input:
%     dydt = name of the M-file that evaluates the ODE
%     t_span = [ti, tf] where ti and tf = initital and final values of
%     independent variable
%     y0 = initial value of dependent variable
%     h = step size
%     e_critn = error criterion for corrector iterations
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
    y_pred = y(i) + yp_int * h; % predictor, compute y @ next step
    while (1)
        yp_end = dydt(t(i+1), y_pred); % use predictor y to predict slope @ end of the interval
        yp_avg = (yp_int + yp_end) / 2; % average initial and predicted slopes
        y_corr = y(i) + yp_avg * h; % corrector, compute improved y @ next step
        e_a = abs((y_corr - y_pred) / y_corr) * 100; % compute approx percent relative error
        if e_a < e_critn
            y(i+1) = y_corr;
            break;
        else
            y_pred = y_corr; % iterate, refine prediction
        end
    end
end

figure();
plot(t, y);
title(plot_title);
xlabel(plot_xlabel);
ylabel(plot_ylabel);

end