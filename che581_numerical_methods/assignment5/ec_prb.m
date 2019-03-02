% Created by: Anthony H. Le
% Last updated: 03-01-2019

% CHE 581: Assignment 5
% Extra Credit Problem
% Due: 03-01-2019
%% Extra Credit
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Extra Credit Problem');
disp('See Figure 1 & 2');

dydt = @(t, y) (y * t^2) - (1.1 * y);
y = @(t) exp((t.^3 / 3) - 1.1 .* t);

% (a) analytically
a = (0:0.001:1);
y_a = y(a);

% (b) Euler's method w/ h = 0.5, 0.25
% for h = 0.5
h_b1 = 0.5;
inv_b1 = (0:h_b1:1);
[t_b1, y_b1] = eulode(dydt, [0, 1], y(0), h_b1);

% for h = 0.25
h_b2 = 0.25;
inv_b2 = (0:h_b2:1);
[t_b2, y_b2] = eulode(dydt, [0, 1], y(0), h_b2);

% (c) midpoint method w/ h = 0.5
h_c = 0.5;
inv_c = (0:h_c:1);
[t_c, y_c] = midptode(dydt, [0, 1], y(0), h_c, [], [], []);
close;

% (d) 4th-order RK method w/ h = 0.5
h_d = 0.5;
inv_d = (0:h_d:1);
[t_d, y_d] = rk4ode(dydt, [0, 1], y(0), h_d, [], [], []);
close;

% plot results of all methods
figure();
plot(a, y_a);
title('22.1 IVP for t = 0 to 1, where y(0) = 1');
xlabel('t');
ylabel('y');
hold on;
plot(t_b1, y_b1, '-o');
plot(t_b2, y_b2, '-o');
plot(t_c, y_c, '-o');
plot(t_d, y_d, '-o');
legend('(a) analytically', '(b) Euler''s method, h = 0.5', '(b) Euler''s method, h = 0.25', '(c) midpoint method, h = 0.5', '(d) 4th-order RK method, h = 0.5');
hold off;

%%
N_INV = [40 80 160 320 640];
N_PTS = [41 80 161 321 641];
DEL_T = [2/40 2/80 2/160 2/320 2/640];

GRID = cell(1, 5);

for i = 1:5
    
end    

disp('-------------------------------------------------');
