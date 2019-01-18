% Created by: Anthony H. Le
% Last updated: 01-17-2019

% CHE 581: Assignment 1
% Textbook problems 2.1-2.7, 2.17, 2.18
% Due: 01-23-2019
%%
close all;
clear;

%% Problem 2.1
disp('Problem 2.1');
% output mat A w/ size 3x3
A = [1:3; 2:2:6; 3:-1:1];
disp(A);

% transpose mat A
A = A';
disp(A);

% print all rows, col 3 of mat A
A(:, 3) = [];
disp(A);

% same col 1
% replace col 2 w/ vec [4 5 7]
% same col 3
A = [A(:, 1) [4 5 7]' A(:, 2)];
disp(A);

% sum numbers along diagonal of mat A
A = sum(diag(A));
disp(A);

disp('----------------------');

%% Problem 2.2
disp('Problem 2.2');
t = rand(5, 1); % vec of random numbers

% (a)
disp('(a)');
% exp; output vec y1, same length as t
y1 = (6 * t.^3 - 3 * t - 4) ./ (8 * sin(5 * t));
disp(y1);

% (b)
disp('(b)');
% exp; output vec y2, same legnth as t
y2 = ((6 * t - 4) ./ (8 * t) - ((pi / 2) * t));
disp(y2);

disp('----------------------');

%% Problem 2.3
disp('Problem 2.3');
y3 = rand(5, 1); % vec of random numbers
z = rand(5, 1); % vec of random numbers
a = 3; % arbitrary scalar
b = 8; % arbitrary scalar

 % exp; output vec x, same length as y3 and z
x = (y3 .* (a + b .* z).^1.8) / (z .* (1 - y3));
disp(x);

disp('----------------------');

%% Problem 2.4
disp('Problem 2.4');
% (a)
disp('(a)');
A2 = [1 2; 3 4; 5 6];
disp(A2(2, :)');

% (b)
disp('(b)');
y4 = (0:1.5:7)';
disp(y4);

% (c)
disp('(c)');
a2 = 2; b2 = 8; c = 4;
disp(a2 + b2 / c);

disp('----------------------');

%% Problem 2.5
disp('Problem 2.5');


disp('----------------------');

%% Problem 2.6
disp('Problem 2.6');
disp('(a)');
t1 = (4:6:35); disp(t1);
t2 = linspace(4, 34, 6); disp(t2);

disp('(b)');
x1 = (-4:2); disp(x1);
x2 = linspace(-4, 2, 7); disp(x2);

disp('----------------------');

%% Problem 2.7
disp('Problem 2.7');
disp('(a)');
v1 = linspace(-2, 1.5, 8); disp(v1);
v2 = (-2:0.5:1.5); disp(v2);

disp('(b)');
r1 = linspace(8, 4.5, 8); disp(r1);
r2 = (8:-0.5:4.5); disp(r2);

disp('----------------------');
