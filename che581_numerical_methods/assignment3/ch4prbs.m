% Created by: Anthony H. Le
% Last updated: 02-11-2019

% CHE 581: Assignment 3
% Textbook Problems 4.2, 4.4, 4.11, 19.2, 19.12, 19.16
% Due: 02-11-2019
%% Problem 4.2
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 4.2');
% (a)
disp('(a)')
% bin_a = (1 * 2^(6)) + (0 * 2^(5)) + (1 * 2^(4)) + (1 * 2^(3)) + (0 * 2^(2)) + (0 * 2^(1)) + (1 * 2^(0));
bin_a = bin2dec('1011001');
disp(bin_a);

% (b)
disp('(b)')
% bin_b = (0 * 2^(0)) + (0 * 2^(-1)) + (1 * 2^(-2)) + (0 * 2^(-3)) + (1 * 2^(-4)) + (1 * 2^(-5))
bin_b1 = bin2dec('0');
bin_b2 = (1 * 2^(-2)) + (1 * 2^(-4)) + (1 * 2^(-5));
disp(bin_b1 + bin_b2);

% (c)
disp('(c)')
% bin_c = (1 * 2^(2)) + (1 * 2^(1)) + (0 * 2^(0)) + (0 * 2^(-1)) + (1 * 2^(-2)) + (0 * 2^(-3)) + (0 * 2^(-4)) + (1 * 2^(-5))
bin_c1 = bin2dec('110');
bin_c2 = (1 * 2^(-2)) + (1 * 2^(-5));
disp(bin_c1 + bin_c2);

disp('-------------------------------------------------');

%% Problem 4.4
close all;
clear;
clc;

disp('Problem 4.4');
e = 1; % set epsilon to 1

while (1 + e) > 1 % Step 2, 4
    e = e / 2; % Step 3
end

disp(e * 2); % Step 5
disp(eps(1));

% e == eps(1); % logical check from my eps vs eps from built-in function
    
disp('-------------------------------------------------');

%% Problem 4.11
close all;
clear;
clc;

disp('Problem 4.11');
x = pi / 3; % set x
err_crtn = 0.01; % percent, set error criterion

[iter, cos_val, cos_err] = eval_cos(x, err_crtn); % function call eval_cos.m

cos_table = [iter, cos_val, cos_err]; % concat col vecs

fprintf('iter   cos(x)     apprx err  true err\n'); % print headers
fprintf('%2d    %5f    %8.4f   %8.4f\n', cos_table'); % print iterative values

disp('-------------------------------------------------');
