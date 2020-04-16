% Created by: Anthony Le
% Last updated: 01.29.2018

% KIN 523: Homework 2 - Motion Capture
% Due: 01.30.2018
% Extensive explanation of code for the professor...
%% Problem 2
close all;
clear;

% load data as individual col vectors
% (i.e. frame, u1, u2, v2, all 49 by 1 vectors)
load('marker.mat');

% from Problem 1; L constants for Camera 1
load('L1.mat'); % col vectors of L constants L_1-L_11

% problem 2a
t = 0; % 1st frame
time = []; % empty vector
time = cat(1, time, t); % add time 0 to vector

% for loop to fill time vector
% iterate from frame 2 thru 49
% add 0.0333s iteratively since fps was 30 frame/s
for t_stp = 2:49
    t = t + 0.0333;
    time = cat(1, time, t);
end

% extract individual L constants from col vector above
% index of L is representated as L(row, col)
% (e.g. L(1, 1) means the value in the 1st row, 1st (only) col of L)
L1_1 = L1(1, 1);
L1_2 = L1(2, 1);
L1_3 = L1(3, 1);
L1_4 = L1(4, 1);
L1_5 = L1(5, 1);
L1_6 = L1(6, 1);
L1_7 = L1(7, 1);
L1_8 = L1(8, 1);
L1_9 = L1(9, 1);
L1_10 = L1(10, 1);
L1_11 = L1(11, 1);

% L constants for Camera 2; provided in hw2 handout
L2_1 = -551.0;
L2_2 = -160.5;
L2_3 = -89.7;
L2_4 = 689.9;
L2_5 = 0;
L2_6 = 0;
L2_7 = 0;
L2_8 = 0;
L2_9 = -0.381;
L2_10 = 0.381;
L2_11 = -0.175;

% Z position from hw2 handout
Z = 0.15; % in m

% problem 2b
% constants provided in hw2 handout
u_0 = 512; % in px
v_0 = 512; % in px
L2_12 = -4.0 * 10^-7; % in px^-2

% repmat function repeats copies of array
% (i.e. each constant is repeated 49 times)
% individual constants become col vectors, 49 rows, 1 col
u_0 = repmat(u_0, 49, 1); % create col vector of u_0 value repeated
v_0 = repmat(v_0, 49, 1); % create col vector of v_0 value repeated
% L_12 = repmat(L_12, 49, 1);

% eq. 3 from hw2 handout
% sqrt function signifies square root
% dot operator signifies element-wise operation
% carrot operator signifies power
% together, element-wise power
r_u2 = sqrt((u2 - u_0).^2 + (v2 - v_0).^2);

% horizontal lens distortion function for Camera 2, eq. 2 from hw2 handout
% dot operator signifies element-wise operation
% asterisk operator signifies multiplication
% together, element-wise multiplication
delta_u2 = ((u2 - u_0) .* r_u2.^2) * L2_12;

% problem 2c
A = zeros(2, 2, 49); % alocate memory for 3D matrix, 2 rows, 2 cols, 49 times
% imagine 2 by 3 matrices stacked in 3rd dim
% result in a stack of 49 2 by 2 matrices

% for loop to fill values into A matrix
% iterate in 3rd dim of A matrix (i.e. iterate thru matrices, see above)
% iterate in 1st dim of col vectors, u1, u2, delta_u2 (i.e. iterate row indices)
for i = 1:49
    A(1, 1, i) = (u1(i, 1) * L1_9) - L1_1;
    A(2, 1, i) = ((u2(i, 1) - delta_u2(i, 1)) * L2_9) - L2_1;
    A(1, 2, i) = (u1(i, 1) * L1_10) - L1_2;
    A(2, 2, i) = ((u2(i, 1) - delta_u2(i, 1)) * L2_10) - L2_2;
%     A(1, 3, i) = (u1(i, 1) * L1_11) - L1_3;
%     A(2, 3, i) = ((u2(i, 1) - delta_u2(i, 1)) * L2_11) - L2_3;
end

B = zeros(2, 1, 49); % allocate memory for 3D matrix, 2 rows, 1 col, 49 times
% imagine 2 by 1 col vectors stacked in 3rd dim
% result in a stack of 49 2 by 1 col vectors

% for loop to fill values into B matrix
% iterate in 3rd dim of B matrix (i.e. iterate thru matrices, see above)
% iterate in 1st dim of col vectors, u1, u2, and delta_u (i.e. iterate row indices)
for j = 1:49
    B(1, 1, j) = (L1_4 - u1(j, 1)) - ((u1(j, 1) * L1_11) - L1_3) * Z;
    B(2, 1, j) = (L2_4 - (u2(j, 1) - delta_u2(j, 1))) - (((u2(j, 1) - delta_u2(j, 1)) * L2_11) - L2_3) * Z;
end

XY = []; % empty matrix

% for loop to fill values into XYZ matrix
% 1st colon operator in A and B signifies the entire index range of rows
% (i.e. 1-2 rows for A and B)
% 2nd colon operator in A and B signifies the entire index range of cols
% (i.e. 1-2 and 1-1 cols for A and B, respectively)
% iterate in 3rd dim of A and B matrices
% cat function signifies concatenate value along specified dim
for k = 1:49
    xy = A(:, :, k) \ B(:, :, k); % col vector of x, y values
    XY = cat(2, XY, xy); % concatenate col vectors in 2nd dim
end
% XY matrix results in 2 by 49 matrix, 49 col vectors of x, y values

XY = transpose(XY); % transpose XY matrix for plotting along 1st dim below
% XY matrix becomes a 49 by 2 matrix; X, Y col vectors

% problem 2d
table_2d = [frame, time, delta_u2, XY, repmat(Z, 49, 1)];

% problem 2e
% plot (X, Y) position of markers
plot(XY(:, 1), XY(:, 2), '-o');
grid on;
hold on;
plot(XY(1, 1), XY(1, 2), 'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g');
plot(XY(49, 1), XY(49, 2), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
plot(0, 0, 'xk');
text(0, 0, '\leftarrow origin (0, 0)');
text(XY(1, 1), XY(1, 2), 'start \rightarrow');
text(XY(49, 1), XY(49, 2), '\leftarrow end');
title('Marker (X, Y) Position on Top of Robotic Vehicle over Time, 2 Camera Setup');
xlabel('Marker X Position (m)');
ylabel('Marker Y Position (m)');