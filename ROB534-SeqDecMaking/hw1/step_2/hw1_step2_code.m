% Anthony Le
% ROB 534: SDM, Winter 2017
% HW #1: Discrete and Sampling-based Planning
% 02-01-2017

% Programming Assignment
% A* and RRT implementations in 2D
% Run each section separately using Ctrl+Enter
%% Step 2(i): A* for maze1 in 2D
% Ctrl+Enter to run this section for Step 2(i): both mazes 
% reads map environment from pgm file
maze1 = read_map('maze1.pgm');

tic;

% determine start and goal nodes in map
start_node1 = get_start(maze1); % index = 1; state = [1, 1]
goal_node1 = get_goal(maze1); % index = 625; state = [25, 25]

% initialize a prior queue as open_list
% initialize a closed list for explored nodes
open_list1 = pq_init(10000); % frontier nodes
closed_list1 = []; % explored nodes

%total_search = [];
path1 = {}; % where nodes along optimal path will be stored
path1{1} = start_node1; % initialize cell array

% add start node to open list
open_list1 = pq_insert(open_list1, start_node1, 0);

while true
    [open_list1, current1] = pq_pop(open_list1); % pop current node from pq; highest priority
    successors1 = get_neighbors(maze1, current1); % expand all neighboring nodes from current node
    closed_list1 = [closed_list1 current1]; % push explored (current) node into the closed list
    
    if current1 == goal_node1 % if goal node is reached, stop searching
        break
    end
    
    for s1 = 1:size(successors1) % max(s) = 4
        if ismember(successors1(s1), closed_list1) == 1 % avoid reevaluating already expanded node
            continue
        else
            g1 = get_g(maze1, start_node1, current1) + get_g(maze1, current1, successors1(s1)); % cost from start node to successor; operating cost function
            h1 = get_h(maze1, successors1(s1), goal_node1); % cost from successor to goal node; heuristic function
            priority1 = g1 + h1; % f cost evaluation function of successors
            
            test1 = pq_test(open_list1, successors1(s1)); % test if successor is in the open list
            if test1 == 1 % already in the open list
                if priority1 < pq_priority(open_list1, successors1(s1))
                    open_list1 = pq_set(open_list1, successors1(s1), priority1); % reset a successor's priority to the higher one (lower number)
                    path1{successors1(s1)} = [path1{current1}; successors1(s1)]; % record nodes of optimal path by storing where you came from
                    %total_search(end+1,:) = [successors(s), current];
                end
                
            else test1 = 0; % not in the open list
                open_list1 = pq_insert(open_list1, successors1(s1), priority1); % insert newly discovered node in open list
                path1{successors1(s1)} = [path1{current1}; successors1(s1)]; % record nodes of optimal path by storing where you came from
                %total_search(end+1,:) = [successors(s), current];
            end
        end
    end
end

% extract state from indices of nodes along optimal path
path1 = path1{625};
X1 = [];
Y1 = [];
[x1, y1] = state_from_index(maze1, path1);
X1 = [X1; x1];
Y1 = [Y1; y1];
optimal_path1 = [X1 Y1];

% plots optimal path on map environment
%subplot(1,2,1)
%plot_path(maze1, optimal_path1, 'A* Search for maze1');
%grid on

RunTime1 = toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step2(i): A* for maze2 in 2D
% reads map environment from pgm file
maze2 = read_map('maze2.pgm');

tic;

% determine start and goal nodes in map
start_node2 = get_start(maze2); % index = 1; state = [1, 1]
goal_node2 = get_goal(maze2); % index = 625; state = [25, 25]

% initialize a prior queue as open_list
% initialize a closed list for explored nodes
open_list2 = pq_init(10000); % frontier nodes
closed_list2 = []; % explored nodes

%total_search = [];
path2 = {}; % where nodes along optimal path will be stored
path2{1} = start_node2; % initialize cell array

% add start node to open list
open_list2 = pq_insert(open_list2, start_node2, 0);

while true
    [open_list2, current2] = pq_pop(open_list2); % pop current node from pq; highest priority
    successors2 = get_neighbors(maze2, current2); % expand all neighboring nodes from current node
    closed_list2 = [closed_list2 current2]; % push explored (current) node into the closed list
    
    if current2 == goal_node2 % if goal node is reached, stop searching
        break
    end
    
    for s2 = 1:size(successors2) % max(s) = 4
        if ismember(successors2(s2), closed_list2) == 1 % avoid reevaluating already expanded node
            continue
        else
            g2 = get_g(maze2, start_node2, current2) + get_g(maze2, current2, successors2(s2)); % cost from start node to successor; operating cost function
            h2 = get_h(maze2, successors2(s2), goal_node2); % cost from successor to goal node; heuristic function
            priority2 = g2 + h2; % f cost evaluation function of successors
            
            test2 = pq_test(open_list2, successors2(s2)); % test if successor is in the open list
            if test2 == 1 % already in the open list
                if priority2 < pq_priority(open_list2, successors2(s2))
                    open_list2 = pq_set(open_list2, successors2(s2), priority2); % reset a successor's priority to the higher one (lower number)
                    path2{successors2(s2)} = [path2{current2}; successors2(s2)]; % record nodes of optimal path by storing where you came from
                    %total_search(end+1,:) = [successors(s), current];
                end
                
            else test2 = 0; % not in the open list
                open_list2 = pq_insert(open_list2, successors2(s2), priority2); % insert newly discovered node in open list
                path2{successors2(s2)} = [path2{current2}; successors2(s2)]; % record nodes of optimal path by storing where you came from
                %total_search(end+1,:) = [successors(s), current];
            end
        end
    end
end

% extract state from indices of nodes along optimal path
path2 = path2{625};
X2 = [];
Y2 = [];
[x2, y2] = state_from_index(maze2, path2);
X2 = [X2; x2];
Y2 = [Y2; y2];
optimal_path2 = [X2 Y2];

% plots optimal path on map environment
%subplot(1,2,2)
%plot_path(maze2, optimal_path2, 'A* Search for maze2');
%grid off

RunTime2 = toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step2(ii): A* path plots
% plots optimal path on map environment
figure(1);
subplot(1,2,1);
plot_path(maze1, optimal_path1, 'A* Search for maze1');
hold on;
subplot(1,2,2);
plot_path(maze2, optimal_path2, 'A* Search for maze2');


% displays the run time for A* search in each maze
m1 = sprintf('Run time for maze1: %5.4f seconds', RunTime1);
disp(m1)
m2 = sprintf('Run time for maze2: %5.4f seconds', RunTime2);
disp(m2)
%% Step2(ii): greedy A* for maze1 w/ deflating epsilon
% user-provided epsilon
prompt1 = 'Pick an epsilon for maze1: ';
epsilon1 = input(prompt1);

while epsilon1 > 0.999
    if epsilon1 < 1.0001
        epsilon1 = 1;
        break
    end
    % reads map environment from pgm file
    maze1 = read_map('maze1.pgm');

    tic;
    
    % determine start and goal nodes in map
    start_node1 = get_start(maze1); % index = 1; state = [1, 1]
    goal_node1 = get_goal(maze1); % index = 625; state = [25, 25]

    % initialize a prior queue as open_list
    % initialize a closed list for explored nodes
    open_list1 = pq_init(10000); % frontier nodes
    closed_list1 = []; % explored nodes

    %total_search = [];
    path1 = {}; % where nodes along optimal path will be stored
    path1{1} = start_node1; % initialize cell array

    % add start node to open list
    open_list1 = pq_insert(open_list1, start_node1, 0);


    while true
        [open_list1, current1] = pq_pop(open_list1); % pop current node from pq; highest priority
        successors1 = get_neighbors(maze1, current1); % expand all neighboring nodes from current node
        closed_list1 = [closed_list1 current1]; % push explored (current) node into the closed list

        if current1 == goal_node1 % if goal node is reached, stop searching
            break
        end

        for s1 = 1:size(successors1) % max(s) = 4
            if ismember(successors1(s1), closed_list1) == 1 % avoid reevaluating already expanded node
                continue
            else
                g1 = get_g(maze1, start_node1, current1) + get_g(maze1, current1, successors1(s1)); % cost from start node to successor; operating cost function
                h1 = get_h(maze1, successors1(s1), goal_node1); % cost from successor to goal node; heuristic function
                priority1 = g1 + (h1 * epsilon1); % f cost evaluation function of successors

                test1 = pq_test(open_list1, successors1(s1)); % test if successor is in the open list
                if test1 == 1 % already in the open list
                    if priority1 < pq_priority(open_list1, successors1(s1))
                        open_list1 = pq_set(open_list1, successors1(s1), priority1); % reset a successor's priority to the higher one (lower number)
                        path1{successors1(s1)} = [path1{current1}; successors1(s1)]; % record nodes of optimal path by storing where you came from
                        %total_search(end+1,:) = [successors(s), current];
                    end

                else test1 = 0; % not in the open list
                    open_list1 = pq_insert(open_list1, successors1(s1), priority1); % insert newly discovered node in open list
                    path1{successors1(s1)} = [path1{current1}; successors1(s1)]; % record nodes of optimal path by storing where you came from
                    %total_search(end+1,:) = [successors(s), current];
                end
            end
        end
    end
    
    % extract state from indices of nodes along optimal path
    path1 = path1{625};
    X1 = [];
    Y1 = [];
    [x1, y1] = state_from_index(maze1, path1);
    X1 = [X1; x1];
    Y1 = [Y1; y1];
    optimal_path1 = [X1 Y1];
    
    RunTime1 = toc;

    % plots optimal path on map environment
    plot_path(maze1, optimal_path1, 'A* Search for maze1');
    
    path_length1 = size(optimal_path1, 1);
    expanded_nodes1 = size(closed_list1', 1);
            
    m1 = sprintf('Run time for epsilon = %5.4f: %5.4f seconds \n Path length: %2.0f \n Nodes expanded: %5.0f', epsilon1, RunTime1, path_length1, expanded_nodes1);
    disp(m1);
    
    % deflats epsilon; updates epsilson
    epsilon1 = epsilon1 - 0.5 * (epsilon1 - 1);
end
%% Step2(ii): greedy A* for maze2 w/ deflating epsilon
% user-provided epsilon
prompt2 = 'Pick an epsilon for maze2: ';
epsilon2 = input(prompt2);

while epsilon2 > 0.999
    if epsilon2 < 1.0001
        epsilon2 = 1;
        break
    end
    
    % reads map environment from pgm file
    maze2 = read_map('maze2.pgm');

    tic;
    
    % determine start and goal nodes in map
    start_node2 = get_start(maze2); % index = 1; state = [1, 1]
    goal_node2 = get_goal(maze2); % index = 625; state = [25, 25]

    % initialize a prior queue as open_list
    % initialize a closed list for explored nodes
    open_list2 = pq_init(10000); % frontier nodes
    closed_list2 = []; % explored nodes

    %total_search = [];
    path2 = {}; % where nodes along optimal path will be stored
    path2{1} = start_node2; % initialize cell array

    % add start node to open list
    open_list2 = pq_insert(open_list2, start_node2, 0);

    while true
        [open_list2, current2] = pq_pop(open_list2); % pop current node from pq; highest priority
        successors2 = get_neighbors(maze2, current2); % expand all neighboring nodes from current node
        closed_list2 = [closed_list2 current2]; % push explored (current) node into the closed list

        if current2 == goal_node2 % if goal node is reached, stop searching
            break
        end

        for s2 = 1:size(successors2) % max(s) = 4
            if ismember(successors2(s2), closed_list2) == 1 % avoid reevaluating already expanded node
                continue
            else
                g2 = get_g(maze2, start_node2, current2) + get_g(maze2, current2, successors2(s2)); % cost from start node to successor; operating cost function
                h2 = get_h(maze2, successors2(s2), goal_node2); % cost from successor to goal node; heuristic function
                priority2 = g2 + (h2 * epsilon2); % f cost evaluation function of successors

                test2 = pq_test(open_list2, successors2(s2)); % test if successor is in the open list
                if test2 == 1 % already in the open list
                    if priority2 < pq_priority(open_list2, successors2(s2))
                        open_list2 = pq_set(open_list2, successors2(s2), priority2); % reset a successor's priority to the higher one (lower number)
                        path2{successors2(s2)} = [path2{current2}; successors2(s2)]; % record nodes of optimal path by storing where you came from
                        %total_search(end+1,:) = [successors(s), current];
                    end

                else test2 = 0; % not in the open list
                    open_list2 = pq_insert(open_list2, successors2(s2), priority2); % insert newly discovered node in open list
                    path2{successors2(s2)} = [path2{current2}; successors2(s2)]; % record nodes of optimal path by storing where you came from
                    %total_search(end+1,:) = [successors(s), current];
                end
            end
        end
    end
    
    % extract state from indices of nodes along optimal path
    path2 = path2{625};
    X2 = [];
    Y2 = [];
    [x2, y2] = state_from_index(maze2, path2);
    X2 = [X2; x2];
    Y2 = [Y2; y2];
    optimal_path2 = [X2 Y2];

    RunTime2 = toc;
    
    % plots optimal path on map environment
    plot_path(maze2, optimal_path2, 'A* Search for maze2');
    
    path_length2 = size(optimal_path2, 1);
    expanded_nodes2 = size(closed_list2', 1);
    
    m2 = sprintf('Run time for epsilon = %5.4f: %5.4f seconds \n Path length: %2.0f \n Nodes expanded: %5.0f', epsilon2, RunTime2, path_length2, expanded_nodes2);
    disp(m2);
    
    % deflats epsilon; updates epsilson
    epsilon2 = epsilon2 - 0.5 * (epsilon2 - 1);
end


%% Step(ii): greedy A* w/ deflating epsilon and timer
% change RUNTIME to modify the running time limit of the search
% output includes epsilon, run time, path length, and number of nodes
% expanded

% user-provided epsilon
% starting value of epsilon should be 10
prompt = 'Pick an epsilon for map: ';
epsilon = input(prompt);

RUNTIME = 0.05; % in seconds

timerID = tic;

while (toc(timerID) < RUNTIME)
    if epsilon < 1.0001
        epsilon = 1;
        break
    end
    % reads map environment from pgm file
    % change map environment
    map = read_map('maze2.pgm');

    tic;
    
    % determine start and goal nodes in map
    start_node1 = get_start(map); % index = 1; state = [1, 1]
    goal_node1 = get_goal(map); % index = 625; state = [25, 25]

    % initialize a prior queue as open_list
    % initialize a closed list for explored nodes
    open_list1 = pq_init(10000); % frontier nodes
    closed_list1 = []; % explored nodes

    %total_search = [];
    path1 = {}; % where nodes along optimal path will be stored
    path1{1} = start_node1; % initialize cell array

    % add start node to open list
    open_list1 = pq_insert(open_list1, start_node1, 0);


    while true
        [open_list1, current1] = pq_pop(open_list1); % pop current node from pq; highest priority
        successors1 = get_neighbors(map, current1); % expand all neighboring nodes from current node
        closed_list1 = [closed_list1 current1]; % push explored (current) node into the closed list

        if current1 == goal_node1 % if goal node is reached, stop searching
            break
        end

        for s1 = 1:size(successors1) % max(s) = 4
            if ismember(successors1(s1), closed_list1) == 1 % avoid reevaluating already expanded node
                continue
            else
                g1 = get_g(map, start_node1, current1) + get_g(map, current1, successors1(s1)); % cost from start node to successor; operating cost function
                h1 = get_h(map, successors1(s1), goal_node1); % cost from successor to goal node; heuristic function
                priority1 = g1 + (h1 * epsilon); % f cost evaluation function of successors

                test1 = pq_test(open_list1, successors1(s1)); % test if successor is in the open list
                if test1 == 1 % already in the open list
                    if priority1 < pq_priority(open_list1, successors1(s1))
                        open_list1 = pq_set(open_list1, successors1(s1), priority1); % reset a successor's priority to the higher one (lower number)
                        path1{successors1(s1)} = [path1{current1}; successors1(s1)]; % record nodes of optimal path by storing where you came from
                        %total_search(end+1,:) = [successors(s), current];
                    end

                else test1 = 0; % not in the open list
                    open_list1 = pq_insert(open_list1, successors1(s1), priority1); % insert newly discovered node in open list
                    path1{successors1(s1)} = [path1{current1}; successors1(s1)]; % record nodes of optimal path by storing where you came from
                    %total_search(end+1,:) = [successors(s), current];
                end
            end
        end
    end
    
    % extract state from indices of nodes along optimal path
    path1 = path1{625};
    X1 = [];
    Y1 = [];
    [x1, y1] = state_from_index(map, path1);
    X1 = [X1; x1];
    Y1 = [Y1; y1];
    optimal_path1 = [X1 Y1];

    toc;
    
    % plots optimal path on map environment
    plot_path(map, optimal_path1, 'A* Search for maze1 in 1 second');
    
    path_length = size(optimal_path1, 1) - 1;
    expanded_nodes = size(closed_list1', 1);
            
    
    m1 = sprintf('Epsilon = %5.4f \n Path length: %2.0f \n Nodes expanded: %5.0f', epsilon, path_length, expanded_nodes);
    disp(m1);
    
    % deflats epsilon; updates epsilson
    epsilon = epsilon - 0.5 * (epsilon - 1);
end
%% Step2(iii): RRT for maze1
maze1 = read_map('maze1.pgm');

tic;
start_node = get_start(maze1);
goal_node = get_goal(maze1);

[start_x, start_y] = state_from_index(maze1, start_node);
[goal_x, goal_y] = state_from_index(maze1, goal_node);

Tree = [];

edges = [];
nodes = [[start_x, start_y]];
nearest_nodes = [];
new_nodes = [];

nearest_nodes_idx = [];
new_nodes = [];
edges_idx = [];

step = 1;

new_node = start_node;

while true
    if rand > 0.95
        rand_x = goal_x;
        rand_y = goal_y;
    else
        rand_x = rand * 25;
        rand_y = rand * 25;
    end
    
    nearest_index = knnsearch(nodes, [rand_x, rand_y]);
    nearest_x = nodes(nearest_index, 1);
    nearest_y = nodes(nearest_index, 2);
    
    dist = sqrt((rand_x - nearest_x)^2 + (rand_y - nearest_y)^2);
    
    new_x = (step/dist)*(rand_x - nearest_x) + nearest_x;
    new_y = (step/dist)*(rand_y - nearest_y) + nearest_y;
    
    n_dx = new_x - nearest_x;
    n_dy = new_y - nearest_y;
    
    r_dx = rand_x - nearest_x;
    r_dy = rand_y - nearest_y;
    
    hit1 = check_hit(maze1, nearest_x, nearest_y, n_dx, n_dy);
    hit2 = check_hit(maze1, nearest_x, nearest_y, r_dx, r_dy);
    if hit1 == 1 || hit2 == 1 || new_x < 1 || new_y < 1 || new_x > maze1.C || new_y > maze1.R
        continue
    else
        nearest_nodes = [nearest_nodes; [nearest_x, nearest_y]];
        new_nodes = [new_nodes; [new_x, new_y]];
        nodes = [nodes; [new_x, new_y]];
        edges = [edges; [nearest_x, nearest_y, new_x, new_y]];
        
        new_nodes_idx = index_from_state(maze1, new_nodes(:, 1), new_nodes(:,2));
        nearest_nodes_idx = index_from_state(maze1, nearest_nodes(:, 1), nearest_nodes(:, 2));
        nodes_idx = index_from_state(maze1, nodes(:, 1), nodes(:, 2));
        
    end
    
    if new_nodes(end, 1) > 24 && new_nodes(end, 1) < 25 && new_nodes(end, 2) > 24 && new_nodes(end, 2) < 25 
        goal_x = new_nodes(end, 1);
        goal_y = new_nodes(end, 2);
        break
    end
    
    %plot_path(maze1, nodes, 'RRT');
end


path = [[goal_x, goal_y]];
i = 1;
not_at_start = 1;
px = goal_x;
py = goal_y;

while not_at_start
    p_row = find(ismember(new_nodes, [px, py], 'rows'));
    
    px = edges(p_row(1), 1);
    py = edges(p_row(1), 2);
    
    path = [path; px, py];
    
    i = i + 1;
    not_at_start = ~(px <= 1 && py <= 1);
end
RunTime = toc;

dx = sum(diff(path(:,1)));
dy = sum(diff(path(:,2)));

path_length = sqrt(dx^2 + dy^2);

expanded_nodes = size(nodes, 1);

edges_idx = [edges_idx; [nearest_nodes_idx, new_nodes_idx]];

plot_path(maze1, path, 'RRT for maze1');

m1 = sprintf('Run time: %5.4f \n Path length: %2.4f \n Nodes expanded: %5.0f', RunTime, path_length, expanded_nodes);
disp(m1);

%for i = 1:1:length(edges(:,1)) plot(edges(i,[1,3]), edges(i,[2,4]), '-'); hold on; end;
%% Step2(iii): RRT for maze2
maze2 = read_map('maze2.pgm');

tic;
start_node = get_start(maze2);
goal_node = get_goal(maze2);

[start_x, start_y] = state_from_index(maze2, start_node);
[goal_x, goal_y] = state_from_index(maze2, goal_node);

Tree = [];

edges = [];
nodes = [[start_x, start_y]];
nearest_nodes = [];
new_nodes = [];

nearest_nodes_idx = [];
new_nodes = [];
edges_idx = [];

step = 1;

new_node = start_node;

while true
    if rand > 0.95
        rand_x = goal_x;
        rand_y = goal_y;
    else
        rand_x = rand * 25;
        rand_y = rand * 25;
    end
    
    nearest_index = knnsearch(nodes, [rand_x, rand_y]);
    nearest_x = nodes(nearest_index, 1);
    nearest_y = nodes(nearest_index, 2);
    
    dist = sqrt((rand_x - nearest_x)^2 + (rand_y - nearest_y)^2);
    
    new_x = (step/dist)*(rand_x - nearest_x) + nearest_x;
    new_y = (step/dist)*(rand_y - nearest_y) + nearest_y;
    
    n_dx = new_x - nearest_x;
    n_dy = new_y - nearest_y;
    
    r_dx = rand_x - nearest_x;
    r_dy = rand_y - nearest_y;
    
    hit1 = check_hit(maze2, nearest_x, nearest_y, n_dx, n_dy);
    hit2 = check_hit(maze2, nearest_x, nearest_y, r_dx, r_dy);
    if hit1 == 1 || hit2 == 1 || new_x < 1 || new_y < 1 || new_x > maze2.C || new_y > maze2.R
        continue
    else
        nearest_nodes = [nearest_nodes; [nearest_x, nearest_y]];
        new_nodes = [new_nodes; [new_x, new_y]];
        nodes = [nodes; [new_x, new_y]];
        edges = [edges; [nearest_x, nearest_y, new_x, new_y]];
        
        new_nodes_idx = index_from_state(maze2, new_nodes(:, 1), new_nodes(:,2));
        nearest_nodes_idx = index_from_state(maze2, nearest_nodes(:, 1), nearest_nodes(:, 2));
        nodes_idx = index_from_state(maze2, nodes(:, 1), nodes(:, 2));
        
    end
    
    if new_nodes(end, 1) > 24 && new_nodes(end, 1) < 25 && new_nodes(end, 2) > 24 && new_nodes(end, 2) < 25 
        goal_x = new_nodes(end, 1);
        goal_y = new_nodes(end, 2);
        break
    end
    
    %plot_path(maze1, nodes, 'RRT');
end


path = [[goal_x, goal_y]];
i = 1;
not_at_start = 1;
px = goal_x;
py = goal_y;

while not_at_start
    p_row = find(ismember(new_nodes, [px, py], 'rows'));
    
    px = edges(p_row(1), 1);
    py = edges(p_row(1), 2);
    
    path = [path; px, py];
    
    i = i + 1;
    not_at_start = ~(px <= 1 && py <= 1);
end
RunTime = toc;

dx = sum(diff(path(:,1)));
dy = sum(diff(path(:,2)));

path_length = sqrt(dx^2 + dy^2);
expanded_nodes = size(nodes, 1);

edges_idx = [edges_idx; [nearest_nodes_idx, new_nodes_idx]];

plot_path(maze2, path, 'RRT for maze2');

m2 = sprintf('Run time: %5.4f \n Path length: %2.0f \n Nodes expanded: %5.0f', RunTime, path_length, expanded_nodes);
disp(m2);

%for i = 1:1:length(edges(:,1)) plot(edges(i,[1,3]), edges(i,[2,4]), '-'); hold on; end;