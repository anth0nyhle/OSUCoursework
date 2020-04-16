% Function for testing paths in informative path planning problems
% By Geoff Hollinger, 2015

%Displays a path on the map given by the path input vector.
%Path is a vector of (x,y) coordinates with format:
%path(1,:) = [x1 y1]
%path(2,:) = [x2 y2]
%etc...

function plotPath(XY, map, title_name)

figure(1);
colors=['w' 'k'];
[X,Y,Z] = generateVis(map);
surf(Z);

colormap(jet);
title(title_name,'FontSize',20);

maxi = max(max(Z));

for i = 1: size(XY,1)-1
    Cindex = mod(i,2);
    line('Xdata',[XY(i,1) XY(i+1,1)], 'Ydata',[XY(i,2) XY(i+1,2)],'Zdata', [maxi maxi],'Color',colors(Cindex+1),'LineWidth',4);
end
view(2)