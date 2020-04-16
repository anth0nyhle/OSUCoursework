% Anthony Le
% ROB 534: SDM, Winter 2017
% HW #2: Optimization and Informative Path Planning
% 02-20-2017

% Programming Assignment
% Step 1
clear all; clc; close all
%% Step 1(i): Implement greedy solver
%load maps from file
%mapTest1, mapTest2, mapTestBig
load('newMaps.mat');

%choose map to collect information in
map = mapTest2;

%determine the budget (6 or 8)
budget = 8;

start_node = [1, 1];
goal_node = [map.sideSize, map.sideSize];
path = [start_node];

tic;
while budget > 0
    %expands all possible moves, one step ahead, at current node
    N = [path(end, 1), path(end, 2) + 1];
    E = [path(end, 1) + 1, path(end, 2)];
    S = [path(end, 1), path(end, 2) - 1];
    W = [path(end, 1) - 1, path(end, 2)];
    still = [path(end, 1), path(end, 2)];

    %filters out moves that will lead off the map 
    if N(2) > map.sideSize
        N = [NaN, NaN];
    end
    if E(1) > map.sideSize
        E = [NaN, NaN];
    end
    if S(2) <= 0
        S = [NaN, NaN];
    end
    if W(1) <= 0
        W = [NaN, NaN];
    end
    
    %calucate Manhattan distances b/w where the move will end up and the
    %goal
    N_dist = get_dist(N, goal_node);
    E_dist = get_dist(E, goal_node);
    S_dist = get_dist(S, goal_node);
    W_dist = get_dist(W, goal_node);
    still_dist = get_dist(still, goal_node);
    
    distances = [N_dist; E_dist; S_dist; W_dist; still_dist];
    cell_step = {N, E, S, W, still};
    
    %filter out moves that will end up at a node that further away from the
    %goal compared to the remaining number of steps in the budget
    for i = 1:size(distances, 1)
        if distances(i) > budget - 1
            cell_step{i} = [NaN, NaN];
        end
    end
    
    N = cell_step{1};
    E = cell_step{2};
    S = cell_step{3};
    W = cell_step{4};
    still = cell_step{5};
    
    %filter out moves that will end up at a node that further away from the
    %goal compared to the remaining number of steps in the budget
    %if N_dist > budget - 1
    %    N = [NaN, NaN];
    %end
    %if E_dist > budget - 1
    %    E = [NaN, NaN];
    %end
    %if S_dist > budget - 1
    %    S = [NaN, NaN];
    %end
    %if W_dist > budget - 1
    %    W = [NaN, NaN];
    %end
    %if still_dist > budget - 1
    %    still = [NaN, NaN];
    %end    
    
    %get potential value of information at the node where the moves will end
    %up at
    N_info = findInformation(N(1), N(2), map);
    E_info = findInformation(E(1), E(2), map);
    S_info = findInformation(S(1), S(2), map);
    W_info = findInformation(W(1), W(2), map);
    still_info = findInformation(still(1), still(2), map);
    
    %after filtering, best set of moves w/ associated information quality
    direct_step = [N; E; S; W; still];
    direct_info = [N_info; E_info; S_info; W_info; still_info];

    %direction = [direct_step, direct_info];
    
    %determine the move with the maximum information gain
    [max_info, max_ind] = max(direct_info);
    
    %move that leads to the maximum information gain while going towards
    %the goal
    step = [direct_step(max_ind, 1), direct_step(max_ind, 2)];
    
    %entire path log
    path = [path; step];
    
    %decrease budget by 1 after each move taken
    budget = budget - 1;
end
RunTime = toc;

%plot path
plotPath(path, map, '');
%obtain information quality of path traveled
gathered_info = evaluatePath(path, map);

m1 = sprintf('Run time = %5.4f seconds', RunTime);
disp(m1);
%% Step 1(ii): Implement branch and bound solver
load('newMaps.mat');

map = mapTest2;

budget = 20;

start_node = [1, 1];
goal_node = [map.sideSize, map.sideSize];
z = 0;

path = [start_node];
p_star = [start_node];
z_star = 0;

current_node = [start_node];

tic;
[p_star, z_star] = BNB(current_node, goal_node, budget, path, p_star, z_star, map);
RunTime = toc;

plotPath(p_star, map, '');
gathered_info = evaluatePath(p_star, map);

m1 = sprintf('Run time = %5.4f seconds', RunTime);
disp(m1);