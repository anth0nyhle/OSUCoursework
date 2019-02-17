function [xx, f_prime] = for_diff2(func, n, x)

h = 1 / n;
xx = x(2:n-1)';

f_prime = zeros(length(xx), 1);

for i = 1:length(xx)-2
    ffdm = (-func(xx(i+2)) + (4 * func(xx(i+1))) - (3 * func(xx(i)))) / (2 * h);
    f_prime(i, 1) = ffdm;
end

end