close all;
clear;

load('hw3_prb4b.mat');
load('hw3_prb4c.mat');

figure(1);
plot(HillMuscle4b1(:, 1), HillMuscle4b1(:, 4));
hold on;
plot(HillMuscle4c1(:, 1), HillMuscle4c1(:, 4));
plot(HillMuscle4c2(:, 1), HillMuscle4c2(:, 4));
plot(HillMuscle4c3(:, 1), HillMuscle4c3(:, 4));
plot(HillMuscle4c4(:, 1), HillMuscle4c4(:, 4));
title('Musculotendon Force over Time for Different Isokinetic Conditions');
xlabel('Time (s)');
ylabel('Musculotendon Force (N)');
legend('Condition 1 from part b(1)', 'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4')
% ylim([0 120]);
xlim([0 1.4]);
hold off;