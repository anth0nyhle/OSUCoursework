% Created by: Anthony H. Le
% Last updated: 02-05-2019

% CHE 581: Assignment 3
% Textbook Problems 4.2, 4.4, 4.11, 19.2, 19.12, 19.16
% Due: 02-08-2019
 %% Problem 4.2
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 4.2');

% (a)
disp('(a)')
bin_a = bin2dec('1011001');
disp(bin_a);

% (b)
disp('(b)')
bin_b1 = bin2dec('0');
bin_b2 = (1 * 2^(-2)) + (1 * 2^(-4)) + (1 * 2^(-5));
disp(bin_b1 + bin_b2);

% (c)
disp('(c)')
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

for i = 1:100 % overkill, only need ~60 iterations
    if 1 + e <= 1 % Step 2, 4
        e = 2 * e; % Step 5
    else
        e = e / 2; % Step 3
    end
end

disp(e);
disp(eps(1));

% e == eps(1); % logic check from my eps vs eps from built-in function
    
disp('-------------------------------------------------');

%% Problem 4.11
close all;
clear;
clc;

disp('Problem 4.11');
x = pi / 3; % set x
err_crtn = 5.00; % set error criterion

[cos_val, cos_err] = eval_cos(x, err_crtn);

cos_table = [cos_val, cos_err];

fprintf(' cos(x)          error\n');
fprintf('%5f %20.2f\n', cos_table');

disp('-------------------------------------------------');
