close all;
clear;

load('refractory.mat');

figure(1);
plot(refractory(:, 1), refractory(:, 2)./10, '-o');
hold on;
xlabel('Delay (ms)');
ylabel('Threshold Current (Stim2 nA/Stim1 nA)');
title('Strength-Duration Curve');