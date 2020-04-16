% goal = get_goal_dynamic(map)
% By Geoff Hollinger, 2007
%
% Goal function for the map with dynamics.
% Agent must stop in the bottom left corner with zero dx, dy.

function goal = get_goal_dynamic(map)

goal = dynamic_index_from_state(map,map.C,map.R,0,0);