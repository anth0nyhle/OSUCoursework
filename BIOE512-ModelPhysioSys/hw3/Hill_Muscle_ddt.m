% Function used in simulation of Hill-type muscle model
% Author: Mike Pavol

function dqdt=Hill_Muscle_ddt(t,q)

	global N_OnTime N_OffTime N_ExciteLevel
    global MT_StartLength MT_StartTime MT_Velocity MT_StopTime MT_Parameters

% extract state variables
    ne=q(1);
    a=q(2);
    Fse=q(3);

% extract parameters
    taune=MT_Parameters(1);
    taua=MT_Parameters(2);
    taud=MT_Parameters(3);
    Fmax=MT_Parameters(4);
    lm0=MT_Parameters(5);
    pennation=MT_Parameters(6);
    vmax=MT_Parameters(7);
    bfv=MT_Parameters(8);
    k1pe=MT_Parameters(9);
    k2pe=MT_Parameters(10);
    lse0=MT_Parameters(11);
    k1se=MT_Parameters(12);
    k2se=MT_Parameters(13);
   
% determine neural excitation level
    if (t>=N_OnTime)&&(t<=N_OffTime)
        n=N_ExciteLevel;
    else
        n=0.01;
    end
% determine musculotendon length and lengthening velocity
    if t<MT_StartTime
        lmt=MT_StartLength;
        vmt=0;
    elseif t<MT_StopTime
        lmt=MT_StartLength+MT_Velocity*(t-MT_StartTime);
        vmt=MT_Velocity;
    else
        lmt=MT_StartLength+MT_Velocity*(MT_StopTime-MT_StartTime);
        vmt=0;
    end

% find rate of change of neural excitation
    dnedt=(n-ne)/taune;

% find rate of active state increase or decrease
	if ne>a
		dadt=(ne-a)/taua;
	else
		dadt=(ne-a)/taud;
	end
    
% find length of series elastic element
    ese=log(Fse/k1se+1)/k2se;
    lse=lse0*(1+ese);
% find pennation angle
    widthm=lm0*sin(pennation);
    angle=atan2(widthm,lmt-lse);
% find muscle length and strain
    lm=(lmt-lse)/cos(angle);
    em=(lm-lm0)/lm0;
% find parallel elastic force
    Fpe=k1pe*exp(k2pe*em);
% find contractile element force
    Fce=Fse/cos(angle)-Fpe;
% find length-tension gain
    Glt=exp(-1*(2.727*log(em+1))^2);
% find force-velocity gain
    Gfv=Fce/(a*Fmax*Glt);
% find contractile element lengthening velocity
    afv=bfv/(vmax*lm0);
    if Gfv<=1
        vce=(Gfv-1)*bfv/(Gfv+afv);
    elseif Gfv<1.3
        vce=(Gfv-1)*0.5*bfv/(1.3-Gfv+0.3*afv);
    else
        vce=0.5*bfv/(0.3*afv)*((1+1/afv)*(Gfv-1.3)+0.3);
    end
% find series elastic lengthening velocity and strain rate
    dangdt=-vce/sqrt(1-(widthm/lm)^2)*widthm/(lm^2);
    vse=vmt-vce*cos(angle)+lm*sin(angle)*dangdt;
    desedt=vse/lse0;
% find rate of change of series elastic force
    dFsedt=k1se*k2se*exp(k2se*ese)*desedt;

% return rate of change of state variables
    dqdt=zeros(3,1);
    dqdt(1)=dnedt;
    dqdt(2)=dadt;
    dqdt(3)=dFsedt;