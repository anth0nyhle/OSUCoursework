% Created by: Anthony Le
% Last updated: 02.28.2018

% BIOE 599-3: Homework 2
% Due: 03.02.2018
%% Problem 4
close all;
clear;

% part c
% protocol 1
E_1 = (.005 * 0.5);
S_1 = log10(1 + 12) * E_1;

% protocol 2
E_2 = (0.005 * 0.5);
S_2 = log10(1 + 24) * E_2;

% protocol 3
E_31 = (0.005 * 0.5);
E_32 = (0.005 * 0.5);
S_3 = (log10(1 + 12) * E_31) + (log10(1 + 12) * E_32);

% protocol 4
E_4 = (0.005 * 1);
S_4 = log10(1 + 12) * E_4;

% protocol 5
E_5 = (0.01 * 0.5);
S_5 = log10(1 + 12) * E_5;

% protocol 6
E_6 = (0.01 * 1);
S_6 = log10(1 + 6) * E_6;

% protocol 7
E_71 = (0.003 * 0.5) + (0.00009 * 20);
E_72 = (0.005 * 0.5);
S_7 = (log10(1 + 6) * E_71) + (log10(1 + 12) * E_72);