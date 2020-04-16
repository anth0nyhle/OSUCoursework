%Makes a noisy move in a maze
%Input (maze): maze structure
%Input (cur): current robot location
%Input (dir): intended direction
%Input (noise): movement choice (chance of being unsuccessful)
function next = move_maze(maze,cur,dir,noise)
%generate random number
randomMove = rand();

%if we successfully moved to intended location
if(randomMove > noise)
   trueDir = dir;
%otherwise move randomly
else
   trueDir = floor(4*rand()) + 1;
end

%check if this is a valid move
next = is_move_valid(maze,cur,trueDir);
%if not, stay still
if(next == -1)
    next = cur;
end

end