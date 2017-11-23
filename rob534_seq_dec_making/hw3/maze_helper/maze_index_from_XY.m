% index = maze_index_from_XY(maze,X,Y)
% By Jeremy Kubica, 2003
%
% Gets the index from the X and Y coordinates.
% Does NO bounds checking.
function index = maze_index_from_XY(maze,X,Y)

index = ((X-1) * maze.R) + Y;