% Function used in simulation of distribution moment muscle model
% Author: Mike Pavol

function dqdt=DM_Muscle_ddt(t,q)

	global N_OnTime N_OffTime N_ExciteLevel
    global M_StartLength M_StartTime M_Velocity M_StopTime M_Parameters
    
 % extract state variables
    c=q(1);
    lambda=q(2);
    Q0=q(3);
    Q1=q(4);
    Q2=q(5);
   
% extract parameters
    taua=M_Parameters(1);
    taud=M_Parameters(2);
    mu=M_Parameters(3);
    lm0=M_Parameters(4);
    s0=M_Parameters(5);
    h=M_Parameters(6);
    f1=M_Parameters(7);
    g1=M_Parameters(8);
    g2=M_Parameters(9);
    g3=M_Parameters(10);
    x0=M_Parameters(11);
    kappa=M_Parameters(12);
    gamma=M_Parameters(13);

% determine neural excitation level
    if (t>=N_OnTime)&&(t<=N_OffTime)
        n=N_ExciteLevel;
    else
        n=0;
    end
    
% determine muscle length and relative shortening velocity
    if t<M_StartTime
        lm=M_StartLength;
        u=0;
    elseif t<M_StopTime
        lm=M_StartLength+M_Velocity*(t-M_StartTime);
        u=-M_Velocity*s0/(2*lm0*h);
    else
        lm=M_StartLength+M_Velocity*(M_StopTime-M_StartTime);
        u=0;
    end
   
% find rate of change of free calcium concentration (simplified model)
    if n>c
		dcdt=(n-c)/taua;
	else
		dcdt=(n-c)/taud;
	end
   
% compute activation factor    
    r=c^2/(c^2+mu*c+mu^2);
    
% find proportion of available cross-bridges
    em=(lm-lm0)/lm0;
    alpha=exp(-1*(2.727*log(em+1))^2);
        
% find beta functions
    beta0=f1/2;
    beta1=f1/3;
    beta2=f1/4;

% check that crossbridges present
    if Q0~=0
% find mean and standard deviation of bond distribution function
        p=Q1/Q0;
        q=sqrt((Q2/Q0)-(Q1/Q0)^2);
% initialize matrices
        x=zeros(601,1);
        integrand=zeros(601,1);
% compute phi functions over range of -3 to +3 sd about the mean
        for i=1:601
% find normalized length
            x(i)=p+3*q*(i-301)/300;
% find corresponding f+g rate functions
            if x(i)<0
                fg=g2;
            elseif x(i)<=1
                fg=(f1+g1)*x(i);
            elseif x(i)<x0
                fg=g1*x(i);
            else
                fg=(g1+g3)*x(i);
            end    
% compute corresponding bond distribtution function    
            n=Q0/(sqrt(2*pi)*q)*exp(-1*(x(i)-p)^2/(2*q^2));
% find integrand
            integrand(i)=fg*n;
        end
% compute phi0
        phi0=trapz(integrand)*3*q/300;
% compute phi1
        integrand=x.*integrand;
        phi1=trapz(integrand)*3*q/300;
% compute phi2
        integrand=x.*integrand;
        phi2=trapz(integrand)*3*q/300;
    else    
% if no crossbridges present, phi functions are zero
        phi0=0;
        phi1=0;
        phi2=0;
    end

% find rates of change of moments of bond distribution function
    dQ0dt=r*alpha*beta0-phi0;
    dQ1dt=r*alpha*beta1-phi1-u*Q0;
    dQ2dt=r*alpha*beta2-phi2-2*u*Q1;

% find rate of change of normalized muscle length
    dlambdt=kappa*dQ1dt-gamma*u;
    
% return rates of change of state variables
    dqdt=zeros(5,1);
    dqdt(1)=dcdt;
    dqdt(2)=dlambdt;
    dqdt(3)=dQ0dt;
    dqdt(4)=dQ1dt;
    dqdt(5)=dQ2dt;