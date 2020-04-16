%Generates a 2D map at the specified resolution given information sources
%and their standard deviations

%Geoff Hollinger, 2015

%Inputs:
%sideSize - size of length/width of square map
%sources - vector of 2D sources locations
%sourceStd - standard deviations of sources

function [X,Y,Z] = generateVis_Fixed(map)
X = zeros(map.sideSize,map.sideSize);
Y = zeros(map.sideSize,map.sideSize);
Z = zeros(map.sideSize,map.sideSize);
for i = 1:map.sideSize
    for j = 1:map.sideSize
        X(i,j) = j;
        Y(i,j) = i;
        Z(j,i) = 0;
        for k = 1:map.numSources
            Z(j,i) = Z(j,i) + exp(-sqrt(sum(([i j]-map.sources(k,1:2)).^2))/map.sourceStd(k));
        end
    end
end

surf(Z);

end