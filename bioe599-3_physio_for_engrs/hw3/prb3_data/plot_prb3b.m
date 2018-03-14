close all;
clear;

load('hw3_prb3b.mat');

figure(1);
plot(DMMuscle3b1(:, 1), DMMuscle3b1(:, 4));
hold on;
plot(DMMuscle3b2(:, 1), DMMuscle3b2(:, 4));
plot(DMMuscle3b3(:, 1), DMMuscle3b3(:, 4));
title('Musculotendon Force over Time for Different Isokinetic Conditions');
xlabel('Time (s)');
ylabel('Musculotendon Force (N)');
legend('Condition 1', 'Condition 2', 'Condition 3');
ylim([0 120]);
hold off;