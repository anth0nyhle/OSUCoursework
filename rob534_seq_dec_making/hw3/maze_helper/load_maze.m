% maze = load_maze(filename);
% By Jeremy Kubica, 2003
%
% Reads and returns a maze from a file with the given name.
function maze = load_maze(filename);

f = fopen(filename,'r');

% Read in the number of rows and colums
[A] = fscanf(f,'%i',[2 1]);
R = A(1);
C = A(2);

% Create the matrix
maze = create_blank_maze(C,R);

% Read in the remainder of the matrix (one line at a time)
for i = 1:(R*C)
    [temp] = fscanf(f,'%i',[1 4]);
    maze.adjacent(i,:) = temp;
end

for i = 1:(R*C)
    [temp] = fscanf(f,'%i',[1 1]);
    maze.reward(i,:) = temp;
end