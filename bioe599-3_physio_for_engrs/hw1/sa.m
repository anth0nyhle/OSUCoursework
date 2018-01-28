%filename: sa.m
close all;
clear all; % clear all variables
clf; % and figures
global T TS TMAX QMAX;
global Rs Csa dt;
% in_sa %initialization
normal_in_sa
% aging_in_sa

PSA = [];

for klok=1:klokmax
    t=klok*dt;
    QAo=QAo_now(t);
    Psa=Psa_new(Psa,QAo); %new Psa overwrites old
    %Store values in arrays for future plotting:
    t_plot(klok)=t;
    QAo_plot(klok)=QAo;
    Psa_plot(klok)=Psa;
    PSA = [PSA; Psa];
end

%Now plot results in one figure
%with QAo(t) in upper frame
% and Psa(t) in lower frame
subplot(2,1,1), plot(t_plot,QAo_plot), xlabel('time (min)'), ylabel('QAo (L/min)')
subplot(2,1,2), plot(t_plot,Psa_plot), xlabel('time (min)'), ylabel('Psa (mm Hg)')
max_psa = max(PSA(1200:1500))
min_psa = min(PSA(1200:1500))
avg_psa = mean(PSA(1200:1500))