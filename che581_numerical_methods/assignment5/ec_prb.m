% Created by: Anthony H. Le
% Last updated: 03-01-2019

% CHE 581: Assignment 5
% Extra Credit Problem
% Due: 03-01-2019
%% Extra Credit
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Extra Credit Problem');
disp('See Figure 1, 2, and 3 for predictions of function for the 5 different grids');
disp('See Figure 4 for pre as a function of delta t');
disp('See Figure 5 for tpre as a function of delta t');

dydt = @(t, y) (y * t^2) - (1.1 * y);
y = @(t) exp((t.^3 / 3) - 1.1 .* t);

t_span = [0, 2];

N_INV = [40 80 160 320 640];
N_PTS = [41 81 161 321 641];
DEL_T = [2/40 2/80 2/160 2/320 2/640];

GRID = cell(1, 5);
TPRE = cell(1, 5);
EUL_PRE = [];
MIDPT_PRE = [];
RK4_PRE = [];
EUL_TPRE = [];
MIDPT_TPRE = [];
RK4_TPRE = [];

for i = 1:5
    t = linspace(0, 2, N_PTS(i))';
    y_a = y(t);
    [~, y_b] = eulode(dydt, t_span, y(0), DEL_T(i));
    [~, y_c] = midptode(dydt, t_span, y(0), DEL_T(i), [], [], []); close;
    [~, y_d] = rk4ode(dydt, t_span, y(0), DEL_T(i), [], [], []); close;
    GRID{1, i} = [t, y_a, y_b, y_c, y_d];
end

EUL_PRE(:, 1) = (abs(GRID{1, 2}(1:2:81, 3) - GRID{1, 1}(:, 3)) ./ GRID{1, 2}(1:2:81, 3)) .* 100;
EUL_PRE(:, 2) = (abs(GRID{1, 3}(1:4:161, 3) - GRID{1, 2}(1:2:81, 3)) ./ GRID{1, 3}(1:4:161, 3)) .* 100;
EUL_PRE(:, 3) = (abs(GRID{1, 4}(1:8:321, 3) - GRID{1, 3}(1:4:161, 3)) ./ GRID{1, 4}(1:8:321, 3)) .* 100;
EUL_PRE(:, 4) = (abs(GRID{1, 5}(1:16:641, 3) - GRID{1, 4}(1:8:321, 3)) ./ GRID{1, 5}(1:16:641, 3)) .* 100;

MIDPT_PRE(:, 1) = (abs(GRID{1, 2}(1:2:81, 4) - GRID{1, 1}(:, 4)) ./ GRID{1, 2}(1:2:81, 4)) .* 100;
MIDPT_PRE(:, 2) = (abs(GRID{1, 3}(1:4:161, 4) - GRID{1, 2}(1:2:81, 4)) ./ GRID{1, 3}(1:4:161, 4)) .* 100;
MIDPT_PRE(:, 3) = (abs(GRID{1, 4}(1:8:321, 4) - GRID{1, 3}(1:4:161, 4)) ./ GRID{1, 4}(1:8:321, 4)) .* 100;
MIDPT_PRE(:, 4) = (abs(GRID{1, 5}(1:16:641, 4) - GRID{1, 4}(1:8:321, 4)) ./ GRID{1, 5}(1:16:641, 4)) .* 100;

RK4_PRE(:, 1) = (abs(GRID{1, 2}(1:2:81, 5) - GRID{1, 1}(:, 5)) ./ GRID{1, 2}(1:2:81, 5)) .* 100;
RK4_PRE(:, 2) = (abs(GRID{1, 3}(1:4:161, 5) - GRID{1, 2}(1:2:81, 5)) ./ GRID{1, 3}(1:4:161, 5)) .* 100;
RK4_PRE(:, 3) = (abs(GRID{1, 4}(1:8:321, 5) - GRID{1, 3}(1:4:161, 5)) ./ GRID{1, 4}(1:8:321, 5)) .* 100;
RK4_PRE(:, 4) = (abs(GRID{1, 5}(1:16:641, 5) - GRID{1, 4}(1:8:321, 5)) ./ GRID{1, 5}(1:16:641, 5)) .* 100;

eul_avgpre = sum(EUL_PRE, 1) ./ 41;
midpt_avgpre = sum(MIDPT_PRE, 1) ./ 41;
rk4_avgpre = sum(RK4_PRE, 1) ./ 41;

EUL_TPRE(:, 1) = (abs(GRID{1, 1}(:, 2) - GRID{1, 1}(:, 3)) ./ GRID{1, 1}(:, 2)) .* 100;
EUL_TPRE(:, 2) = (abs(GRID{1, 2}(1:2:81, 2) - GRID{1, 2}(1:2:81, 3)) ./ GRID{1, 2}(1:2:81, 2)) .* 100;
EUL_TPRE(:, 3) = (abs(GRID{1, 3}(1:4:161, 2) - GRID{1, 3}(1:4:161, 3)) ./ GRID{1, 3}(1:4:161, 2)) .* 100;
EUL_TPRE(:, 4) = (abs(GRID{1, 4}(1:8:321, 2) - GRID{1, 4}(1:8:321, 3)) ./ GRID{1, 4}(1:8:321, 2)) .* 100;
EUL_TPRE(:, 5) = (abs(GRID{1, 5}(1:16:641, 2) - GRID{1, 5}(1:16:641, 3)) ./ GRID{1, 5}(1:16:641, 2)) .* 100;

MIDPT_TPRE(:, 1) = (abs(GRID{1, 1}(:, 2) - GRID{1, 1}(:, 4)) ./ GRID{1, 1}(:, 2)) .* 100;
MIDPT_TPRE(:, 2) = (abs(GRID{1, 2}(1:2:81, 2) - GRID{1, 2}(1:2:81, 4)) ./ GRID{1, 2}(1:2:81, 2)) .* 100;
MIDPT_TPRE(:, 3) = (abs(GRID{1, 3}(1:4:161, 2) - GRID{1, 3}(1:4:161, 4)) ./ GRID{1, 3}(1:4:161, 2)) .* 100;
MIDPT_TPRE(:, 4) = (abs(GRID{1, 4}(1:8:321, 2) - GRID{1, 4}(1:8:321, 4)) ./ GRID{1, 4}(1:8:321, 2)) .* 100;
MIDPT_TPRE(:, 5) = (abs(GRID{1, 5}(1:16:641, 2) - GRID{1, 5}(1:16:641, 4)) ./ GRID{1, 5}(1:16:641, 2)) .* 100;

RK4_TPRE(:, 1) = (abs(GRID{1, 1}(:, 2) - GRID{1, 1}(:, 5)) ./ GRID{1, 1}(:, 2)) .* 100;
RK4_TPRE(:, 2) = (abs(GRID{1, 2}(1:2:81, 2) - GRID{1, 2}(1:2:81, 5)) ./ GRID{1, 2}(1:2:81, 2)) .* 100;
RK4_TPRE(:, 3) = (abs(GRID{1, 3}(1:4:161, 2) - GRID{1, 3}(1:4:161, 5)) ./ GRID{1, 3}(1:4:161, 2)) .* 100;
RK4_TPRE(:, 4) = (abs(GRID{1, 4}(1:8:321, 2) - GRID{1, 4}(1:8:321, 5)) ./ GRID{1, 4}(1:8:321, 2)) .* 100;
RK4_TPRE(:, 5) = (abs(GRID{1, 5}(1:16:641, 2) - GRID{1, 5}(1:16:641, 5)) ./ GRID{1, 5}(1:16:641, 2)) .* 100;

eul_avgtpre = sum(EUL_TPRE, 1) ./ 41;
midpt_avgtpre = sum(MIDPT_TPRE, 1) ./ 41;
rk4_avgtpre = sum(RK4_TPRE, 1) ./ 41;

figure();
plot(GRID{1, 1}(:, 1), GRID{1, 1}(:, 3));
title('Euler''s Method')
xlabel('t');
ylabel('y');
hold on;
plot(GRID{1, 2}(:, 1), GRID{1, 2}(:, 3));
plot(GRID{1, 3}(:, 1), GRID{1, 3}(:, 3));
plot(GRID{1, 4}(:, 1), GRID{1, 4}(:, 3));
plot(GRID{1, 5}(:, 1), GRID{1, 5}(:, 3));
legend('grid 1', 'grid 2', 'grid 3', 'grid 4', 'grid 5');
hold off;

figure();
plot(GRID{1, 1}(:, 1), GRID{1, 1}(:, 4));
title('Midpoint Method')
xlabel('t');
ylabel('y');
hold on;
plot(GRID{1, 2}(:, 1), GRID{1, 2}(:, 4));
plot(GRID{1, 3}(:, 1), GRID{1, 3}(:, 4));
plot(GRID{1, 4}(:, 1), GRID{1, 4}(:, 4));
plot(GRID{1, 5}(:, 1), GRID{1, 5}(:, 4));
legend('grid 1', 'grid 2', 'grid 3', 'grid 4', 'grid 5');
hold off;

figure();
plot(GRID{1, 1}(:, 1), GRID{1, 1}(:, 5));
title('RK4 Method')
xlabel('t');
ylabel('y');
hold on;
plot(GRID{1, 2}(:, 1), GRID{1, 2}(:, 5));
plot(GRID{1, 3}(:, 1), GRID{1, 3}(:, 5));
plot(GRID{1, 4}(:, 1), GRID{1, 4}(:, 5));
plot(GRID{1, 5}(:, 1), GRID{1, 5}(:, 5));
legend('grid 1', 'grid 2', 'grid 3', 'grid 4', 'grid 5');
hold off;

figure();
plot(DEL_T(2:5), eul_avgpre, 'o');
title('Average Percent Relative Error');
xlabel('\Delta t')
ylabel('\epsilon_{a, ave}');
hold on;
plot(DEL_T(2:5), midpt_avgpre, 'o');
plot(DEL_T(2:5), rk4_avgpre, 'o');
legend('Euler''s Method', 'Midpoint Method', 'RK4 Method');
hold off;

figure();
plot(DEL_T, eul_avgtpre, 'o');
title('Average True Percent Relative Error');
xlabel('\Delta t')
ylabel('\epsilon_{t, ave}');
hold on;
plot(DEL_T, midpt_avgtpre, 'o');
plot(DEL_T, rk4_avgtpre, 'o');
legend('Euler''s Method', 'Midpoint Method', 'RK4 Method');
hold off;

disp('-------------------------------------------------');
