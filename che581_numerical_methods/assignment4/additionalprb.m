% Created by: Anthony H. Le
% Last updated: 02-25-2019

% CHE 581: Assignment 4
% Textbook Problems 21.13, 21.28, Additional Problem
% Due: 02-18-2019
%% Additional Problem
close all;
clear;
clc;

disp('Additional Problem (see handout)');

% provided function
f = @(xx) sin(50 .* xx) .* xx.^2 + (50 .* xx);

% (a)
disp('(a) See Figure 1');
n_a = 100; % number of steps
x_a = linspace(0, 1, n_a); % original interval
[xx_aff, ffdm_a] = for_diff2(f, n_a, x_a); % calls forward diff function, 2nd-order accurate
[xx_acf, cfdm_a] = cen_diff2(f, n_a, x_a); % calls centered diff function, 2nd-order accurate
[xx_abf, bfdm_a] = back_diff2(f, n_a, x_a); % calls backward diff function, 2nd-order accurate

% plot all diff approx methods of function
figure();
plot(xx_aff, ffdm_a, '-o');
hold on;
plot(xx_acf, cfdm_a, '-o');
plot(xx_abf, bfdm_a, '-o');
title('(a) f''(xx) using 2nd-order Diff Approx Methods, n = 100');
legend('forward diff', 'centered diff', 'backward diff', 'Location', 'northwest');
xlabel('\bf{xx}');
ylabel('\bf{f''(xx)}');
hold off;

% (b)
disp('(b) See Figure 2');
g = @(xx) 50 * cos(50 .* xx) .* xx.^2 + 2 * sin(50 .* xx) .* xx + 50; % derivative of f(x)
tru_derv_bff = g(xx_aff);
tru_derv_bcf = g(xx_acf);
tru_derv_bbf = g(xx_abf);


% compute true percent relative error for each diff approx method
et_ffdm = (abs(tru_derv_bff - ffdm_a) ./ tru_derv_bff) * 100;
et_cfdm = (abs(tru_derv_bcf - cfdm_a) ./ tru_derv_bcf) * 100;
et_bfdm = (abs(tru_derv_bbf - bfdm_a) ./ tru_derv_bbf) * 100;

figure();
% plot all diff approx methods w/ true derivative
subplot(1, 2, 1);
plot(xx_aff, ffdm_a, '-o');
hold on;
plot(xx_acf, cfdm_a, '-o');
plot(xx_abf, bfdm_a, '-o');
plot(x_a, g(x_a));
title('(b) f''(xx) using 2nd-order Accurate Diff Approx Methods, n = 100');
legend('forward diff', 'centered diff', 'backward diff', 'true', 'Location', 'northwest');
xlabel('\bf{xx}');
ylabel('\bf{f''(xx)}');
hold off;

% plot true percent realtive error for each diff approx method
subplot(1, 2, 2);
plot(xx_aff, et_ffdm, '-*');
hold on;
plot(xx_acf, et_cfdm, '-*');
plot(xx_abf, et_bfdm, '-*');
title('(b) True Percent Relative Errors');
legend('forward diff', 'centered diff', 'backward diff');
xlabel('\bf{xx}');
ylabel('\bf{\epsilon_{t} (%)}');
hold off;

% (c)
disp('(c) See Figure 3');
n_c = [10 20 40 100]; % array of various numbers of steps

FFDM_C = cell(length(n_c), 1); % allocate memory for faster computing

for i = 1:length(n_c) % loop thru each n value, store approx in cell array
    x_c = linspace(0, 1, n_c(i)); % original interval w/ respective number of steps
    [xx_c, ffdm_c] = for_diff2(f, n_c(i), x_c); % calls forward diff function, 2nd-order accurate
    FFDM_C{i, 1} = [xx_c, ffdm_c]; % store mat produced by function
end

% plot forward diff approx method for each n value
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

% (e)
disp('(e) See Figure 4');
n_d = 50; % number of steps
x_d = linspace(0, 1, n_d); % original interval
[xx_d1, cfdm_d1] = cen_diff2(f, n_d, x_d); % calls centered diff function, 2nd-order accurate
[xx_d2, cfdm_d2] = cen_diff4(f, n_d, x_d); % calls centered diff function, 4th-order accurate
tru_derv_d1 = g(xx_d1);
tru_derv_d2 = g(xx_d2);

% compute true relative percent error for each order accurate derivative
et_cfdm_d1 = (abs(tru_derv_d1 - cfdm_d1) ./ tru_derv_d1) * 100;
et_cfdm_d2 = (abs(tru_derv_d2 - cfdm_d2) ./ tru_derv_d2) * 100;

figure();
% plot both order accurate derivative
subplot(1, 2, 1);
plot(xx_d1, cfdm_d1, '-s');
hold on;
plot(xx_d2, cfdm_d2, '-s');
plot(x_d, g(x_d));
title('(e) f''(xx) using Centered Diff Method');
legend('O(\ith^{2})', 'O(\ith^{4})', 'true', 'Location', 'northwest');
xlabel('\bf{xx}');
ylabel('\bf{f''(xx)}');
hold off;

% plot respective true percent error for each order accurate derivative
subplot(1, 2, 2);
plot(xx_d1, et_cfdm_d1, '-x');
hold on;
plot(xx_d2, et_cfdm_d2, '-x');
title('(e) True Percent Relative Errors');
legend('O(\ith^{2})', 'O(\ith^{4})');
xlabel('\bfxx');
ylabel('\bf\epsilon_{t} (%)');
hold off;

disp('-------------------------------------------------');
