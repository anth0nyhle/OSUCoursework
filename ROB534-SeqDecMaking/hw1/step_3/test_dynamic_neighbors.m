% Function for testing neighbors in 4D dynamics problem
% By Geoff Gordon and Geoff Hollinger, 2007

%displays the possible neighbors of a state given as s = [x y dx dy]
function test_dynamic_neighbors(map,x,y,dx,dy);

stateID = dynamic_index_from_state(map,x,y,dx,dy);
nbrs = get_neighbors_dynamic(map, stateID);

imagesc(map.cells');
for i = 1:size(nbrs,1)
    [nx ny ndx ndy] = dynamic_state_from_index(map,nbrs(i));
    line([x nx], [y ny])
end