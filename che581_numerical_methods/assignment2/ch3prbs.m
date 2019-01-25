% Created by: Anthony H. Le
% Last updated: 01-25-2019

% CHE 581: Assignment 2
% Textbook Problems 3.1, 3.2, 3.5, 3.9, 3.12, 3.13, 5.1, 5.7, 5.13
% Due: 02-01-2019
%% Problem 3.1
close all;
clear;
clc;

R = [0.9 1.5 1.3 1.3];
d = [1 1.25 3.8 4.0];

for i = 1:length(R)
    if d(i) > (3 * R(i))
        disp('Overtop!');
    else
        fprintf('All good; tank volume is %8.4f!\n', calc_vol(R(i), d(i)));
    end
end

disp('-------------------------------------------------');

%% Problem 3.2
close all;
clear;
clc;

