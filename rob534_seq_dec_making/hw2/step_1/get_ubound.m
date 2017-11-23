function [ubound] = get_ubound(current_node, goal_node, budget, map)
    reachables = [];
    nodes = [];
    ubound = 0;        
    
    for i = current_node(1):map.sideSize
        for j = current_node(2):map.sideSize
            nodes = [nodes; [i, j]];
        end
    end
    
    for k = 1:current_node(1)
        for l = 1:current_node(2)
            nodes = [nodes; [k, l]];
        end
    end
    
    for i = 1:size(nodes, 1)
        if get_dist(nodes(i, :), goal_node) > budget
            continue
        else
            reachables = [reachables; nodes(i, :)];
        end
    end
    
    for i = 1:size(reachables, 1)
        ub = findInformation(reachables(i, 1), reachables(i, 2), map);
        ubound = ubound + ub;
    end
    
end

