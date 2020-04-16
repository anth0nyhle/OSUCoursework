%Returns reward for being a location in the maze
function [reward] = get_reward(maze,cur)

reward = maze.reward(cur);

end

