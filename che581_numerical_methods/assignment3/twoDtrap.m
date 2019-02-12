function I = twoDtrap(func, ax, bx, ay, by, n, varargin)

x_a = ax; % initialize 1st x point
y_a = ay; % initialize 1st y point
wx = (bx - ax) / n; % base width, dependent on n number of segments
wy = (by - ay) / n; % base width, dependent on n number of segments
SX = []; % allocate memory based on n number of segments
SXY = [];

% modified trap code for 2-dim integration
% for i = 1:n-2
%     y_b = y_a + (wy / 2); % next point
%     y_c = y_b + (wy / 2);
%     for j = 1:n
%         x_b = x_a + (wx / 2); % next point
%         x_c = x_b + (wx / 2);
%         avg_hx = (func(x_a, y_a, varargin{:}) + (2 * func(x_b, y_b, varargin{:})) + func(x_c, y_c, varargin{:})) / 4; % avg height
%         sx = wx * avg_hx;
%         SX(j, 1) = sx; % store computed area of segment
%         x_a = x_c; % next segment
%     end
%     avg_hy = (SX(i) + (2 * SX(i+1)) + SX(i+2)) / 4;
%     sxy = wy * avg_hy;
%     SXY(i, 1) = sxy;
%     y_a = y_c; % next segment
% end
% 
% I = sum(SXY); % sum of all segment areas

% modified trap code for 2-dim integration
for i = 1:n
    for j = 1:n
        x_b = x_a + wx; % next point
        avg_hx = (func(x_a, y_a, varargin{:}) + func(x_b, y_a, varargin{:})) / 2; % avg height
        sx = wx * avg_hx;
        SX(j, i) = sx; % store computed area of segment
        x_a = x_b; % next segment
    end
    y_b = y_a + wy; % next point
    y_a = y_b; % next segment
end

SX = sum(SX, 1);

for k = 1:n-1
    avg_hy = (SX(k) + SX(k+1)) / 2;
    sxy = wy * avg_hy;
    SXY(k, 1) = sxy;
end

I = sum(SXY); % sum of all segment areas

end