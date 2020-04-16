function cost_to_go = get_g(map, start, successor)

[x, y] = state_from_index(map, start);
[gx, gy] = state_from_index(map, successor);

cost_to_go = abs(x - gx) + abs(y - gy); % manhattan distance (actual distance)

end
