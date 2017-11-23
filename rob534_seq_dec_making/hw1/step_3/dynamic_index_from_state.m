% index = dynamic_index_from_state(map,x,y,dx,dy)
% By Jeremy Kubica, 2003
% Modified by Geoff Hollinger, 2007
%
% Gets a unique index from the state for a maze with 4D dynamics.
% Does NO bounds checking.
function index = dynamic_index_from_state(map,x,y,dx,dy)

%include zero in velocities
vels = map.maxV + 1;

index = dy*(map.R*map.C*vels) + dx*(map.R*map.C)+... 
    ((x-1) * map.R) + (y-1);
index = index + 1;