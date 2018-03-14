close all;
clear;

load('hw3_prb3a.mat');

figure(1);
plot(DMMuscle15(:, 1), DMMuscle15(:, 4));
hold on;
plot(DMMuscle11(:, 1), DMMuscle11(:, 4));
plot(DMMuscle19(:, 1), DMMuscle19(:, 4));
title('Musculotendon Force over Time for Different Isometric Conditions');
xlabel('Time (s)');
ylabel('Musculotendon Force (N)');
legend('0.15m', '0.11m', '0.19m');
ylim([0 110]);
hold off;