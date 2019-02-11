function [I, S] = twoDtrap(func, ax, bx, ay, by, n, varargin)
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

x_a = ax; % initialize 1st x point
y_a = ay; % initialize 1st y point
% h = (b - a) / n;
% s = func(a , varargin{:});
wx = (bx - ax) / n; % base width, dependent on n number of segments
wy = (by - ay) / n; % base width, dependent on n number of segments
S = zeros(n, 2); % allocate memory based on n number of segments

% modified trap code
for i = 1:n
    for j = 1:n
        x_b = x_a + wx; % next point
        avg_hx = (func(x_a, varargin{:}) + func(x_b, varargin{:})) / 2; % avg height
        sx = wx * avg_hx; % area
        S(i, 1) = sx; % store computed area of segment
        x_a = x_b; % next segment
    end
end

I = sum(S); % sum of all segment areas

% original trap code from textbook
% for i = 1:n-1
%     x = x + h;
%     s = s + 2 * func(x, varargin{:});
% end
% 
% s = s + func(b, varargin{:});
% I = (b - a) * s / (2 * n);

end