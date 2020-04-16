function [I, S] = simp_threeeight(func, a, b, n, varargin)
% simp_threeeight: composite Simpson's 3/8 Rule
% [I, S] = simp_threeeight(func, a, b, n, pl, p2,...)
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

x_0 = a; % initialize 1st x point
base_w = (b - a) / n; % base width, dependent on n number of segments
S = zeros(n/3, 1); % allocate memory based on n number of segments

for i = 1:n/3
    x_1 = x_0 + base_w;
    x_2 = x_1 + base_w;
    x_3 = x_2 + base_w;
    s = (x_3 - x_0) * (((func(x_0, varargin{:}) + (3 * func(x_1, varargin{:})) + (3 * func(x_2, varargin{:})) + func(x_3, varargin{:}))) / 8);
    S(i, 1) = s;
    x_0 = x_3;
end

I = sum(S);

end