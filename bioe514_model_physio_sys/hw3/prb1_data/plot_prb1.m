close all;
clear;

load('strengthduration.mat');

figure(1);
plot(strengthduration(:, 1), strengthduration(:, 2), '-o');
hold on;
xlabel('Pulse Duration (ms)');
ylabel('Current (nA)');
title('Strength-Duration Curve');
ax = gca;
ax.XTick = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]; 