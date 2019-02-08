function [I, S] = trap(func, a, b, n, varargin)
% trap: composite trapezoidal rule quadrature
% [I, S] = trap(func, a, b, n, pl, p2,...): compositie trapezoidal rule
% input:
%   func = name of the function to be integrated
%   a, b = integration limits
%   n = number of segments (default = 100)
%   p1, p2,... = additional parameters used by func
% output:
%   I = integral estimate
%   S = array of segment values (n segments)

if nargin < 3
    error('at least 3 input arguments reguired');
end

if ~(b > a)
    error('upper bound must be greater than lower');
end

if nargin < 4 || isempty(n)
    n = 100;
end

x_a = a; % initialize 1st x point
% h = (b - a) / n;
% s = func(a , varargin{:});
base_w = (b - a) / n; % base width, dependent on n number of segments
S = zeros(n, 1); % allocate memory based on n number of segments

% modified trap code
for i = 1:n
    x_b = x_a + base_w;
    avg_h = (func(x_a, varargin{:}) + func(x_b, varargin{:})) / 2;
    s = base_w * avg_h;
    S(i, 1) = s;
    x_a = x_b;
end

I = sum(S);

% original trap code from textbook
% for i = 1:n-1
%     x = x + h;
%     s = s + 2 * func(x, varargin{:});
% end
% 
% s = s + func(b, varargin{:});
% I = (b - a) * s / (2 * n);

end

