function [possible_nodes] = get_nodes(current_node, goal_node, budget, map)
    possibleActions = {[0, 1]; [1, 0]; [0, -1]; [-1, 0]; [0, 0]};
    possible_nodes = [];
    
    for i = 1:size(possibleActions, 1)
        new_node = current_node + possibleActions{i, :};
        node_dist = get_dist(new_node, goal_node);
        if new_node(1) <= 0 || new_node(1) > map.sideSize || new_node(2) <= 0 || new_node(2) > map.sideSize 
            continue
        elseif node_dist > budget
            continue
        else
            possible_nodes = [possible_nodes; new_node];
        end
    end


end

