% Created by: Anthony H. Le
% Last updated: 02-17-2019

% CHE 581: Assignment 4
% Textbook Problems 21.13, 21.28, Additional Problem
% Due: 02-18-2019
%% Additional Problem
close all;
clear;
clc;

disp('Additional Problem (see handout)');

f = @(xx) sin(50 .* xx) .* xx.^2;

% (a)
disp('(a) See Figure');
n_a = 100;
x_a = linspace(0, 1, n_a);
[xx_a, ffdm_a] = for_diff2(f, n_a, x_a);
[~, cfdm_a] = cen_diff2(f, n_a, x_a);
[~, bfdm_a] = back_diff2(f, n_a, x_a);

figure();
plot(xx_a, ffdm_a, '-o');
hold on;
plot(xx_a, cfdm_a, '-o');
plot(xx_a, bfdm_a, '-o');
title('(a) f''(xx) using 2nd-order Diff Approx Methods, n = 100');
legend('forward diff', 'centered diff', 'backward diff', 'Location', 'northwest');
xlabel('\bf{xx}');
ylabel('\bf{f''(xx)}');
hold off;

% (b)
disp('(b) See figure');
g = @(xx) 50 * cos(50 .* xx) .* xx.^2 + 2 * sin(50 .* xx) .* xx;
tru_derv_b = g(xx_a);

et_ffdm = (abs(tru_derv_b - ffdm_a) ./ tru_derv_b) * 100;
et_cfdm = (abs(tru_derv_b - cfdm_a) ./ tru_derv_b) * 100;
et_bfdm = (abs(tru_derv_b - bfdm_a) ./ tru_derv_b) * 100;

figure();
subplot(1, 2, 1);
plot(xx_a, ffdm_a, '-o');
hold on;
plot(xx_a, cfdm_a, '-o');
plot(xx_a, bfdm_a, '-o');
plot(x_a, g(x_a));
title('(b) f''(xx) using 2nd-order Accurate Diff Approx Methods, n = 100');
legend('forward diff', 'centered diff', 'backward diff', 'true', 'Location', 'northwest');
xlabel('\bf{xx}');
ylabel('\bf{f''(xx)}');
hold off;

subplot(1, 2, 2);
plot(xx_a, et_ffdm, '-*');
hold on;
plot(xx_a, et_cfdm, '-*');
plot(xx_a, et_bfdm, '-*');
title('(b) True Percent Relative Errors');
legend('forward diff', 'centered diff', 'backward diff');
xlabel('\bf{xx}');
ylabel('\bf{\epsilon_{t} (%)}');
hold off;

% (c)
disp('(c) See figure');
n_c = [10 20 40 100];

FFDM_C = cell(length(n_c), 1);

for i = 1:length(n_c)
    x_c = linspace(0, 1, n_c(i));
    [xx_c, ffdm_c] = for_diff2(f, n_c(i), x_c);
    FFDM_C{i, 1} = [xx_c, ffdm_c];
end

figure();
plot(FFDM_C{1, 1}(:, 1), FFDM_C{1, 1}(:, 2), '-d');
hold on;
plot(FFDM_C{2, 1}(:, 1), FFDM_C{2, 1}(:, 2), '-d');
plot(FFDM_C{3, 1}(:, 1), FFDM_C{3, 1}(:, 2), '-d');
plot(FFDM_C{4, 1}(:, 1), FFDM_C{4, 1}(:, 2), '-d');
plot(x_a, g(x_a));
title('(c) f''(xx) using 2nd-order Accurate Forward Diff Method');
legend('n = 10', 'n = 20', 'n = 40', 'n = 100', 'true', 'Location', 'northwest');
xlabel('\bf{xx}');
ylabel('\bf{f''(xx)}');
hold off;

% (d)
disp('(d) See figure');
n_d = 50;
x_d = linspace(0, 1, n_d);
[xx_d, cfdm_d1] = cen_diff2(f, n_d, x_d);
[~, cfdm_d2] = cen_diff4(f, n_d, x_d);
tru_derv_d = g(xx_d);

et_cfdm_d1 = (abs(tru_derv_d - cfdm_d1) ./ tru_derv_d) * 100;
et_cfdm_d2 = (abs(tru_derv_d - cfdm_d2) ./ tru_derv_d) * 100;

figure();
subplot(1, 2, 1);
plot(xx_d, cfdm_d1, '-s');
hold on;
plot(xx_d, cfdm_d2, '-s');
plot(x_d, g(x_d));
title('(d) f''(xx) using Centered Diff Method');
legend('O(\it{h^{2}})', 'O(\it{h^{4}})', 'true', 'Location', 'northwest');
xlabel('\bf{xx}');
ylabel('\bf{f''(xx)}');
hold off;

subplot(1, 2, 2);
plot(xx_d, et_cfdm_d1, '-x');
hold on;
plot(xx_d, et_cfdm_d2, '-x');
title('(d) True Percent Relative Errors');
legend('O(h^{2})', 'O(h^{4})');
xlabel('\bf{xx}');
ylabel('\bf{\epsilon_{t} (%)}');
hold off;

disp('-------------------------------------------------');
