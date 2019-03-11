% xpde.m  - A file to compute the solution to a second-order initial boundary value
% problem. this code assumes that the bvp takes the form
%
%              dc/dt = D * d^2c/dx^2
%
% assume that we are going to discretize this problem in space and in time.  for
% reference, assume a spatial grid of the form
%
%
%        x=0                                 x=L
%         (-----------------------------------)
%
%   |-----|-----|-----|-----|-----|-----|-----|-----|
%   (-1)  0     1     2     3     4     5     6    (7)
%                               
%
% here, we have allowed for the possibility that two "fictitious" nodes might
% be needed to accommodate two derivative boundary conditions.
%
% the discretization of this problem is simple.  starting with the
% governing equation, substitute (1) a forward difference for the time derivative, and 
% (2) a centered-difference (fixed at time step "j") for the space derivative.  this gives 
% approximation of the second-order derivative.
%
%      [c(i,j+1)-c(i,j)]/dt  = D[c(i+1,j)-2*c(i,j)+c(i-1,j)]/(dx)^2 
%
% (where here D is the diffusion coefficient, c is the concentration,
% dx is the grid spacing, and dt is the time step size). 
%
% Putting this in linear form (i.e., combining terms) gives an *explicit* 
% scheme
%
%         c(i,j+1) = r*c(i-1,j)+(1-2*r)*c(i,j)+r*c(i+1,j)
%
% where r = D*dt/(dx^2)
%
% this represents our "recurrence relation" for constructing the matrix
% of equations that represents the algebraic decompostion of the original 
% differential equation.
%
% it should be apparent to you by now that this recurrence relationship
% defines a linear system of equations.  for this particular case, the
% system takes the form
%
%         c(j+1) = M . c(j) + b
%
% where c(j+1) is a *vector* of new concentration values (one for each 
% node where the concentration is unknown), and c(j) is the vector of the 
% current nodal values of concentration.  M is the matrix of coefficients
% that evolves the system of equations in time. b is the vector of
% constants (sources, sinks, boundary conditions) that appear in the
% equation set.
%
%
% the first and last rows of the matrix, M, are a little from the remaining rows.  
% The form of the first and last row depend on the type of boundary conditions 
% imposed.  For now, let's assume that two *derivative* (neuman) conditions are
% imposed.  suppose the two derivative boundary conditions are given by
% dc/dx = s1 (left) and dc/dx = s2 (right).  the centered difference
% representation of these two derivatives at nodes 0 and 6 would be
%
%  [c(1,j)-c(-1,j)]/(2*dx) = sl       [c(7,j)-c(5,j)]/(2*dx) = sr
%
% or, rearranging to solve for the values at the "fictitious" nodes
%
% c(-1,j)= c(1,j) - 2*s1*dx       c(7,j)= c(5,j) + 2*s2*dx
%
% now, for the first row the recurrence relationship gives
%
%        c(0,j+1) = r*c(-1,j)+(1-2*r)*c(0,j)+r*c(1,j)
%
% elimiating c(-1,j) using the first equation above gives
%
%        c(0,j+1) = r*[c(1,j) - 2*s1*dx]+(1-2*r)*c(0,j)+r*c(1,j)
% or
%          c(0,j+1) = (1-2*r)*c(0,j)+2*r*c(1,j) - 2*r*s1*dx 
%
% similarly, for the last line, we will get
%
%         c(6,j+1) = (1-2*r)*c(5,j)+2*r*c(6,j) + 2*r*s1*dx 
%
% the result is a system of equations that has the matrix form
%
%  |c(0,j+1)|    |1-2*r  2*r      0       0        0      0       0||c(0,j)|        |-2*r*sl*dx|
%  |c(1,j+1)|    |r     1-2*r     r       0        0      0       0||c(1,j)|        |0         |
%  |c(2,j+1)|    |0       r     1-2*r     r        0      0       0||c(2,j)|        |0         |
%  |c(3,j+1)|  = |0       0       r     1-2*r      r      0       0||c(3,j)|   +    |0         |
%  |c(4,j+1)|    |0       0       0       r      1-2*r    r       0||c(4,j)|        |0         |
%  |c(5,j+1)|    |0       0       0       0        r    1-2*r     r||c(5,j)|        |0         |
%  |c(6,j+1)|    |0       0       0       0        0     2*r  1-2*r||c(6,j)|        |+2*r*sr*dx|
%
% Here is how we can make the algrorithm.  Assume that sl = sr = 0
%
clear all
D = 8.6e-5;                         % D in m^2/day; corresponds to 1x10^-9 m^2/s
%k1 = 1e-1;                          % k1 in (days)^-1
L = 0.1;                            % domain length in meters
sl = 0;                             % the left-hand side boundary condition
sr = 0;                             % the right-hand side boundary condition
%
%  space variables
np = 40;                             % number of partitions
disp('Number of nodes')
n = np+1                             % number of nodes
nm = n;                              % number of compute nodes
disp('Size of space increments, meters')
dx = L/np                           % size of partitions, in m
dx2 = dx * dx;                      % square the size once so you don't have to do it again!
%
% time variables
disp('Time interval, days')
T=20
%T = 10                             % total time for simulation, days
disp('Number of time steps, days')
npt = 2000                          % number of time partitions
nt = npt+1;                          % total number of time points (including initial condition)
dt = T/npt;                          % size of time steps
%
disp('stability condition...')
condition = D * dt/(dx2)            % explicit condition
if condition > 0.5
    disp('stability condition not met!  Adjust parameters...')
end
%
M = zeros(nm,nm);                   % initialize the array
b = zeros(nm,1);                    % initialize the b column vector; remember, this vector is an nm x 1 array in MATLAB
r = D*dt/(dx2);
%
M(1,1) = 1-2*r;                     % the first row is special
M(1,2) = 2*r;                       % the first row is special
%
M(nm,nm-1) = 2*r;                   % so is the last row
M(nm,nm) = 1-2*r;                   % so is the last row
% 
b(1) = -2*r*sl*dx;                  % first value in the b vector
b(nm) = 2*r*sr*dx;                  % last value in the b vector; the rest are zeros
%
% now make a nice loop to fill in the rest...
for k=2:1:nm-1                      % loop over the rows of the array (nm x nm)
    M(k,k-1) = r;                   % set the subdiagonal value
    M(k,k) = 1-2*r;                 % set the diagonal value 
    M(k,k+1) = r;                   % set the subdiagonal value
end
% set the initial condition here
% I am choosing a "gaussian" shape...
%
beta = 10000;                       % just a parameter to set the initial condition function
x = linspace(0,L,n);                % discretize the initial condition space
f = exp(-beta*((x-L/2).*(x-L/2)));  % compute the initial condition
%display(M);
%display(b);
%
c=zeros(nm,nt);                     % initialize the solution array
c2=zeros(nm,1);                     % initialize this array for plotting.  we will use more than 1 time step, but that is ok; 
                                    % MATLAB will just resize the array for us
c(:,1) = f;                         % put the initial condition in our solution array
%
display('computations going....')
for j=2:1:nt
%    display(j);
    c(:,j) = M*c(:,j-1)+b(:);       % this is terribly inefficient... M is mostly zeros!
end
nstep = int32(400*npt/20000);       % this makes a new interger variable that will be used to plot only some of the solutions
                                    % 400 times npt/20000 just turns out to be a reasonable number of them.
                                    
kk=0;                               % this is the counter for the vector c2 that will contain the subset of the solution to plot
for k = 1:nstep:nt                  % the k loop will only plot out some of the time steps
    kk=kk+1;
    c2(:,kk)=c(:,k);
end

surf(c2)                            % plot a time-space-concentration surface....
display('----> Plot of solution in Figure window')
display('PRESS <ENTER> TO CONTINUE')
pause
knew = kk;
bb=zeros(nm);
for j=1:knew
    bb=c2(:,j);
    plot(x,bb);
    set(gca,'ylim',[0 1])              % this sets the bounds of the y axis...
    fig(j)=getframe;
end

display(' ')
display('if you would like to see the results as a movie, you can adjust the code...')
display('instructions are given in the M-file.')
%
%    movie(fig,10)                       % if you want to "play" the
%    simulation as a movie, uncomment this line... It will run it 10
%    times...
% 
