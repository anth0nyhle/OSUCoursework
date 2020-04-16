function [t, y] = eulode(dydt, t_span, y0, h)
% eulode: Euler ODE soler
% [t, y] = eulode(dydt, tspan, y0, h, p1, p2,...):
%          uses Euler's method to integrate an ODE
% input:
%     dydt = name of the M-file that evaluates the ODE
%     t_span = [ti, tf] where ti and tf = initital and final values of
%     independent variable
%     y0 = initial value of dependent variable
%     h = step size
%     p1, p2,... = additional parameters used by dydt
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

% if necessary, add an additional value of t so that range goes from t =
% t_i to t_f

if t(n) < tf
    t(n + 1) = tf;
    n = n + 1;
end

y = y0 * ones(n, 1); % preallocate y to improve efficiency

for i = 1:n-1 % implement Euler's method
    y(i+1) = y(i) + dydt(t(i), y(i)) * (t(i+1) - t(i));
end

end
