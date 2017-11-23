function cost_to_go = get_g_dynamic(map, start, successor)

[x, y] = dynamic_state_from_index(map, start);
[gx, gy] = dynamic_state_from_index(map, successor);

cost_to_go = abs(x - gx) + abs(y - gy); % manhattan distance (actual distance)

end
