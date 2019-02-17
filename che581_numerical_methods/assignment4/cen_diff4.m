function [xx, f_prime] = cen_diff4(func, n, x)

h = 1 / n;
xx = x(2:n-1)';

f_prime = zeros(length(xx), 1);

for i = 3:length(xx)-2
    cfdm = (-func(xx(i+2)) + (8 * func(xx(i+1))) - (8 * func(xx(i-1))) + func(xx(i-2))) / (12 * h);
    f_prime(i, 1) = cfdm;
end

end