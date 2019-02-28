function dy = deriv2O2(x,y,type)
%deriv calculates the derivative of a set of data (x,y). It takes in the
%data and derivative approximation type as arguments, and returns a
%single array with the derivative. Second order accurate second derivative.
%Type = 'c' for centered, 'b' for backward, 'f' for forward

xh = x(1:end-1)-x(2:end);
if sum(xh - mean(xh)) ~= 0
    error('point spacing not even')
else
    h = abs(mean(xh));
end

clear dy
if type == 'c' %Centered
    for i = 2:length(y)-1
        dy(i) = (y(i+1)-2*y(i)+y(i-1)) / (h^2);
    end
elseif type == 'b' %Backward
    for i = 4:length(y)
        dy(i) = (2*y(i)-5*y(i-1)+4*y(i-2)-y(i-3)) / (h^2);
    end
elseif type == 'f' %Forward
    for i = 1:length(y)-3
        dy(i) = (-y(i+3)+4*y(i+2)-5*y(i+1)+2*y(i)) / (h^2);
    end
else
    error('type incorrectly specified')
end

end