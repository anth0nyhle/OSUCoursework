% Created by: Anthony Le
% Last updated: 02.26.2018

% BIOE 599-3: Homework 2
% Due: 03.02.2018
%% Problem 7
close all;
clear;

% part a
[tai, dYai] = ode45(@Fai_ode, [0 20], [220; 0]);
[taii, dYaii] = ode45(@Faii_ode, [0 2], [220; 0]);
[taiii, dYaiii] = ode45(@Faiii_ode, [0 0.2], [220; 0]);

figure(1);
plot(dYai(:, 1), dYai(:, 2));
hold on;
plot(dYaii(:, 1), dYaii(:, 2));
plot(dYaiii(:, 1), dYaiii(:, 2));

% part b
[tb, dYb] = ode45(@Fb_ode, [0 60], [220; 0]);

figure(2);
plot(dYb(:, 1), dYb(:, 2));

% part c
[tc, dYc] = ode45(@Fc_ode, [0 200], [220; 0]);

figure(3);
plot(tc, dYc(:, 2));

% part d
[td, dYd] = ode45(@ld_ode, [0 200], [0; 220]);

figure(4);
plot(td, dYd(:, 2));