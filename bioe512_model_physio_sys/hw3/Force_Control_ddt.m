% Function used in simulation of neural control of muscle force
% Author: Mike Pavol

function ddt=Force_Control_ddt(t,a)

	global Nunits MUOnTime MUFiringRateOn MUdFiringRatedt MUFiringRateMax MUType
	global tprev tcurr tnext

% set the action potential duration
	APduration=0.01;
% set contraction time constant for Type 1 and 2 fibers
	TauC=[0.015 0.005];
% set relaxation time constant for Type 1 and 2 fibers
	TauR=[0.050 0.030];
% initialize output
    ddt=zeros(Nunits,1);
% loop through all motor units
	for i=1:Nunits
% process recruited motor units
		if MUOnTime(i)>=0
% if reached start of next action potential, update action potential times 
			if t>=tnext(i)
				tprev(i)=tcurr(i);
				tcurr(i)=tnext(i);				
				FiringRate=min(MUFiringRateOn(i)+MUdFiringRatedt(i)*(tnext(i)-MUOnTime(i)),MUFiringRateMax(i));
				if FiringRate>0
                    dt=1/FiringRate;					
    				tnext(i)=tnext(i)+dt;
                else
                    tnext(i)=inf;
                end
            end
% find time from start of action potential
			if t>=tcurr(i)
				tAP=t-tcurr(i);
			else
				tAP=t-tprev(i);
			end
% calculate current neural signal
			if tAP<APduration/2
				n=2*tAP/APduration;
			elseif tAP<APduration
				n=2*(1-tAP/APduration);
			else
				n=0;
			end
% calculate rate of active state increase or decrease
			if n>a(i)
				ddt(i)=(n-a(i))/TauC(MUType(i));
			else
				ddt(i)=(n-a(i))/TauR(MUType(i));
			end
% no change in active state for motor units not recruited
		else
			ddt(i)=0;
		end
    end