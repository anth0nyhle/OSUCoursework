function [xx, f_prime] = cen_diff2(func, n, x)
% 2nd-order accurate centered finite-diff approx method
% Input:
%     func: function
%     n: number of steps
%     x: interval
% Output:
%     xx: restricted domain
%     f_prime: diff approx at each xx point

h = 1 / n; % step size
xx = x(2:n-1)'; % restrict domain

f_prime = zeros(length(xx), 1); % allocate memory for faster computing

for i = 2:n-1
    cfdm = (func(x(i+1)) - func(x(i-1))) / (2 * h);
    f_prime(i-1, 1) = cfdm;
end

end