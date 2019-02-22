function [t, y] = eulode(dydt, t_span, y_0, h, varargin)
% eulode: Euler ODE soler
% [t, y] = eulode(dydt, tspan, y0, h, p1, p2,...):
%          uses Euler's method to integrate an ODE
% input:
%     dydt = name of the M-file that evaluates the ODE
%     tspan = [t_i, t_f] where t_i and t_f = initital and final values of
%     independent variable
%     y_0 = initial value of dependent variable
%     h = step size
%     p1, p2,... = additional parameters used by dydt
% output:
%     t = vector of independent variable
%     y = vector of solution for dependent variable

if nargin < 4
    error('at least 4 input arguments required')
end

t_i = t_span(1); t_f = t_span(2);

if ~(t_f > t_i)
    error('upper limite must be greater than lower')
end

t = (t_i:h:t_f)'; n = length(t);

% if necessary, add an additional value of t so that range goes from t =
% t_i to t_f

if t(n) < t_f
    t(n + 1) = t_f;
    n = n + 1;
end

y = y_0 * ones(n, 1); % preallocate y to improve efficiency

for i = 1:n-1 % implement Euler's method
    y(i+1) = y(i) + dydt(t(i), y(i), varargin{:}) * (t(i+1) - t(i));
end

end
