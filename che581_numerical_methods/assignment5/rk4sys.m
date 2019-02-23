function [tp, yp] = rk4sys(dydt, t_span, y0, h, varargin)
% rk4sys: 4th-order Runge-Kutta for a system of ODEs
% [t, y] = rk4sys(dydt, t_span, y_0, h, p1, p2,...): integrates a system
%          of ODEs with 4th-order RK method
% input:
%     dydt = name of the M-file that evaluates the ODEs
%     t_span = [ti, tf]; initial and final times with output generated at
%     interval of h, or = [t0, t1, ..., tf]; specific times where solutions
%     output
%     y0 = initial values of dependent variables
%     h = step size
%     p1, p2,... = additional parameters used by dydt
% output:
%     tp = vector of independent variable
%     yp = vector of solution for dependent variables

if nargin < 4
    error('at least 4 input arguments required');
end

if any(diff(t_span) <= 0)
    error('t_span not ascending order');
end

n = length(t_span);
ti = t_span(1);
tf = t_span(n);

if n == 2
    t = (ti:h:tf)';
    n = length(t);
    if t(n) < tf
        t(n+1) = tf;
        n = n + 1;
    end
else
    t = t_span;
end

tt = ti;
y(1, :) = y0;
np = 1;
tp(np) = tt;
yp(np, :) = y(1, :);
i = 1;

while(1)
    t_end = t(np+1);
    hh = t(np+1) - t(np);
    if hh > h
        hh = h;
    end
    while(1)
        if tt + hh > t_end
            hh = t_end - tt;
        end
        k1 = dydt(tt, y(i, :), varargin{:})';
        y_mid1 = y(i, :) + k1 .* hh ./ 2;
        k2 = dydt(tt + hh / 2, y_mid1, varargin{:})';
        y_mid2 = y(i, :) + k2 * hh / 2;
        k3 = dydt(tt + hh, y_mid2, varargin{:})';
        y_end = y(i, :) + k3 * hh;
        k4 = dydt(tt + hh, y_end, varargin{:})';
        phi = (k1 + 2 * (k2 + k3) + k4) / 6;
        y(i+1, :) = y(i, :) + phi * hh;
        tt = tt + hh;
        i = i + 1;
        if tt >= t_end
            break;
        end
    end
    np = np + 1;
    tp(np) = tt;
    yp(np, :) = y(i, :);
    if tt >= tf
        break;
    end
end
        

end