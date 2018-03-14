% Simulation of Hill-type muscle model
% Author: Mike Pavol
%
% The model is based on:
% Kaufman, K.R., An, K.-N., & Chao, E.Y.S. (1989). Journal of Biomechanics,
% 22, 943-948.
% Winters, J.M, & Stark, L. (1985). IEEE Transactions on Biomedical
% Engineering, 32, 826-839.
% Zajac, F.E., Topp, E.L., & Stevenson, P.J. (1986). Proceedings of the
% IEEE Eighth Annual Conference of the Engineering in Medicine and Biology
% Society, 601-604.

clear all
global N_OnTime N_OffTime N_ExciteLevel
global MT_StartLength MT_StartTime MT_Velocity MT_StopTime MT_Parameters

% ----------------------------------------------------------------
% set simulation parameters

SimulationTime=1.; % s

% neural excitation
N_OnTime=0.1; % s
N_OffTime=0.5; % s
N_ExciteLevel=1.; % 0.01 - 1

% musculotendon kinematics
MT_StartStrain=0.;
MT_StartTime=0.; % s
MT_Velocity=0.; % m/s (+ for lengthening, - for shortening)
MT_Distance=0.; % m (+ for lengthening, - for shortening)

% musculotendon parameters
taune=0.025; % excitation time constant (s)
taua=0.01; % activation time constant (s)
taud=0.04; % deactivation time constant (s)
Fmax=100; % maximum isometric force (N)
lm0=0.15; % muscle fiber optimal length (m)
pennation=5; % pennation angle (deg)
vmax=4.0; % maximum shortening velocity (fiber lengths/s)
bfv=0.2; % force-velocity shape parameter
k1pe=0.8; % parallel elastic gain (N) 
k2pe=12; % parallel elastic exponential gain
lse0=0.10; % series elastic slack length (m)
k1se=31.0; % series elastic gain (N) (set so Fse=Fmax at 0.033 strain)
k2se=43.7; % series elastic exponential gain
% ----------------------------------------------------------------

% enforce limits on neural activation level
N_ExciteLevel=min(max(N_ExciteLevel,0.01),1);
% compute stop time for muscle length change
if MT_Velocity~=0
    MT_StopTime=MT_StartTime+MT_Distance/MT_Velocity;
else
    MT_StopTime=SimulationTime;
end
% convert pennation angle to radians
pennation=pennation*pi/180.;
% create parameter array
MT_Parameters=[taune taua taud Fmax lm0 pennation vmax bfv k1pe k2pe lse0 k1se k2se];

% determine simulation output times
t=(0:0.001:1)*SimulationTime;

% initialize excitation and activation state variables
q0(1)=0.01; % neural excitation
q0(2)=0.01; % muscle activation

% find muscle length
lm=lm0*(1+MT_StartStrain);
% find pennation angle
widthm=lm0*sin(pennation);
angle=asin(widthm/lm);
% find parallel elastic force
Fpe=k1pe*exp(k2pe*MT_StartStrain);
% find contractile element force
Fce=Fmax*q0(2)*exp(-1*(2.727*log(MT_StartStrain+1))^2);
% find series elastic force and set as initial value
Fse=(Fpe+Fce)*cos(angle);
q0(3)=Fse;
% find series elastic strain and length
ese=log(Fse/k1se+1)/k2se;
lse=lse0*(1+ese);
% find starting musculotendon length for equilibrium
MT_StartLength=lse+lm*cos(angle);

% simulate to determine muscle activation and force over time
ode_options=odeset('MaxStep',0.0001);
[tout,qout]=ode45(@Hill_Muscle_ddt,t,q0,ode_options);

% compute musculotendon length
lmt=zeros(1001,1);
for i=1:1001
    if tout(i)<MT_StartTime
        lmt(i)=MT_StartLength;
    elseif tout(i)<MT_StopTime
        lmt(i)=MT_StartLength+MT_Velocity*(tout(i)-MT_StartTime);
    else
        lmt(i)=MT_StartLength+MT_Distance;
    end
end

% plot results
subplot(3,1,1), plot(tout,lmt);
xlabel('Time (s)');
ylabel('Length (m)');
subplot(3,1,2), plot(tout,qout(:,2));
xlabel('Time (s)');
ylabel('Activation');
subplot(3,1,3), plot(tout,qout(:,3));
xlabel('Time (s)');
ylabel('Force (N)');

% open output file
outptr=fopen('Hill_Muscle.csv','w');
% output data to file
fprintf(outptr,'Time(s),Length(m),Activation,Force(N)\n');
for i=1:1001
    fprintf(outptr,'%6.3f,%7.3f,%5.3f,%8.3f\n',tout(i),lmt(i),qout(i,2),qout(i,3));
end
% close file
fclose(outptr);