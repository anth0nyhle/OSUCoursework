function man_dist = get_dist(step, goal)

x = step(1);
y = step(2);
gx = goal(1); 
gy = goal(2);

man_dist = abs(gx - x) + abs(gy - y);

end 