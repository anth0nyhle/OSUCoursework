% Created by: Anthony H. Le
% Last updated: 01-21-2019

% CHE 581: Assignment 1
% Textbook (4th Edition) Problems 2.1-2.7, 2.17, 2.18
% Due: 01-23-2019
%% Problem 2.1
close all; % close all figures
clear; % clear workspace
clc; % clear command window

disp('Problem 2.1');
% output mat A w/ size 3 by 3
A = [1:3; 2:2:6; 3:-1:1];
disp(A);

% transpose mat A
A = A';
disp(A);

% print all rows, col 3 of mat A
A(:, 3) = [];
disp(A);

% same col 1
% replace col 2 w/ vec [4 5 7] transposed
% same col 3
A = [A(:, 1) [4 5 7]' A(:, 2)];
disp(A);

% sum numbers along diagonal of mat A
A = sum(diag(A));
disp(A);

disp('-------------------------------------------------');

%% Problem 2.2
close all;
clear;
clc;

disp('Problem 2.2');
t = rand(5, 1); % vec of random numbers, 5 by 1

% (a)
disp('(a)');
% exp; output vec y1, same length as t
y1 = ((6 * t.^3) - (3 * t) - 4) ./ (8 * sin(5 * t));
disp(y1);

% (b)
disp('(b)');
% exp; output vec y2, same legnth as t
y2 = (((6 * t) - 4) ./ (8 * t)) - ((pi / 2) * t);
disp(y2);

disp('-------------------------------------------------');

%% Problem 2.3
close all;
clear;
clc;

disp('Problem 2.3');
y = rand(5, 1); % vec of random numbers, 5 by 1
z = rand(5, 1); % vec of random numbers, 5 by 1
a = 3; % arbitrary scalar
b = 8; % arbitrary scalar

% exp; output vec x, same length as y and z
x = (y .* ((a + (b * z)).^1.8)) ./ (z .* (1 - y)); % eqn
disp(x); % col vec

disp('-------------------------------------------------');

%% Problem 2.4
close all;
clear;
clc;

disp('Problem 2.4');
% (a)
disp('(a)');
A = [1 2; 3 4; 5 6]; % mat A, 3 by 2
disp(A(2, :)'); % display all values in row 2 of mat A
% transposed as col vec

% (b)
disp('(b)');
y = (0:1.5:7)'; % transposed
disp(y); % display col vec, int 0<=x<=7, inc 1.5

% (c)
disp('(c)');
a = 2; b = 8; c = 4;
disp(a + b / c); % display calculation result, single value

disp('-------------------------------------------------');

%% Problem 2.5
close all;
clear;
clc;

disp('Problem 2.5');
x = (0:1/256:2); % int 0<=x<=2, inc 1/256
f_x = (1 ./ ((x - 0.3).^2 + 0.01)) + (1 ./ ((x - 0.9).^2 + 0.04)) - 6; % f(x)

figure();
% plot x verse f(x) w/ plot function
plot(x, f_x);
hold on;
title('Two Maxima of Unequal Height');
xlabel('\it{x}, \rm{unitless}');
ylabel('\it{f(x)}, \rm{unitless}');

disp('-------------------------------------------------');

%% Problem 2.6
close all;
clear;
clc;

disp('Problem 2.6');
disp('(a)');
t1 = (4:6:35); disp(t1); % col operator, int 4<=t<=35, inc 6
t2 = linspace(4, 34, 6); disp(t2); % linspace function

disp('(b)');
x1 = (-4:2); disp(x1); % col operator, int -4<=x<=2, inc 1
x2 = linspace(-4, 2, 7); disp(x2); % linspace function

disp('-------------------------------------------------');

%% Problem 2.7
close all;
clear;
clc;

disp('Problem 2.7');
disp('(a)');
v1 = linspace(-2, 1.5, 8); disp(v1); % linspace function
v2 = (-2:0.5:1.5); disp(v2); % col operator, int -2<=v<=1.5, inc 0.5

disp('(b)');
r1 = linspace(8, 4.5, 8); disp(r1); % linspace function
r2 = (8:-0.5:4.5); disp(r2); % col operator, int 8<=r<=4.5, inc -0.5

disp('-------------------------------------------------');
