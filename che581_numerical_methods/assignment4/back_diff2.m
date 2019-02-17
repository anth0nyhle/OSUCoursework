function [xx, f_prime] = back_diff2(func, n, x)

h = 1 / n;
xx = x(2:n-1)';

f_prime = zeros(length(xx), 1);

for i = 3:length(xx)
    bfdm = ((3 * func(xx(i))) - (4 * func(xx(i-1))) + func(xx(i-2))) / (2 * h);
    f_prime(i, 1) = bfdm;
end

end