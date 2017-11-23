%Randomly moves around a maze getting reward from locating a moving target
%Input (noise): movement noise (chance of not correctly executing move)
%Input (discount): discount factor
%Output (reward): reward received by random agent
%Written by Geoff Hollinger, 2015
function reward = randomTargetSearch(noise, discount)

%load maze
m1 = load_maze('maze1.txt');
[cur,num_nodes] = get_start(m1);

%set initial reward
reward = 0;
%set initial discount
curDiscount = discount;
%display maze
draw_maze(m1,cur);
for i=1:100
    %pick random direction (replace this with your QMDP and most likely
    %planners)
    dir = floor(rand()*4)+1;
    %get an observation (use this to update your belief of where the target is)
    obs = getObservation(m1,cur);
    
    %attempt to move in random direction
    cur = move_maze(m1,cur,dir,noise);
    %display maze
    draw_maze(m1,cur);
    %receive discounted reward if found target
    reward = reward+get_reward(m1,cur)*curDiscount;
    %update discount
    curDiscount = curDiscount*discount;
    pause(0.1);
    %target moves
    m1 = moveTarget(m1);
end