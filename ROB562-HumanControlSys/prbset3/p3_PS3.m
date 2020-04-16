% Created by: Anthony Le
% Last updated: 05-19-2017
% ROB 562: Human Control Systems

% Problem Set 3
%% Problem 3
clear;
close all;

b = 0.2;
K_s = 3;
K_p = 2;

tau = b/(K_s + K_p);

x_delta = 0;
x_dot = 0;

dT = 0.001;
freq = 80;
period = 1/freq;

T_o = 0;
T = 0;
T_plot = [];

start_t = 0;

pulse_w = 0.005;

for t = dT:dT:1
    if t > period + start_t
        start_t = start_t + period;
    end
    
    alpha = 0;
    if t <= start_t + pulse_w
        alpha = 45;
    end
    
    if t > 0.005 && t <= 0.01
        alpha = alpha + alpha;
    end
    
    T_o_dot = (alpha - T_o) / tau;
    T_o = T_o + T_o_dot * dT;
    
    T_dot = (K_s/b) * ((K_p*x_delta) + (b*x_dot) - ((1+(K_p/K_s)) * T) + T_o);
    T = T + T_dot * dT;
    
    T_plot = [T_plot; T];
end

figure();
plot(T_plot(:,1));
title('muscle response @ 80Hz extra pulse');
xlabel('time (ms)');
ylabel('measured force (N)');
axis square
grid on
hold on
