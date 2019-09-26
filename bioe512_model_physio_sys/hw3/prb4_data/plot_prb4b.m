close all;
clear;

load('hw3_prb4b.mat');

figure(1);
plot(HillMuscle4b1(:, 1), HillMuscle4b1(:, 4));
hold on;
plot(HillMuscle4b2(:, 1), HillMuscle4b2(:, 4));
title('Musculotendon Force over Time for Different Isokinetic Conditions');
xlabel('Time (s)');
ylabel('Musculotendon Force (N)');
legend('Shortening', 'Lengthening')
ylim([0 120]);
hold off;