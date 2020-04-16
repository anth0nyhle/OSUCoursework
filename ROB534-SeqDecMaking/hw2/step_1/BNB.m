function [p_star, z_star] = BNB(current_node, goal_node, budget, path, p_star, z_star, map)
    
    budget = budget - 1;
    nodes = get_nodes(current_node, goal_node, budget, map);
  
    z = 0;
    
    for i = 1:size(path, 1)
        node_info = findInformation(path(i, 1), path(i, 2), map);
        z = z + node_info;
    end
    
    if size(nodes, 1) < 1
        if z > z_star
            p_star = path;
            z_star = z;
        end
        return
    end
    
    for j = 1:size(nodes, 1)
        p_temp = [path; nodes(j, :)];
        if get_ubound(nodes(j, :), goal_node, budget, map) + z > z_star
            [p_star, z_star] = BNB(nodes(j, :), goal_node, budget, p_temp, p_star, z_star, map);
        end
    end
    
end

