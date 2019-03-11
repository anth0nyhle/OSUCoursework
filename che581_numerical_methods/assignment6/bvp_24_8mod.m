% bvp.m  - A file to compute the solution to a second-order boundary value
% problem.
% this code assumes that the bvp takes the form
%
%               D * d^2c/dx^2 - alpha * c = 0
%
% this kind of problem occurs in all kinds of science and engineering
% applications.  examples include contiminant transport in soils,
% atmosphere-soil gas transport, chromatography, etc.  often both
% a "convection" term would also be included in the
% transport equation, depending upon the application.  for now, we will
% examine only diffusion and reaction with Dirichlet (specified 
% concentration) boundary conditions.
%
% the discretization of this problem is simple.  starting with the
% governing equation, substitute the centered-difference algebraic 
% approximation of the second-order derivative.
%
%      D (c(i-1)- 2 c(i) + c(i+1))/(deltx^2) - alpha * c(i)  = 0 
%
% (where here D is the diffusion coefficient, c is the concentration,
% alpha is the reaction rate coefficient, and deltx is the grid spacing). 
%
% Putting this in linear form (i.e., combining terms) gives
%
%         -c(i-1) + (2+alpha*deltx^2/D)* c(i) - c(i+1) = 0
%
% this represents our "recurrence relation" for constructing the matrix
% of equations that represents the algebraic decompostion of the original 
% differential equation.
%
% for the recurrence relation, we multiplied through by -1; the reason for this is that we would
% like the center term to be positive (so it will be positive when we finish
% inverting the matrix).  
%
% the first and last rows of the matrix are a little different...  For the 
% first row we get
%
%        -c(1) + (2+alpha*deltx^2/D)* c(2) - c(3) = 0
%
% however, because c(1) is known (it is the left-hand-side boundary
% condition), then we need to put it on the right-hand side of the equation
%
%           (2+alpha*deltx^2/D)* c(2) - c(3) = c(1)
%
% similarly, for the last row:
%
%         -c(n-2) + (2+alpha*deltx^2/D) * c(n-1)  = c(n)
%
% now, with this information in hand, we can see that our linear system
% looks like:
%
%            M . x  =   b
%
% where M is a tri-diagonal matrix (n-2 by n-2), x is the vector of n-2
% unknowns, and b is the vector of sources (the right-hand side).
%
% except for the first and last rows of this matrix, every row looks
% like
%
% .... 0    0     -1     (2+alpha*deltx^2/D)      -1      0     0 ....
%
% and, the vector of the right hand side looks like  
%
%              b=[c(1)  0   0   ... 0   0    c(n)]'
%
% one last thing... about notation.  we have np segments, with n = np+1
% nodes.  but, we only need to compute the values for the *interior* nodes;
% we already know the values on the boundaries.  so, here is how we will
% number the nodes.  for 5 partitions (6 nodes total) the numbering will be
%
%   |-----|-----|-----|-----|-----|-----|
%   1     2     3     4     5     6     7
%         1     2   ....         nm        <--- Position in array stored in MATLAB
%
% where nm is the dimension of the matrix.  For a 7 node problem, the
% arrays would look like
%
%
%   |f1     g1      0       0       0||x1|        |b1|
%   |e2     f2      g2      0       0||x2|        |b2|
%   |0      e3      f3      g3      0||x3|   =    |b3|
%   |0      0       e4      f4     g4||x4|        |b4|
%   |0      0       0       e5     f5||x5|        |b5|
%
%
% so, let's make the matrix.  here goes...
%
%
clc;
clf;
f_x = 25; % deg C/m^2, heat source
L = 10; % domain length in meters
T0 = 40; % deg C, the left-hand side boundary condition
Tn = 200; % deg C, the right-hand side boundary condition
np = 5  % number of partitions
n = np + 1 % number of nodes
nm = n - 2 % number of *internal* nodes
dx = L / np % size of partitions, in m
dx2 = dx * dx; % square the size once so you don't have to do it again!
M = zeros(nm, nm); % initialize the array
b = zeros(nm, 1); % initialize the b column vector; remember, this vector is an nm x 1 array in MATLAB
%
M(1, 1) = dx; % the first row is special
M(1, 2) = -1; % the first row is special
%
M(nm, nm-1) = -1; % so is the last row
M(nm, nm) = dx; % so is the last row
%
b(1) = f_x * dx2 + T0; % first value in the b vector
b(nm) = f_x * dx2 + Tn; % last value in the b vector; the rest are zeros
b(2:nm-1) = f_x * dx2;
%
% now make a nice loop to fill in the rest...
for k=2:1:nm-1 % loop over the rows of the array (nm x nm)
    M(k, k-1) = -1; % set the subdiagonal value
    M(k, k) = dx; % set the diagonal value 
    M(k, k+1) = -1; % set the subdiagonal value
end
disp(M)
disp(b)
%
c = M \ b % solve the system of equations using MATLAB's built-in solver
% NOTE: The backslash notation is a *second* way of inverting M (instead of
% inv(M))!
% 
% Now, make a new array that also includes the boundary concentrations for
% plotting purposes.
% I will do this by making a new, bigger array, and puttin the two
% BCs in the first and last position.  Then I will fill in the rest of the array
% with the solution values.
%
c2 = zeros(n, 1); % initialize the vector
c2(1) = T0; % set the left boundary value
c2(n) = Tn; % set the right boundary value
for k = 2:1:n-1 % loop over the rest of the values in the vector
    c2(k) = c(k-1); % fill the vector with the correct value from c
end
%
%display(c2)
xx = linspace(0, L, n); % make n evenly-spaced node location values between 0 and L
plot(xx, c2)
%
% we wasted lots of space by filling in the array with a bunch of zeros.
% plus we relied on MATLAB's built in array inverting capabilities, which
% is totally wussy.  Later, we will use our own routine to do the inversion!
%
