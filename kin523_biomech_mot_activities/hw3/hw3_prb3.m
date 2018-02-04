% Created by: Anthony Le
% Last updated: 02.04.2018

% KIN 523: Homework 3 - Signal Processing
% Due: 02.06.2018
%% Problem 3
close all;
clear;

load('FFT.mat');
% Freq col vector in Hz
% Amp col vector in V

time = linspace(0, 0.533, 128);

bar(Freq, Amp);