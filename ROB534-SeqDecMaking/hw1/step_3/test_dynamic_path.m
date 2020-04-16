% Function for testing paths in 4D dynamics problem
% By Geoff Gordon and Geoff Hollinger, 2007

%Displays a path on the 2D map given by the path input vector.
%Path is a vector of (x,y) coordinates with format:
%path(1,:) = [x1 y1]
%path(2,:) = [x2 y2]
%etc...

function test_dynamic_path(map, path)

figure(1)
imagesc(map.cells')
for i = 1: size(path,1)-1
    line([path(i,1) path(i+1,1)], [path(i,2) path(i+1,2)]);
end