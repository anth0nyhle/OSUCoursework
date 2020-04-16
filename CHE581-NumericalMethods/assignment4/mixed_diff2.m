function [xx, f_prime] = mixed_diff2(func, n, x)
% 2nd-order mixed finite-diff approx method
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

for i = 1:length(xx) % mixed finite-diff method, all 2nd-order accurate
    if i == 1 % forward finite-diff method, first point
        ffdm = (-func(xx(i+2)) + (4 * func(xx(i+1))) - (3 * func(xx(i)))) / (2 * h);
        f_prime(i, 1) = ffdm;
    elseif i >= 2 && i < n % center finite-diff method, interior points
        cfdm = (func(xx(i+1)) - func(xx(i-1))) / (2 * h);
        f_prime(i, 1) = cfdm;
    elseif i == n % backward finite-diff method, last point
        bfdm = ((3 * func(xx(i))) - (4 * func(xx(i-1))) + func(xx(i-2))) / (2 * h);
        f_prime(i, 1) = bfdm;
    end
end

end

