% map = read_map_for_dynamics
% By Geoff Hollinger, 2007
%
% Reads in a map for use in the 4D dynamics maze problem.
% Provide filename of binary pgm: 
% i.e map = read_map_for_dynamics('dynamics1.pgm')

function map = read_map_for_dynamics(filename)

im = imread(filename);
im(find(im == 0)) = 1;
im(find(im == 255)) = 0;
im = double(im);
im = im';
map.R = size(im,1);
map.C = size(im,1);
map.maxV = 2;
map.cells = im;
imagesc(map.cells');