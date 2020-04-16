% [X,Y] = maze_XY_from_index(maze,index)
% By Jeremy Kubica, 2003
%
% Gets the X and Y coordinates of the location at index.
% Does NO bounds checking.
function [X,Y] = maze_XY_from_index(maze,index)

% find the current location
X = ceil(index / maze.R);
Y = mod(index, maze.R);
if(Y == 0)
   Y = maze.R;
end