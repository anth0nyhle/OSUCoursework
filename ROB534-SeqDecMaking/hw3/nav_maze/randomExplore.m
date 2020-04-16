%Randomly moves around a maze getting a fixed reward
%Input (noise): movement noise (chance of not correctly executing move)
%Input (discount): discount factor
%Output (reward): reward received by random agent
%Written by Geoff Hollinger, 2015
function reward = randomExplore(noise, discount)
%load maze
m0 = load_maze('maze0.txt');
[cur,nun_nodes] = get_start(m0);

%set initial reward
reward = 0;
%set initial discount
curDiscount = discount;
%display maze
draw_maze(m0,cur);
for i=1:100
    %Move in random direction (replace with your MDP policy)
    dir = floor(rand()*4)+1;
    
    %try to move in the direction
    cur = move_maze(m0,cur,dir,noise);
    %visualize maze
    draw_maze(m0,cur);
    %receive discounted reward
    reward = reward+get_reward(m0,cur)*curDiscount;
    %update discount
    curDiscount = curDiscount*discount;
    pause(0.1);
end