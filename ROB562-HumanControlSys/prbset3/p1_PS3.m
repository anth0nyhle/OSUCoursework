% Created by: Anthony Le
% Last updated: 05-19-2017
% ROB 562: Human Control Systems

% Problem Set 3
%% Problem 1
clear;
close all;

b = 0.2;
K_s = 3;
K_p = 2;
T(1) = 1;

x_delta = 0;
x_dot = 0;

dT = 0.001;

T_o = 0;
T = 0;
T_plot = [];

for t = dT:dT:1
    if t > 0.005 && t < 0.01
        T_o = 17.2;
    else
        T_o = 0;
    end

    T_dot = (K_s/b) * ((K_p*x_delta) + (b*x_dot) - ((1+(K_p/K_s)) * T) + T_o);
    T = T + T_dot * dT;
    
    T_plot = [T_plot; T];
end

figure();
plot(T_plot(:,1));
title('twitch response');
xlabel('time (ms)');
ylabel('measured force (N)');
axis square
grid on
hold on