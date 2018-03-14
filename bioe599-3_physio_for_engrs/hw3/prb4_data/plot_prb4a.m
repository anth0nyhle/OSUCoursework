close all;
clear;

load('hw3_prb4a.mat');

figure(1);
plot(HillMuscle4a(:, 1), HillMuscle4a(:, 4));
title('Musculotendon Force over Time for an Isometric Condition of 0.25 Strain');
xlabel('Time (s)');
ylabel('Musculotendon Force (N)')
ylim([0 110]);
hold off;