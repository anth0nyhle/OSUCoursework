% maze = create_blank_maze(X,Y)
% By Jeremy Kubica, 2003
%
% Generates a blank maze of the given size.  Automatically defaults
% to all walls existing.
% Type 'help maze' for more information
function maze = create_blank_maze(X,Y)

adjacent = zeros(Y*X,4);
maze = struct('adjacent',adjacent,'R',Y,'C',X);