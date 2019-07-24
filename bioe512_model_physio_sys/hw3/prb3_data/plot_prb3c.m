close all;
clear;

load('hw3_prb3c.mat');

figure(1);
plot(DMMuscle3c1(:, 1), DMMuscle3c1(:, 4));
hold on;
plot(DMMuscle3c2(:, 1), DMMuscle3c2(:, 4));
plot(DMMuscle3c3(:, 1), DMMuscle3c3(:, 4));
title('Musculotendon Force over Time for Different Isometric Conditions');
xlabel('Time (s)');
ylabel('Musculotendon Force (N)');
legend('Double f1', 'Double g1, g2, g3', 'Double f1, g1, g2, g3');
ylim([0 120]);
hold off;