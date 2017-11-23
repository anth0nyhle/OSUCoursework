% [ind,num_nodes] = get_start_dynamic(map)
% By Geoff Hollinger, 2007
%
% Returns the starting node for the 4D dynamics problem.

function [ind,num_nodes] = get_start_dynamic(map)

%starting cell always 1
ind = dynamic_index_from_state(map,1,1,0,0);

%also returns number of nodes
vels = map.maxV+1;
num_nodes = map.R*map.C*vels*vels;