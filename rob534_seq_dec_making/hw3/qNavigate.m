% Created by: Anthony Le
% Last updated: 03-12-2017

% Input (noise): movement noise (chance of not correctly executing intended
% move); choose 0.1 or 0.2
% Input (discount): discount factor = 0.9
% Output (reward): reward received

function reward = qNavigate(noise, discount)

close all;

% load maze from text file
maze = load_maze('maze0.txt');
% determine start state and number of states of maze
[start_state, num_states] = get_start(maze);

% goal_state = 22;

reward = 0;

% current state in maze as the start state 
current = start_state;

% blank 24x4 matrix for Q values
%values = create_blank_maze(6, 4);
Qt = zeros(24, 4);
Q = zeros(24, 4);

% build transition matrix of states, actions, and states'
T = zeros(24, 4, 24);
for s = 1:num_states
    for a = 1:4
        s_prime = move_maze(maze, s, a, 0.0);
        T(s, a, s_prime) =  (1 - noise);
        for a_noisy = 1:4
            s_prime = move_maze(maze, s, a_noisy, noise);
            T(s, a, s_prime) = T(s, a, s_prime) + (noise / 4);
        end
    end
end

% initialize maze w/ all state values = 0, besides the reward states
draw_maze(maze, current);

last_Q = Q;
converged = false;

while ~converged
    Qt = Q;
    % Bellman update/back-up
    for s = 1:1:num_states
        for a = 1:1:4
            %Q(s, a) = reshape(T(s, a, :), 1, 24) * (get_reward(maze, s) + discount * max(Qt, [], 2));
            Q(s, a) = get_reward(maze, s) + discount * (reshape(T(s, a, :), 1, 24) * max(Qt, [], 2));
        end
    end
    
%     current = move_maze(maze, current, next_move, noise); 
    
    % re-draw maze w/ updated state values
    draw_maze(maze, current, max(Q, [], 2));
    
%     reward = reward + get_reward(maze, current);
    Q_diff = sum(sum(abs(last_Q - Q)));
    if Q_diff < 0.00001
        converged = true;
    end
    
    last_Q = Q;
    pause(0.1);    
end

%disp(Q)

for k = 1:1:100
    % choose the action that leads to highest Q value from current state
    [Q_value, next_move] = max(Q(current, :));
    disp([Q_value, next_move])

    % assign new current state based on action taken and noise
    current = move_maze(maze, current, next_move, noise);
    
    % display maze w/ new current state and max Q values of each state
    draw_maze(maze, current, max(Q, [], 2));
    
    % sum of expected rewards over k iterations
    reward = reward + get_reward(maze, current);
    
    % pause b/w iteration
    pause(0.1);
end

end
