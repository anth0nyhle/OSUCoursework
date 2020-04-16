% Created by: Anthony Le
% Last updated: 02.06.2018

% KIN 523: Homework 3 - Signal Processing
% Due: 02.06.2018
%% Problem 4b and 4c
close all;
clear;

% part b
load('Residuals.mat');
% Freq_Resid col vector in Hz
% Resid col vector in mm

% x = Freq_Resid(4:6);
% y = Resid(4:6);
% 
% p = polyfit(x, y, 1);
% fit = polyval(p, x);

x = linspace(0, 36, 37);

% linear regression
[r, m, b] = regression(Freq_Resid(27:35), Resid(27:35), 'one');
y = x .* m + b;
y2 = repmat(0.229, 37, 2);

% plot residual analysis and linear regression fit
figure(1);
subplot(1, 2, 1);
plot(Freq_Resid, Resid);
title('Residual Analysis');
xlabel('Frequency (Hz)');
ylabel('Residual (mm)');

subplot(1, 2, 2);
plot(Freq_Resid, Resid, '-o');
hold on;
title('Residual Analysis');
xlabel('Frequency (Hz)');
ylabel('Residual (mm)');
plot(x, y);
plot(x, y2);
axis([0 35 0 2])

% part c
load('FilterData.mat');
% Time col vector in s
% LANK col vector in m
% LTOE col vector in m

f_c = 18; % in Hz; cut-off freq
f_s = 120; % in frames/s; sampling freq
T = 1 / f_s; % in s per frame; sampling period

Omega_C = tan(pi * (f_c / f_s)) / 0.802;

a_0 = (Omega_C^2) / (1 + sqrt(2) * Omega_C + Omega_C^2);
a_1 = 2 * a_0;
a_2 = a_0;

b_1 = (2 * (1 - Omega_C^2)) / (1 + sqrt(2) * Omega_C + Omega_C^2);
b_2 = 1 - (a_0 + a_1 + a_2 + b_1);

X_kT_Ank = LANK;
X_kT_Ank_back = flipud(X_kT_Ank);
Y1_kT_Ank = [0.091051; 0.091039];

for i = 3:289
    y1_kT_ank = a_0 * X_kT_Ank(i) + a_1 * X_kT_Ank(i-1) + a_2 * X_kT_Ank(i-2) + b_1 * Y1_kT_Ank(i-1) + b_2 * Y1_kT_Ank(i-2);
    Y1_kT_Ank = cat(1, Y1_kT_Ank, y1_kT_ank);
end

Y1_kT_Ank_back = flipud(Y1_kT_Ank);
Y2_kT_Ank = [Y1_kT_Ank_back(1, 1); Y1_kT_Ank_back(2, 1)];

for j = 3:289
    y2_kT_ank = a_0 * Y1_kT_Ank_back(j) + a_1 * Y1_kT_Ank_back(j-1) + a_2 * Y1_kT_Ank_back(j-2) + b_1 * Y2_kT_Ank(j-1) + b_2 * Y2_kT_Ank(j-2);
    Y2_kT_Ank = cat(1, Y2_kT_Ank, y2_kT_ank);
end

Y2_kT_Ank = flipud(Y2_kT_Ank);

N = 289;

R_f_c_Ank = sqrt((1 / N) * sum((X_kT_Ank - Y2_kT_Ank).^2));

figure(2);
plot(Time, X_kT_Ank);
hold on;
% plot(Time, Y1_kT_Ank);
plot(Time, Y2_kT_Ank);
axis([0 2.4 0 0.5])
legend('Measured', 'Filtered')
% legend('Measured', 'Filtered foward', 'Filtered forward then back');
xlabel('Time (s)');
ylabel('Ankle Marker Position (height in Y, m)');
title('LANK data low-pass filtered using a 4th-order, no-lag Butterworth filter w/ a cut-off frequency, 18Hz');
hold off;

figure(3);
plot(Time, X_kT_Ank);
hold on;
% plot(Time, Y1_kT_Ank);
plot(Time, Y2_kT_Ank);
axis([0.3 0.8 0.0825 0.087])
legend('Measured', 'Filtered')
% legend('Measured', 'Filtered foward', 'Filtered forward then back');
xlabel('Time (s)');
ylabel('Ankle Marker Position (height in Y, m)');
title('LANK data low-pass filtered using a 4th-order, no-lag Butterworth filter w/ a cut-off frequency, 18Hz');
hold off;

figure(4);
plot(Time, X_kT_Ank);
hold on;
% plot(Time, Y1_kT_Ank);
plot(Time, Y2_kT_Ank);
axis([1.5 1.75 0.07 0.19])
legend('Measured', 'Filtered')
% legend('Measured', 'Filtered foward', 'Filtered forward then back');
xlabel('Time (s)');
ylabel('Ankle Marker Position (height in Y, m)');
title('LANK data low-pass filtered using a 4th-order, no-lag Butterworth filter w/ a cut-off frequency, 18Hz');
hold off;