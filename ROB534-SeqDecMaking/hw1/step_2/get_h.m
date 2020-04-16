function cost_to_come = get_h(map, successor, goal)

[x, y] = state_from_index(map, goal);
[hx, hy] = state_from_index(map, successor);

cost_to_come = sqrt((x - hx)^2 + (y - hy)^2); % euclidean distance

end