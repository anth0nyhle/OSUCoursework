%filename: sa.m
close all;
clear all; % clear all variables
clf; % and figures
global T TS TMAX QMAX;
global Rs Csa dt;
in_sa %initialization
% normal_in_sa
% aging_in_sa

% PSA = [];
% 
% for klok=1:klokmax
%     t=klok*dt;
%     QAo=QAo_now(t);
%     Psa=Psa_new(Psa,QAo); %new Psa overwrites old
%     %Store values in arrays for future plotting:
%     t_plot(klok)=t;
%     QAo_plot(klok)=QAo;
%     Psa_plot(klok)=Psa;
%     PSA = [PSA; Psa];
% end

[dt, dPsa] = ode45(@dPsa_new, [0 0.5], Psa);  

%Now plot results in one figure
%with QAo(t) in upper frame
% and Psa(t) in lower frame
% subplot(2,1,1), plot(dt, QAo), xlabel('time (min)'), ylabel('QAo (L/min)')
subplot(2,1,2), plot(dt, dPsa), xlabel('time (min)'), ylabel('Psa (mm Hg)')
max_psa = max(dPsa(500:597));
min_psa = min(dPsa(500:597));
avg_psa = mean(dPsa(500:597));