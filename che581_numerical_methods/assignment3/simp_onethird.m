function [I, S] = simp_onethird(func, a, b, n, varargin)
% simp_onethird: composite Simpson's 1/3 Rule
% [I, S] = simp_onethird(func, a, b, n, pl, p2,...)
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
S = zeros(n/2, 1); % allocate memory based on n number of segments

% modified trap code
for i = 1:n/2
    x_1 = x_0 + base_w;
    x_2 = x_1 + base_w;
    s = (x_2 - x_0) * (((func(x_0, varargin{:}) + (4 * func(x_1, varargin{:})) + func(x_2, varargin{:}))) / 6);
    S(i, 1) = s;
    x_0 = x_2;
end

I = sum(S);

end