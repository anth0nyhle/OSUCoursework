function intsum = trap3D(func, xl, xu, yl, yu, Xpts, Ypts)
%Approximates a double integral over a function of 2 variables using the
%trapezoidal rule.
%Usage: trap3D(function, xl, xu, yl, yu, Xpts, Ypts)
%Where xl and yl are the x and y low bound, xu and yu are the x and y upper
%bounds, Xpts is the number of grid points in the X direction, and Ypts is
%the number of grid points in the Y direction. This code will work with
%rectangular grids.

%Defines the grid points in y and x directions
Xpoints = linspace(xl,xu,Xpts);
Ypoints = linspace(yl,yu,Ypts);

%Find the area under each prism
Area = (Xpoints(2)-Xpoints(1))*(Ypoints(2)-Ypoints(1));

%Defines a grid of points for plotting the approximation
[Xpts,Ypts] = meshgrid(Xpoints,Ypoints);
z = func(Xpts,Ypts); %Solves the equation at each grid point.

intsum = 0;
for iY = 1:length(Ypoints)-1 %Loops through Y direction
    for iX = 1:length(Xpoints)-1 %Loops through X direction
        %Sums the volume of each prism/trapezoid in the grid
        intsum = intsum + (1/4)*Area*(func(Xpoints(iX),Ypoints(iY)) ...
            +func(Xpoints(iX+1),Ypoints(iY))+func(Xpoints(iX),Ypoints(iY+1)) ...
            +func(Xpoints(iX+1),Ypoints(iY+1)));
    end
end

%Plotting stuff
figure('Position',[200 200 1000 400])
subplot(1,2,1)
ezsurf(func,[xl,xu,yl,yu])
Xlim = xlim;
Ylim = ylim;
Zlim = zlim;
title('Real function')
subplot(1,2,2)
mesh(Xpts,Ypts,z)
title('Approximation')
axis([Xlim Ylim Zlim])
end