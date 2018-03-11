% Simulation of neural control of muscle force
% Author: Mike Pavol

clear all
clf
global Nunits MUOnTime MUFiringRateOn MUdFiringRatedt MUFiringRateMax MUType
global tprev tcurr tnext

% ----------------------------------------------------------------
% set simulation parameters

SimulationTime=2.0; % s
Nunits=10; % number of motor units
MUOnTime=[0.1 -1 -1 -1 -1 -1 -1 -1 -1 -1]; % s
MUFiringRateOn=[5 0 0 0 0 0 0 0 0 0]; % Hz
MUdFiringRatedt=[0 0 0 0 0 0 0 0 0 0]; % Hz/s
MUFiringRateMax=[100 100 100 100 100 100 100 100 100 100]; % Hz
MUForce=[1.0 1.4 2.6 1.1 4.1 1.2 1.7 5.0 2.1 3.3]; % N
MUType=[1 1 2 1 2 1 1 2 1 2]; % Type 1 or Type 2 muscle fibers
MUAsynchrony=1;
% ----------------------------------------------------------------

% determine simulation output times
t=(0:0.001:1)*SimulationTime;

% initialize time of previous, current, and next action potential
tprev=zeros(Nunits,1);
tcurr=zeros(Nunits,1);
tnext=zeros(Nunits,1);
for i=1:Nunits
	tprev(i)=-1;
	tcurr(i)=-1;
	tnext(i)=MUOnTime(i);
end

% initialize active state of each motor unit
a0=zeros(Nunits,1);

% add asynchrony to the motor unit onset times
for i=1:Nunits
    MUOnTime(i)=MUOnTime(i)+MUAsynchrony*rand()/MUFiringRateMax(i);
end

% simulate to determine active state of each motor unit over time
ode_options=odeset('MaxStep',0.0005);
[tout,aout]=ode45(@Force_Control_ddt,t,a0,ode_options);
% compute muscle force as sum of motor unit forces
force=aout*MUForce';

% plot results
plot(tout,force);
xlabel('Time (s)');
ylabel('Force (N)');

% open output file
outptr=fopen('Force_Control.csv','w');
% output data to file
fprintf(outptr,'Time(s),Force(N)\n');
for i=1:1001
    fprintf(outptr,'%6.3f,%8.3f\n',tout(i),force(i));
end
% close file
fclose(outptr);