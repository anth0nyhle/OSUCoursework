% [ind,num_nodes] = get_start(map)
% By Geoff Hollinger, 2007
%
% Returns the starting node for the 2D kinematics problem.

function [ind,num_nodes] = get_start(map)

%starting cell always 1
ind = index_from_state(map,1,1);

%also returns number of nodes
num_nodes = map.R*map.C;