close all;
clear;

load('ForceControl.mat');

figure(1);
plot(ForceControl5a1(:, 1), ForceControl5a1(:, 2)./1.0);
hold on;
plot(ForceControl5a2(:, 1), ForceControl5a2(:, 2)./2.6);
legend('Type I Motor Unit (1)', 'Type II Motor Unit (2)')
xlabel('Time (s)');
ylabel('Normalized Force (N/motor unit max N)');
hold off;

figure(2);
plot(ForceControl5a3(:, 1), ForceControl5a3(:, 2));
hold on;
plot(ForceControl5a4(:, 1), ForceControl5a4(:, 2));
plot(ForceControl5a5(:, 1), ForceControl5a5(:, 2));
plot(ForceControl5a6(:, 1), ForceControl5a6(:, 2));
legend('2 Type I Motor Units (3)', 'Normal Pattern (4)', 'Ballistic Activation (5)', 'Asynchrony = 0 (6)');
xlabel('Time (s)');
ylabel('Force (N)');
hold off;