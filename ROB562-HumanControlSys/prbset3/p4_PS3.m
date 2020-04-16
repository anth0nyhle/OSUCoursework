% Created by: Anthony Le
% Last updated: 05-19-2017
% ROB 562: Human Control Systems

% Problem Set 3
%% Problem 4a
clear;
close all;

T_plot = [];

L = linspace(2, 6);
L_o = 4;

K_s = 3;
xp_max_d = 0.5.*L_o;
xp_d = L - L_o;
alpha = [0, 0.5, 1];

T_max = 0.1;

T_a = -(T_max/L_o) .* (L - L_o).^2 + T_max;
T_p = 0*L;

for i = 1:1:3
    alpha_T_a = alpha(i) .* T_a;
    for j = 1:size(L, 2)
        if L(j) < L_o
            T_p(j) = 0;
        elseif L(j) >= L_o
            T_p(j) = (T_max/(exp(K_s)-1)) .* (exp(K_s.*(xp_d(j)/xp_max_d))-1);
        end
    end
    
    T = alpha_T_a + T_p;
    
    T_plot = [T_plot; T];
end

plot(L, T_plot);
hold on

xlabel('length')
ylabel('force')
legend('alpha = 0', 'alpha = 0.5', 'alpha = 1')

%% Problem 4b
clear;
close all;

%Initialize constants
L = linspace(2, 6);
T_max = 7;
L_o = 4; 
alpha = 1;

K_s = 3;
xp_max_d = 0.5.*L_o;
xp_d = L - L_o;

%Initialize tensions
T_a = -(T_max/L_o) .* (L - L_o).^2 + T_max;
T_p = 0*L;

%Solve for passive tension
for i = 1:size(L, 2) 
    if L(i) < L_o
        T_p(i) = 0;
    elseif L(i) >= L_o
        T_p(i) = (T_max/(exp(K_s)-1)).*(exp(K_s.*(xp_d(i)/xp_max_d))-1);
    end
end
    
T = (alpha*T_a) + T_p; 
fx = gradient(T,0.1);

%Plot Force vs Length and change of local slope at each L
plot(L,T);
title('alpha = 0.5');
xlabel('length');
ylabel('force');
grid on;
hold on;
plot(L,fx);