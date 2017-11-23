%returns starting location in maze
function [ind,num_nodes] = get_start(map)

%starting cell always 1
ind = 1;

%also returns number of nodes
num_nodes = map.R*map.C;
end
