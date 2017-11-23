%Moves the target in the search/tracking maze scenario
%Input (maze): maze structure
%Output (newMaze): updated maze structure
function newMaze = moveTarget(maze)

%find target's current location
cur = find(maze.reward == 1);
%target moves in random direction
dir = floor(rand()*4)+1;
next = move_maze(maze,cur,dir,0.0);
%if hits wall, stays till
if(next == -1)
    next = cur;
end
%change reward location
maze.reward(cur) = 0;
maze.reward(next) = 1;

newMaze = maze;

end