function dy = deriv(x,y,type)
%deriv calculates the derivative of a set of data (x,y). It takes in the
%data and derivative approximation type as arguments, and returns a
%single array with the derivative. First order accurate first derivative.
%Type = 'c' for centered, 'b' for backward, 'f' for forward

xh = x(1:end-1)-x(2:end);
if abs(sum(xh - mean(xh))) > eps
    error('point spacing not even')
else
    h = abs(mean(xh));
end

clear dy
if type == 'c' %Centered
    for i = 2:length(y)-1
        dy(i) = (y(i+1)-y(i-1)) / (2*h);
    end
elseif type == 'b' %Backward
    for i = 2:length(y)
        dy(i) = (y(i)-y(i-1)) / (h);
    end
elseif type == 'f' %Forward
    for i = 1:length(y)-1
        dy(i) = (y(i+1)-y(i)) / (h);
    end
else
    error('type incorrectly specified')
end

end