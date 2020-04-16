% Created by: Anthony Le
% Last updated: 03-12-2017

function reward = qmdpSearch(noise, discount)

close all;

maze = load_maze('maze1.txt');
[current, num_states] = get_start(maze);

reward = 0;

Qt = zeros(576, 4);
% Q-values matrix is N x N x 4 (24 x 24 x 4)
Q = zeros(576, 4);
% state space is N x N x 1 (24 x 24 x 1)

r = zeros(576, 1);

% build transition matrix of states, actions, and states'
T = zeros(576, 4, 576);
for s = 1:1:576
    for a_robot = 1:1:4
        s_robot = ceil(s / 24);
        s_target = s - (s_robot - 1) * 24;
        if s_robot == s_target
            r(s) = 1;
        end
        sp_robot = move_maze(maze, s_robot, a_robot, 0.0);
        for a_target = 1:1:4
            s_target = s - (s_robot - 1) * 24;
            sp_target = move_maze(maze, s_target, a_target, 0.0);
            sp = (sp_robot - 1) * 24 + sp_target;
            T(s, a_robot, sp) = T(s, a_robot, sp) + (1 - noise) / 4;
        end
        
        for an_robot = 1:1:4
            sp_robot = move_maze(maze, s_robot, an_robot, noise);
            for a_target = 1:1:4
                sp_target = move_maze(maze, s_target, a_target, 0.0);
                sp = (sp_robot - 1) * 24 + sp_target;
                T(s, a_robot, sp) = T(s, a_robot, sp) + (noise / 4) / 4;
            end
        end
    end
end

Tb = zeros(24, 24);
for b = 1:1:num_states
    for a = 1:1:4
        b_prime = move_maze(maze, b, a, 0.0);
        Tb(b, b_prime) = Tb(b, b_prime) + 0.25;
    end
end
        
%draw_maze(maze, current);

last_Q = Q;
converged = false;

while ~converged
    Qt = Q;
    for s = 1:1:576
        for a = 1:1:4
            %Q(s, a) = reshape(T(s, a, :), 1, 24) * (get_reward(maze, s) + discount * max(Qt, [], 2));
            Q(s, a) = r(s) + discount * (reshape(T(s, a, :), 1, 576) * max(Qt, [], 2));
        end
    end
    
    %draw_maze(maze, current, max(Q, [], 2));
    
    Q_diff = sum(sum(abs(last_Q - Q)));
    if Q_diff < 0.00001
        converged = true;
    end
    
    last_Q = Q;
    pause(0.1);
end

b = ones(24, 1);
b(6, 1) = 0;
b = b ./ sum(b); % equal prob of where the target is

for k = 1:1:100
    maze = moveTarget(maze);
    
    % motion update
    b = Tb * b;
    
    QMDP = Q((current - 1) * 24 + 1:current * 24, :)' * b;
    
    [~, next_move] = max(QMDP);
%     [~,b_ind] = max(b);
    % choose the action that leads to highest Q value from current state

    % assign new current state based on action taken and noise
    current = move_maze(maze, current, next_move, noise);
    
    % measurement update
    obs = getObservation(maze, current);
    if obs == 1
        b = zeros(24, 1);
        b(current, 1) = 1;
    else
        b(current, 1) = obs;
        b = b ./ sum(b);
    end
    
    % display maze w/ new current state and max Q values of each state
    draw_maze(maze, current, max(Q, [], 2));
    
    % sum of expected rewards over k iterations
    reward = reward + get_reward(maze, current);
    
%     real_target = find(maze.reward == 1);
%     imagesc(reshape(b,4,6))
%     hold on
%     [r,c] = maze_XY_from_index(maze,current);
%     plot(r,c,'b.','MarkerSize',40)
%     [r,c] = maze_XY_from_index(maze,real_target);
%     plot(r,c,'r.','MarkerSize',30)
%     [r,c] = maze_XY_from_index(maze,b_ind);
%     plot(r,c,'g.','MarkerSize',20)

    % pause b/w iteration
    pause(5);
end

end