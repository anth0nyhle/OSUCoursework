% Simulation of distribution moment muscle model
% Author: Mike Pavol

% This program implements a modified version of the model described in:
% Zahalak, G.I., & Ma, S.-P. (1990). Muscle activation and contraction:
% Constitutive relations based directly on cross-bridge kinetics. Journal
% of Biomechanical Engineering, 112, 52-62.

clear all
global N_OnTime N_OffTime N_ExciteLevel
global M_StartLength M_StartTime M_Velocity M_StopTime M_Parameters

% ----------------------------------------------------------------
% set simulation parameters

SimulationTime=1.; % s

% neural excitation
N_OnTime=0.1; % s
N_OffTime=0.5; % s
N_ExciteLevel=1.; % 0 - 1

% muscle kinematics
M_StartLength=0.15; % m
M_StartTime=0.; % s
M_Velocity=0.; % m/s (+ for lengthening, - for shortening)
M_Distance=0.; % m (+ for lengthening, - for shortening)

% musculotendon parameters
taua=0.005; % activation time constant (s)
taud=0.010; % deactivation time constant (s)
mu=0.01; % troponin calcium release time constant (s);
Fmax=100; % maximum isometric force (N)
lm0=0.15; % muscle fiber optimal length (m)
s0=2.4e-6; % sarcomere length (m)
h=27.e-9; % bond length scaling factor (m)
f1=30.; % crossbridge bonding rate at max. bond length (1/s)
g1=8.; % crossbridge unbonding rate at max. bond length (1/s)
g2=170.; % crossbridge unbonding rate below min. bond length (1/s)
g3=30.; % crossbridge increase in unbonding rate at x0 (1/s)
x0=1.1; % bond length of increased unbonding
lt0=0.10; % tendon initial length (m)
kappa=0.033; % tendon compliance 
% ----------------------------------------------------------------

% compute initial musculotendon length
MT_StartLength=M_StartLength+lt0;
% compute stop time for muscle length change
if M_Velocity~=0;
    M_StopTime=M_StartTime+M_Distance/M_Velocity;
else
    M_StopTime=SimulationTime;
end
% compute ratio of tendon velocity to sarcomere velocity
gamma=2*lm0*h/(MT_StartLength*s0);

% create parameter array
M_Parameters=[taua taud mu lm0 s0 h f1 g1 g2 g3 x0 kappa gamma];

% determine simulation output times
t=(0:0.001:1)*SimulationTime;

% initialize free calcium concentration
q0(1)=0.0;
% initialize musculotendon stretch ratio
lmt0=lm0+lt0;
q0(2)=MT_StartLength/lmt0;
% initialize bond distribution moments
q0(3)=0.;
q0(4)=0.;
q0(5)=0.;

% simulate to compute state variables over time
ode_options=odeset('MaxStep',0.0001);
[tout,qout]=ode45(@DM_Muscle_ddt,t,q0,ode_options);

% compute musculotendon length and force
MT_Length=qout(:,2)*lmt0;
MT_Force=Fmax*qout(:,4)/0.398448;

% plot results
subplot(3,1,1), plot(tout,MT_Length);
xlabel('Time (s)');
ylabel('Length (m)');
subplot(3,1,2), plot(tout,qout(:,1));
xlabel('Time (s)');
ylabel('[Calcium]');
subplot(3,1,3), plot(tout,MT_Force);
xlabel('Time (s)');
ylabel('Force (N)');

% open output file
outptr=fopen('DM_Muscle.csv','w');
% output data to file
fprintf(outptr,'Time(s),Length(m),[Calcium],Force(N)\n');
for i=1:1001
    fprintf(outptr,'%6.3f,%f,%f,%f\n',tout(i),MT_Length(i),qout(i,1),MT_Force(i));
end
% close file
fclose(outptr);