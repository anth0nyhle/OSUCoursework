function cost_to_come = get_h_dynamic(map, successor, goal)

[x, y, dx, dy] = dynamic_state_from_index(map, goal);
[hx, hy, dhx, dhy] = dynamic_state_from_index(map, successor);

cost_to_come = (sqrt((x - hx)^2 + (y - hy)^2))/2; %+ (dx - dhx)^2 + (dy - dhy)^2); % euclidean distance

end