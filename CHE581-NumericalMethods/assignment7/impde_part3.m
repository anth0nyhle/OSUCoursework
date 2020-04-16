% impde.m  - A file to compute the implicit solution to a second-order initial boundary value
% problem. this code assumes that the problem takes the form
%
%              dc/dt = D * d^2c/dx^2 -k*c
%              dc/dx (x=0) = 0       (boundary condition 1)
%              dc/dx (x=L) = 0       (boundary condition 2)
%              c(x,t=0) = f(x)       (initial condition)
%
% assume that we are going to discretize this problem in space and in time.  For
% reference, assume a spatial grid of the form
%
%
%        x=0                                 x=L
%         (-----------------------------------)
%
%   |-----|-----|-----|-----|-----|-----|-----|-----|
%   (0)   1     2     3     4     5     6     7    (8)
%          
%
% here, we have allowed for the possibility that two "fictitious" nodes might
% be needed to accommodate two derivative boundary conditions.
%
% the discretization of this problem is simple.  starting with the
% governing equation, substitute (1) a central difference for the time derivative, and 
% (2) a crank-nicholson centered-difference approximation for the space derivative.  this gives 
% approximation:
%
%      [c(i,j+1)-c(i,j)]/dt  = 
%      D*1/2*([c(i+1,j)-2*c(i,j)+c(i-1,j)]/(dx)^2  +  [c(i+1,j+1)-2*c(i,j+1)+c(i-1,j+1)]/(dx)^2)
%      -k*1/2*[c(i,j)+c(i,j+1)]    
%
% (where here D is the diffusion coefficient, c is the concentration,
% dx is the grid spacing, dt is the time step size, and k is the reaction rate coeff). 
%
% Putting this in linear form (i.e., combining terms) gives an *implicit* 
% scheme
%
% ==========================================================================================
% ==========================================================================================
%      -r*c(i-1,j+1)+(2+2*r+kdt)*c(i,j+1)-r*c(i+1,j+1) = 
%        r*c(i-1,j)+(2-2*r-kdt)*c(i,j)+r*c(i+1,j)
% ==========================================================================================
% ==========================================================================================
% 
% where r = D*dt/(dx^2)
% kdt = k*dt
%
% this represents our "recurrence relation" for constructing the matrix
% of equations that represents the algebraic decompostion of the original 
% differential equation.
%
% it should be apparent to you by now that this recurrence relationship
% defines a linear system of equations.  for this particular case, the
% system takes the form
%
%          M . c(j+1) = b(j)
%
% where c(j+1) is a *vector* of new concentration values (one for each 
% node where the concentration is unknown), and c(j) is the vector of the 
% current nodal values of concentration.  M is the matrix of coefficients
% that evolves the system of equations in time. b(j) is the vector of
% constants (boundary conditions+previous time step values) that appear in the
% equation set.
%
%
% the first and last rows of the matrix, M, are a little different from the remaining rows.  
% The form of the first and last row depend on the type of boundary conditions 
% imposed.  For now, let's assume that two *derivative* (neuman) conditions are
% imposed, and that they are time-independent (in other words, they are the same
% value imposed at time steps "j" and "j+1").  
% suppose the two derivative boundary conditions are given by
% dc/dx = s1 (left) and dc/dx = s2 (right).  the centered difference
% representation of these two derivatives at nodes 1 and 7 would be
%
% (1)  [c(2,j)-c(0,j)]/(2*dx) = sl
% (2)  [c(8,j)-c(6,j)]/(2*dx) = sr
% (3)  [c(2,j+1)-c(0,j+1)]/(2*dx) = sl
% (4)  [c(8,j+1)-c(6,j+1)]/(2*dx) = sr
%
% Assuming that sl=sr=0,then we can rearrange to solve for the values at the "fictitious" nodes
%
% (5)  c(0,j)= c(2,j)           (7)  c(8,j)= c(6,j)
% (6)  c(0,j+1)= c(2,j+1)       (8)  c(8,j+1)= c(6,j+1)
%
% now, for the **first row** the recurrence relationship gives
%
%      -r*c(0,j+1)+(2+2*r+kdt)*c(1,j+1)-r*c(2,j+1) = 
%        r*c(0,j)+(2-2*r-kdt)*c(1,j)+r*c(2,j)
%
% elimiating c(0,j+1) and c(0,j) using equations (5) and (6) above gives
%
%      (2+2*r+kdt)*c(1,j+1)-2*r*c(2,j+1) = 
%                      (2-2*r-kdt)*c(1,j)+2*r*c(2,j)
%
% similarly, for the **last row**, we will get
%
%      -2*r*c(6,j+1)+(2+2*r+kdt)*c(7,j+1) = 
%                       2*r*c(6,j)+(2-2*r-kdt)*c(7,j)
%
% the result is a system of equations that has the matrix form
%
%  |2+2*r+kdt     -2*r          0          0          0          0          0    ||c(1,j+1)|        |            (2-2*r-kdt)*c(1,j) + 2*r*c(2,j)|   
%  |   -r       2+2*r+kdt      -r          0          0          0          0    ||c(2,j+1)|        | r*c(1,j) + (2-2*r-kdt)*c(2,j) + r*c(3,j)  |    
%  |    0          -r       2+2*r+kdt     -r          0          0          0    ||c(3,j+1)|        | r*c(2,j) + (2-2*r-kdt)*c(3,j) + r*c(4,j)  |   
%  |    0           0          -r      2+2*r+kdt     -r          0          0    ||c(4,j+1)|   =    | r*c(3,j) + (2-2*r-kdt)*c(4,j) + r*c(5,j)  |
%  |    0           0           0         -r      2+2*r+kdt     -r          0    ||c(5,j+1)|        | r*c(4,j) + (2-2*r-kdt)*c(5,j) + r*c(6,j)  |   
%  |    0           0           0          0         -r      2+2*r+kdt     -r    ||c(6,j+1)|        | r*c(5,j) + (2-2*r-kdt)*c(6,j) + r*c(7,j)  |  
%  |    0           0           0          0          0        -2*r     2+2*r+kdt||c(7,j+1)|        |2*r*c(6,j)+ (2-2*r-k)*c(7,j)               |    
%
%
% Here is how we can make the algrorithm.  Assume that sl = sr = 0
%
D = 0.7; % D in km^2/hr
k = 0; % k in 1/hr
L = 200; % domain length in meters
%  space variables
npart = 400; % number of partitions
nplot = 200 % time step 'nplot' is one where concentration versus time for fixed x can be plotted
n = npart + 1; % number of nodes
nm = n % number of compute nodes
dx = L / npart; % size of partitions, in m
dx2 = dx * dx; % square the size once so you don't have to do it again!
% time variables
T = 60 % total time for simulation, hours
npt = 200; % number of time steps to take (intervals)
nt = npt + 1 % total number of time points (including initial condition)
dt = T / npt; % size of time steps
r = D * dt / (dx2)
kdt = k * dt
%
c = zeros(nm, nt); % initialize the solution array
c2 = zeros(nm, 1);
c3 = zeros(1, 2);
%
M = zeros(nm, nm); % initialize the array
b = zeros(nm, 1); % initialize the b column vector; remember, this vector is an nm x 1 array in MATLAB

%
M(1, 1) = (2 + 2 * r + kdt); % the first row is special
M(1, 2) = -2 * r; % the first row is special
%
M(nm, nm-1) = -2 * r; % so is the last row
M(nm, nm) = (2 + 2 * r + kdt); % so is the last row
% 
% now make a  loop to fill in the rest...
for k = 2:1:nm-1 % loop over the rows of the array (nm x nm)
    M(k, k-1) = -r; % set the subdiagonal value
    M(k, k) = (2 + 2 * r + kdt); % set the diagonal value 
    M(k, k+1) = -r; % set the subdiagonal value
end
%
% set the initial condition here
% I am choosing a "gaussian" shape...
%
beta = 0.1; % just a parameter to set the initial condition function
x = linspace(0, L, nm); % discretize the initial condition space
c(:, 1) = exp(-beta * ((x - L / 2) .* (x - L / 2))); % compute the initial condition, c(i,1)
%
% now loop over time steps.  at each time, we need to (1) compute the
% b-vector and (2) invert the solution...
%

disp('computations going....');

for j = 1:1:nt-1
    b(1) =(2 - 2 * r - kdt) * c(1, j) + 2 * r * c(2, j); % first value in the b vector
    b(nm) = 2 * r * c(nm-1, j) + (2 - 2 * r - kdt) * c(nm, j); % last value in the b vector
    for jj = 2:1:nm-1
        b(jj) = r * c(jj-1, j) + (2 - 2 * r - kdt) * c(jj, j) + r * c(jj+1, j); % compute the rest of the b vector
    end
  %
    time = j * dt;
    c(:, j+1) = M \ b; % solve
    c3(j+1, 1) = time;
    c3(j+1, 2) = c(nplot, j+1);
end

plot(c3(:, 1), c3(:, 2))
xlabel('Time (days)', 'FontSize', 18)
ylabel('c', 'Fontsize', 18)
text(20, .9, 'Breakthrough curve at x=150 m', 'FontSize',18)
set(gca, 'ylim', [0 1])
%
nstep = 4; % only plot out some of the time steps; set the value here
kk = 0; % this is the counter for the vector c2 that will contain the subset of the solution to plot
for k = 1:nstep:nt
    kk = kk + 1;
    c2(:, kk) = c(:, k);
end
% plot the solution
surf(c, 'EdgeColor', 'none')
camlight left; lighting phong
disp('----> Plot of solution in Figure window')
disp('PRESS <ENTER> TO CONTINUE')
pause
% 
bb=zeros(nm);
for j = 1:nt
    bb = c(:, j);
    plot(x, bb);
    set(gca, 'ylim', [0 1]) % this sets the bounds of the y axis...
    fig(j) = getframe;
end
