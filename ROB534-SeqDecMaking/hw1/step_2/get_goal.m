% goal = get_goal(map)
% By Geoff Hollinger, 2007
%
% Goal function for the map without dynamics.
% Agent must stop in the bottom right corner.

function goal = get_goal(map)

goal = index_from_state(map,map.C,map.R);