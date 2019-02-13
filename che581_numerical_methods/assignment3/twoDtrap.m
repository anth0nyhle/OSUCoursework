function I = twoDtrap(func, ax, bx, ay, by, n, varargin)

x_a = ax; % initialize 1st x point
y_a = ay; % initialize 1st y point
wx = (bx - ax) / n; % base width, dependent on n number of segments
wy = (by - ay) / n; % base width, dependent on n number of segments
SXY = zeros(n, n); % allocate memory based on n number of segments

% modified trap code for 2-dim integration
for i = 1:n
    y_b = y_a + wy; % next point
    for j = 1:n
        x_b = x_a + wx; % next point
        avg_hx = (func(x_a, y_a, varargin{:}) + func(x_b, y_a, varargin{:}) + func(x_a, y_b, varargin{:}) + func(x_b, y_b, varargin{:})) / 4; % avg height
        sx = wy * wx * avg_hx; % volume
        SXY(j, i) = sx; % store computed area of segment
        x_a = x_b; % next segment
    end
    x_a = ax;
    y_a = y_b; % next segment
end

I = sum(sum(SXY)); % sum of all segment areas

end