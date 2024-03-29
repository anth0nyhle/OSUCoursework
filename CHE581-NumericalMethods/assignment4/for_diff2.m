function [xx, f_prime] = for_diff2(func, n, x)
% 2nd-order accurate forward finite-diff approx method
% Input:
%     func: function
%     n: number of steps
%     x: interval
% Output:
%     xx: restricted domain
%     f_prime: diff approx at each xx point

h = 1 / n; % step size
xx = x(1:n-2)'; % restrict domain

f_prime = zeros(length(xx), 1); % allocate memory for faster computing

for i = 1:n-2
    ffdm = (-func(x(i+2)) + (4 * func(x(i+1))) - (3 * func(x(i)))) / (2 * h);
    f_prime(i, 1) = ffdm;
end

end