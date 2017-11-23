% Anthony Le
% ROB 534: SDM, Winter 2017
% HW #1: Discrete and Sampling-based Planning
% 02-01-2017

% Programming Assignment
% A* and RRT implementations in 4D
% Run each section separately using Ctrl+Enter
%% Step 3(i): A* for maze1 in 4D
% Ctrl+Enter to run this section for Step 3(i): both mazes 
% reads map environment from pgm file
maze1 = read_map_for_dynamics('maze1.pgm');

tic;

% determine start and goal nodes in map
start_node1 = get_start_dynamic(maze1); % index = 1; 
goal_node1 = get_goal_dynamic(maze1); % index = 625; 

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
    successors1 = get_neighbors_dynamic(maze1, current1); % expand all neighboring nodes from current node
    closed_list1 = [closed_list1 current1]; % push explored (current) node into the closed list
    
    if current1 == goal_node1 % if goal node is reached, stop searching
        break
    end
    
    for s1 = 1:size(successors1) % max(s) = 4
        if ismember(successors1(s1), closed_list1) == 1 % avoid reevaluating already expanded node
            continue
        else
            g1 = get_g_dynamic(maze1, start_node1, current1); %+ 1; % + get_g_dynamic(maze1, current1, successors1(s1)); % cost from start node to successor; operating cost function
            h1 = get_h_dynamic(maze1, successors1(s1), goal_node1); % cost from successor to goal node; heuristic function
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
DX1 = [];
DY1 = [];
[x1, y1, dx1, dy1] = dynamic_state_from_index(maze1, path1);
X1 = [X1; x1];
Y1 = [Y1; y1];
DX1 = [DX1; dx1];
DY1 = [DY1; dy1];
optimal_path1 = [X1 Y1 DX1 DY1];

%path_length1 = 

% plots optimal path on map environment
%subplot(1,2,1)
%plot_path(maze1, optimal_path1, 'A* Search for maze1');
%grid on

RunTime1 = toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step2(i): A* for maze2 in 4D
% reads map environment from pgm file
maze2 = read_map_for_dynamics('maze2.pgm');

tic;

% determine start and goal nodes in map
start_node2 = get_start_dynamic(maze2); % index = 1;
goal_node2 = get_goal_dynamic(maze2); % index = 625; 

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
    successors2 = get_neighbors_dynamic(maze2, current2); % expand all neighboring nodes from current node
    closed_list2 = [closed_list2 current2]; % push explored (current) node into the closed list
    
    if current2 == goal_node2 % if goal node is reached, stop searching
        break
    end
    
    for s2 = 1:size(successors2) % max(s) = 4
        if ismember(successors2(s2), closed_list2) == 1 % avoid reevaluating already expanded node
            continue
        else
            g2 = get_g_dynamic(maze2, start_node2, current2); %+ 1; %+ get_g_dynamic(maze2, current2, successors2(s2)); % cost from start node to successor; operating cost function
            h2 = get_h_dynamic(maze2, successors2(s2), goal_node2); % cost from successor to goal node; heuristic function
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
DX2 = [];
DY2 = [];
[x2, y2, dx2, dy2] = dynamic_state_from_index(maze1, path2);
X2 = [X2; x2];
Y2 = [Y2; y2];
DX2 = [DX2; dx2];
DY2 = [DY2; dy2];
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
%% Step 3(ii): Greedy A* w/ deflating epsilon and timer
% change RUNTIME to modify the running time limit of the search
% output includes epsilon, run time, path length, and number of nodes
% expanded

% user-provided epsilon
% starting value of epsilon should be 10
prompt = 'Pick an epsilon for map: ';
epsilon = input(prompt);

RUNTIME = 10; % in seconds

timerID = tic;

while (toc(timerID) < RUNTIME)
    if epsilon < 1.0001
        epsilon = 1;
        break
    end
    % reads map environment from pgm file
    % change map environment
    map = read_map_for_dynamics('maze2.pgm');

    tic;

    % determine start and goal nodes in map
    start_node1 = get_start_dynamic(map); % index = 1; 
    goal_node1 = get_goal_dynamic(map); % index = 625; 

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
        successors1 = get_neighbors_dynamic(map, current1); % expand all neighboring nodes from current node
        closed_list1 = [closed_list1 current1]; % push explored (current) node into the closed list

        if current1 == goal_node1 % if goal node is reached, stop searching
            break
        end

        for s1 = 1:size(successors1) % max(s) = 4
            if ismember(successors1(s1), closed_list1) == 1 % avoid reevaluating already expanded node
                continue
            else
                g1 = get_g_dynamic(map, start_node1, current1); %+ 1; %get_g(maze1, current1, successors1(s1)); % cost from start node to successor; operating cost function
                h1 = get_h_dynamic(map, successors1(s1), goal_node1); % cost from successor to goal node; heuristic function
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
    DX1 = [];
    DY1 = [];
    [x1, y1, dx1, dy1] = dynamic_state_from_index(map, path1);
    X1 = [X1; x1];
    Y1 = [Y1; y1];
    DX1 = [DX1; dx1];
    DY1 = [DY1; dy1];
    optimal_path1 = [X1 Y1];

    toc;
    
    % plots optimal path on map environment
    plot_path(map, optimal_path1, 'A* Search for maze1 in 1 second');
    
    dx = sum(diff(optimal_path1(:,1)));
    dy = sum(diff(optimal_path1(:,2)));

    path_length = sqrt(dx^2 + dy^2);
        
    %path_length = size(optimal_path1, 1) - 1;
    expanded_nodes = size(closed_list1', 1);
    
    m1 = sprintf('Epsilon = %5.4f \n Path length: %2.4f \n Nodes expanded: %5.0f', epsilon, path_length, expanded_nodes);
    disp(m1);
    
    % deflats epsilon; updates epsilson
    epsilon = epsilon - 0.5 * (epsilon - 1);
end