% Anthony Le
% ROB 534: SDM, Winter 2017
% HW #2: Optimization and Informative Path Planning
% 02-20-2017

% Programming Assignment
% Step 2
clear all; clc; close all
%% Step 2(i): Implement your own algorithm (random-restart)
load('newMaps.mat');

map = mapTestBig;

path_log = [];
info_log = [];
best_path = [];
best_path_info = 0;

tic;
for k = 1:1:1000000
    budget = 30;
    start_node = [1, 1];
    goal_node = [map.sideSize, map.sideSize];
    path = [start_node];
    
    while budget > 0
        prob_ind = 0;
        current_node = path(end, :);
        possibleActions = {[0, 1]; [1, 0]; [0, -1]; [-1, 0]; [0, 0]};
        
        feasible_nodes = [];
        info_list = [];

        for i = 1:size(possibleActions, 1)
            new_node = current_node + possibleActions{i};
            new_node_dist = get_dist(new_node, goal_node);
            if new_node(1) <= 0 || new_node(1) > map.sideSize || new_node(2) <= 0 || new_node(2) > map.sideSize 
                continue
            elseif new_node_dist > budget - 1
                continue
            else
                feasible_nodes = [feasible_nodes; new_node];
            end
        end

        %for i = 1:size(feasible_nodes, 1)
        %    node_info = findInformation(feasible_nodes(i, 1), feasible_nodes(i, 2), map);
        %    info_list = [info_list; node_info];
        %end

        %[max_info, max_ind] = max(info_list);
        prob_ind = randi(size(feasible_nodes, 1));

        path = [path; feasible_nodes(prob_ind, :)];

        budget = budget - 1;
    end
    
    path_info = evaluatePath(path, map);
    
    if path_info > best_path_info
        best_path_info = path_info;
        best_path = path;
    else
        continue
    end
    
    %path_log = [path_log, [new_path]];
    %info_log = [info_log; evaluatePath(new_path, map)];
    
end
RunTime = toc;

plotPath(best_path, map, 'Map Big for Budget 30');
m1 = sprintf('Run time = %5.4f seconds', RunTime);
disp(m1);


%[max_info, max_ind] = max(info_log);
%ind1 = (max_ind * 2) - 1;
%ind2 = (max_ind * 2);
%best_path = path_log(:, ind1:ind2);

%plotPath(best_path, map, '');
%gathered_info = evaluatePath(best_path, map);