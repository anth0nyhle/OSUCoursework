
% impde.m  - A file to compute the implicit solution to a second-order initial boundary value
% problem with a source. This code assumes that the bvp takes the form
%
%              dc/dt = D(t) * d^2c/dx^2 - U * dc/dx -s(x,t)
%              dc/dx (x=0) = 0       (boundary condition 1)
%              dc/dx (x=L) = 0       (boundary condition 2)
%              c(x,t=0) = f(x)       (initial condition)
%
% assume that we are going to discretize this problem in space and in time.  for
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
%      [c(i,j+1)-c(i,j)]/dt  = 1/2*D0*((1-th)*dd(j)*[c(i+1,j)-2*c(i,j)+c(i-1,j)]/(dx)^2
%      +th*dd(j+1)*[c(i+1,j+1)-2*c(i,j+1)+c(i-1,j+1)]/(dx)^2)
%      -U*((1-th)*[c(i+1,j)-c(i-1,j)/(2*dx)]+th*[c(i+1,j+1)-c(i-1,j+1)/(2*dx)])
%      -[(1-th)*s(i,j)+th*s(i,j+1)]
%
% (where here D is the dispersion coefficient, c is the concentration,
% dx is the grid spacing, dt is the time step size, and th is the "theta" weight: 0<th<=1)). 
%
% Putting this in linear form (i.e., combining terms) gives an *implicit* 
% scheme.  Basically, we put all of the c(i+1,.) variables on the left-hand
% side, and all of the rest of the varialbles (c(i,.), s(i), s(i+1))
% varibles on the right-hand side.  Note:  The right-hand side is all
% *known*
%
% ==========================================================================================
% ==========================================================================================
%      -th*(w+r dd(j+1))*c(i-1,j+1)+(1+2*r*th*dd(j+1))*c(i,j+1)-th*(-w+r*dd(j+1))*c(i+1,j+1) = 
%        thc*(w+r*dd(j))*c(i-1,j)+(1-2*r*thc*dd(j))*c(i,j)+thc*(-w+r*dd(j))*c(i+1,j)
%            -[th*s(i,j+1)+thc*s(i,j)]
% ==========================================================================================
% ==========================================================================================
% 
% where r = D0*dt/(dx^2)
% w = U*dt/(2*dx)
% thc = (1 - th)
% D0= diffusion coefficient
% dd(t) = D(t)/D0
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
% constants (sources, sinks, boundary conditions) that appear in the
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
% (1)  [c(2,j)-c(0,j)]/(2*dx) = 0
% (2)  [c(8,j)-c(6,j)]/(2*dx) = 0
% (3)  [c(2,j+1)-c(0,j+1)]/(2*dx) = 0
% (4)  [c(8,j+1)-c(6,j+1)]/(2*dx) = 0
%
% Assuming that sl=sr=0,then we can rearrange to solve for the values at the "fictitious" nodes
%
% (5)  c(0,j)= c(2,j)           (7)  c(8,j)= c(6,j)
% (6)  c(0,j+1)= c(2,j+1)       (8)  c(8,j+1)= c(6,j+1)
%
% now, for the **first row (i=1)** the recurrence relationship gives
%
%      -th*(w+r dd(j+1))*c(0,j+1)+(1+2*r*th*dd(j+1))*c(1,j+1)-th*(-w+r*dd(j+1))*c(2,j+1) = 
%        thc*(w+r*dd(j))*c(0,j)+(1-2*r*thc*dd(j))*c(1,j)+thc*(-w+r*dd(j))*c(2,j)
%            -[th*s(1,j+1)+thc*s(1,j)]
%
% elimiating c(0,j+1) and c(0,j) using equations (5) and (6) above gives
%
%     (1+2*r*th*dd(j+1))*c(1,j+1)-2*th*r*dd(j+1)*c(2,j+1) = 
%        (1-2*r*thc*dd(j))*c(1,j)+thc*(2*r*dd(j))*c(2,j)
%            -[th*s(1,j+1)+thc*s(1,j)]
%
% similarly, for the last row (i=n), we will get
%
%      -2*th*r*dd(j+1)*c(n-1,j+1)+(1+2*r*th*dd(j+1))*c(n,j+1) = 
%        thc*(2*r*dd(j))*c(n-1,j)+(1-2*r*thc*dd(j))*c(n,j)
%            -[th*s(n,j+1)+thc*s(n,j)]
%
% the result is a system of equations that has the matrix form
%
%  |1+2*r*th*dd(j+1)    -2*th*r*dd(j+1)         0                      0         ||c(1,j+1)|   | (1-2*r*thc*dd(j))*c(1,j)+thc*(2r*dd(j))*c(2,j)-[th*s(1,j+1)+thc*s(1,j)] |               
%  |-th*(w+r dd(j+1))   1+2*r*th*dd(j+1)   -th*(-w+r*dd(j+1))          0         ||c(2,j+1)|   |rhs(2) |    
%  |    0               -th*(w+r dd(j+1))  1+2*r*th*dd(j+1)   -th*(-w+r*dd(j+1)) ||c(3,j+1)|=  |rhs(3) |   
%  |    0                       0         -2*th*r*dd(j+1)     (1+2*r*th*dd(j+1)) ||c(4,j+1)|   |hc*(2*r*dd(j))*c(n-1,j)+(1-2*r*thc*dd(j))*c(n,j)-[th*s(n,j+1)+thc*s(n,j)] |
%
% Here is how we can make the algrorithm.  Assume that sl = sr = 0
%
clear all
U=1.0*10^(-5)                     % velocity in m/s
D00=1*10^(-9);  % Diffusion coefficient in m^2/s
D0=1.
%D0=1.
%alpha = 1e-1;                    % alpha in (days)^-1
L = 1.6;                          % domain length in meters
%  space variables
npart = 1000;                     % number of partitions
nplot = 6;
n = npart+1;                      % number of nodes
nm = n;                           % number of compute nodes
dx = L/npart;                     % size of partitions, in m
dx2 = dx * dx;                    % square the size once so you don't have to do it again!
% time variables
T=1000*60;                         % total time for simulation, s
npt = 400000;					  % number of time steps to take (intervals)
nt = npt+1;                       % total number of time points (including initial condition)
dt = T/npt;                       % size of time steps
th = 1/2;                         % Value for theta; 
thc = 1-th;
r = D0*dt/(dx2);
r2= D00*dt/(dx2)
w = U*dt/(2*dx)
courant = U*dt/dx
t=linspace(0,T,nt);                 % discretize time
% ttt=size(t);
% t(ttt+1)=t(ttt)+dt;
x = linspace(0,L,nm);                % discretize space
nx = length(x);
one=ones(1,nx);
onet=ones(1,nt);
onep=ones(1,nx+1);
%  Compute the effective dispersion coefficient, D(t)/D0 here.
dd=D00*(200*(1-exp(-t./(100*60)))+1);
%dd=1.*onet;
%
%Set a value for the source term, s(i,j) here.  Note, I have added one extra "s" value for
%the final time so that a proper average can be computed at the final time
%step
for jj=1:nt
    for ii=1:nm
sor=s_star();
sor=sor*dt
    end
end
%
% Set up the initial condition here.  I am just using a random Gaussian
% right now...
c=zeros(nm,nt);                     % initialize the solution array
alpha1 = 1.1*ones;
alpha2 = 1.1*ones;
beta1 = 0.125*ones;
beta2 = 0.325*ones;
sigma1 = 0.03;
sigma2 = 0.03;
c(:,1) = 1/3*alpha1*exp(-(x-beta1).*(x-beta1)/(sigma1*sigma1))+2/3*alpha2*exp(-(x-beta2).*(x-beta2)/(sigma2*sigma2));    % compute the initial condition, c(i,1)
m1(:,1)=c(:,1).* x(:);
m2(:,1)=(c(:,1).*(x(:).* x(:))-2*(x(:).* m1(:,1))+m1(:,1).*m1(:,1));
%
%
%  Loop over time here
%  At each time, we need to (1) compute the new M array
%  (2) compute the new b-vector and (3) invert the solution...
%
disp('computations going....')

kskip0 = npt/10;
kskip=kskip0;
for j=2:1:nt
  if j == kskip
      T=['time =',num2str(j),' steps out of ',num2str(nt)];
      disp(T);
      kskip = kskip+kskip0;
  end
M = zeros(nm,nm);                   % initialize the array
b = zeros(nm,1);                    % initialize the b column vector; remember, this vector is an nm x 1 array in MATLAB

%
M(1,1) = 1+2*r*th*dd(j);                     % the first row is special
bbb(1) = M(1,1);
M(1,2) = -2*th*r*dd(j);                       % the first row is special
ccc(1)=M(1,2);
%
M(nm,nm-1) = -2*th*r*dd(j);                   % so is the last row
aaa(nm-1)=M(nm,nm-1);
M(nm,nm) = 1+2*r*th*dd(j);                   % so is the last row
bbb(nm)=M(nm,nm);
% 
% now make a nice loop to fill in the rest...
for k=2:1:nm-1                      % loop over the rows of the array (nm x nm)
    M(k,k-1) = -th*(r*dd(j)+w);     % set the subdiagonal value
    aaa(k-1)=M(k,k-1);
    M(k,k) = (1+2*r*th*dd(j));                 % set the diagonal value 
    bbb(k)=M(k,k);
    M(k,k+1) = -th*(r*dd(j)-w);                   % set the subdiagonal value
    ccc(k)=M(k,k+1);
end
%
%
  b(1) =thc*(r*dd(j-1)+w)*c(2,j-1)+(1-2*r*thc*dd(j))*c(1,j-1)+thc*(r*dd(j-1)-w)*c(2,j-1)-(th*sor(1,j)+thc*sor(1,j-1))*dt;   % first value in the b vector.  recall c(0,j)=c(2,j)
  b(nm)=thc*(r*dd(j-1)+w)*c(nm-1,j-1)+(1-2*r*thc*dd(j))*c(nm,j-1)+thc*(r*dd(j-1)-w)*c(nm-1,j-1)-(th*sor(nm,j)+thc*sor(nm,j-1))*dt; % last value in the b vector.  recall c(nm+1,j)=c(nm-1,j)
  for ii = 2:1:nm-1
      b(ii) = thc*(r*dd(j-1)+w)*c(ii-1,j-1)+(1-2*r*thc*dd(j))*c(ii,j-1)+thc*(r*dd(j-1)-w)*c(ii+1,j-1)-(th*sor(ii,j)+thc*sor(ii,j-1))*dt;       % compute the rest of the b vector
  end
  %display(b);
  time = j*dt;
  %c(:,j) = M\b;        % solve
  c(:,j) = tridisolve(aaa,bbb,ccc,b);  % solve
  c3(j,1) = time;
  c3(j,2) = c(nplot,j);
%   mass0=c(:,j);
%   mass(j)=sum(mass0);
    m1(:,j)=c(:,j).* x(:);
end
mass0=dx*sum(c);            % this has been validated as correct
mass1=dx*sum(m1)./mass0;    % this has been valideated as correct
for jj=1:nt
    mm=mass1(jj);
for ii=1:nx
   mave(ii,jj)=mm*one(ii);
   m2(ii,jj)=c(ii,jj)*(x(ii)-mave(ii,jj))*(x(ii)-mave(ii,jj));
end
end
mass2=dx*sum(m2)./mass0;        % this has been valideated as correct
vm1=diff(mass1)/dt;             % this has been validated as correct
diffest =1/2.*diff(mass2)/(dt); %this has been validated as correct
diffest(nt) = diffest(nt-1);    %this just makes the dimenstions the same as time...
plot(mass0);
pause
plot(vm1);
pause
plot(diffest);

% plot(c3(:,1),c3(:,2))
% xlabel('Time (days)','FontSize',18)
% ylabel('c','Fontsize',18)
% text(20,.9,'Breakthrough curve at x=150 m','FontSize',18)
% set(gca,'ylim',[0 1])
% set(gca,'xlim',[0 1.6])
%
 ntstep = 50;
 nxstep = 1;
 % only plot out some of the space- time steps; set the values here
  k=1;
 for kk = 1:ntstep:nt
     j=1;
     for jj =1:nxstep:nm
     c2(j,k)=c(jj,kk);
     j=j+1;
     end
     k=k+1;
 end
% % %plot the solution
%   surf(c2,'EdgeColor','none')
%   camlight left; lighting phong
%   
%   pause
% % 
%   bb=zeros(nm);
%   for j=1:nt
%       bb=c(:,j);
%       plot(x,bb);
%       %set(gca,'ylim',[-1 1])              % this sets the bounds of the y axis...
%       set(gca,'xlim',[0 1.6]) 
%       fig(j)=getframe;
%   end
hold on;
plot(c(:,1));
plot(c(:,20000));
plot(c(:,40000));
plot(c(:,100000));
plot(c(:,200000));
plot(c(:,400000));
