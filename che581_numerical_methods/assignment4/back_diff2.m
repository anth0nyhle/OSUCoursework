function [xx, f_prime] = back_diff2(func, n, x)
% 2nd-order accurate backward finite-diff approx method
% Input:
%     func: function
%     n: number of steps
%     x: interval
% Output:
%     xx: restricted domain
%     f_prime: diff approx at each xx point

h = 1 / n; % step size
xx = x(3:n-2)'; % restrict domain

f_prime = zeros(length(xx), 1); % allocate memory for faster computing

for i = 3:n-2
    bfdm = ((3 * func(x(i))) - (4 * func(x(i-1))) + func(x(i-2))) / (2 * h);
    f_prime(i-2, 1) = bfdm;
end

end