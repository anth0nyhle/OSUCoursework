% nindex = is_move_valid(maze,index,move)
% By Jeremy Kubica, 2003
%
% Checks the validity (maze walls, bounds, etc.) of a given
% move.  If the move is valid, it returns the NEW index.  If
% the move is NOT valid it returns -1.  Note: move can take the
% following possible values:
%   move = 1 -> NORTH
%   move = 2 -> EAST
%   move = 3 -> SOUTH
%   move = 4 -> WEST
function nindex = is_move_valid(maze,index,move)

nindex = -1;

% find the dimensions of the maze
Y = maze.R;
X = maze.C;

% do very basic error checking on present location
if ((index <= 0)|(index > X*Y))
   return;
end


% find the current location
cX = ceil(index / Y);
cY = mod(index, Y);
if(cY == 0)
   cY = Y;
end


% check the northern move
if(move == 1)
   
   % find the location and index of the neighboring cell
   cellNeighbor = index - 1;
   nY = cY - 1;
   nX = cX;
   
   % first check for a wall then for bounds
   if (maze.adjacent(index,1) == 1) & (nY > 0)
      nindex = cellNeighbor;
   end
end


% check the southern move
if(move == 3)
   
   % find the location and index of the neighboring cell
   cellNeighbor = index + 1;
   nY = cY + 1;
   nX = cX;
   
   % first check for a wall then for bounds
   if (maze.adjacent(index,3) == 1) & (nY <= Y)
      nindex = cellNeighbor;
   end
end


% check the eastern move
if(move == 2)
   
   % find the location and index of the neighboring cell
   cellNeighbor = index + Y;
   nY = cY;
   nX = cX + 1;
   
   % first check for a wall then for bounds
   if (maze.adjacent(index,2) == 1) & (nX <= X)
      nindex = cellNeighbor;
   end
end


% check the western move
if(move == 4)
   
   % find the location and index of the neighboring cell
   cellNeighbor = index - Y;
   nY = cY;
   nX = cX - 1;
   
   % first check for a wall then for bounds
   if (maze.adjacent(index,4) == 1) & (nX > 0)
      nindex = cellNeighbor;
   end
end
         