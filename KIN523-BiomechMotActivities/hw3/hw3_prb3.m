% Created by: Anthony Le
% Last updated: 02.06.2018

% KIN 523: Homework 3 - Signal Processing
% Due: 02.06.2018
%% Problem 3
close all;
clear;

load('FFT.mat');
% Freq col vector in Hz
% Amp col vector in V

Freq = abs(Freq);
Power = 2 .* abs(Amp).^2;
Power(1, 1) = Power(1, 1) / 2;

figure(1);
subplot(1, 2, 1);
bar(Freq(1:64), Amp(1:64));
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');
title('Frequency Spectrum');

subplot(1, 2, 2);
bar(Freq(1:64), Power(1:64));
xlabel('Frequency (Hz)');
ylabel('Power (V^2)');
title('Power Spectrum');