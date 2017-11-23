%Returns observation of target or non-target for maze search problem
function obs = getObservation(maze,cur)
%Target is at this location
if(maze.reward(cur) == 1)
    obs = 1;
%Target is not at this location
else
    obs = 0;
end

end

