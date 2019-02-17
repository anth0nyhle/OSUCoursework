function [xx, f_prime] = cen_diff2(func, n, x)

h = 1 / n;
xx = x(2:n-1)';

f_prime = zeros(length(xx), 1);

for i = 2:length(xx)-1
    cfdm = (func(xx(i+1)) - func(xx(i-1))) / (2 * h);
    f_prime(i, 1) = cfdm;
end

end