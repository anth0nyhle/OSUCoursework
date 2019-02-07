function I = trap(func, a, b, n, varargin)
% trap: compositie trapezoidal rule quadrature
% I = trap(func, a, b, n, pl, p2,...): compositie trapezoidal rule
% input:
%   func = name of the function to be integrated
%   a, b = integration limits
%   n = number of segments (default = 100)
%   p1, p2,... = additional parameters used by func
% output:
%   I = integral estimate

if nargin < 3
    error('at least 3 input arguments reguired');
end

if ~(b > a)
    error('upper bound must be greater than lower');
end

if nargin < 4 || isempty(n)
    n = 100;
end

x = a;
h = (b - a) / n;
s = func(a , varargin{:});

for i = 1:n-1
    x = x + h;
    s = s + 2 * func(x, varargin{:});
end

s = s + func(b, varargin{:});
I = (b - a) * s / (2 * n);

end

