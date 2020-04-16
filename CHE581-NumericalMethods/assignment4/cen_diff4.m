function [xx, f_prime] = cen_diff4(func, n, x)
% 4th-order accurate centered finite-diff approx method
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
    cfdm = (-func(x(i+2)) + (8 * func(x(i+1))) - (8 * func(x(i-1))) + func(x(i-2))) / (12 * h);
    f_prime(i-2, 1) = cfdm;
end

end