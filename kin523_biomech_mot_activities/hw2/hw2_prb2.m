% Created by: Anthony Le
% Last updated: 01.26.2018

% KIN 523: Homework 2 - Motion Capture
% Due: 01.30.2018
% Extensive explanation of code for the professor...
%% Problem 2
close all;
clear;

% load data as individual col vectors
% (i.e. frame, u1, u2, v2, all 49 by 1 vectors)
load('marker.mat');

load('L.mat');

L_1 = L(1, 1);
L_2 = L(2, 1);
L_3 = L(3, 1);
L_4 = L(4, 1);
L_5 = L(5, 1);
L_6 = L(6, 1);
L_7 = L(7, 1);
L_8 = L(8, 1);
L_9 = L(9, 1);
L_10 = L(10, 1);
L_11 = L(11, 1);

Z = 0.15; % in m

% part b
% constants provided in hw2 handout
u_0 = 512; % in px
v_0 = 512; % in px
L_12 = -4.0 * 10^-7; % in px^-2

u_0 = repmat(u_0, 49, 1);
v_0 = repmat(v_0, 49, 1);
% L_12 = repmat(L_12, 49, 1);

% u = u2;
% v = v2;

% eq. 3 from hw2 handout
r = sqrt((u2 - u_0).^2 + (v2 - v_0).^2);

% lens distortion fucntion for Camera 2, eq. 2 from hw2 handout
delta_u2 = ((u2 - u_0) .* r.^2) * L_12;

A = zeros(2, 3, 49);

for i = 1:49
    A(1, 1, i) = (u1(i, 1) * L_9) - L_1;
    A(2, 1, i) = (u2(i, 1) * L_9) - L_1;
    A(1, 2, i) = (u1(i, 1) * L_10) - L_2;
    A(2, 2, i) = (u2(i, 1) * L_10) - L_2;
    A(1, 3, i) = (u1(i, 1) * L_11) - L_3;
    A(2, 3, i) = (u2(i, 1) * L_11) - L_3;
end

B = zeros(2, 1, 49);

for j = 1:49
    B(1, 1, j) = (L_4 - u1(j, 1));
    B(2, 1, j) = (L_4 - u1(j, 1));
end

XYZ = [];

for k = 1:49
    xyz = A(:, :, k) \ B(:, :, k);
    XYZ = cat(2, XYZ, xyz);
end

XYZ = transpose(XYZ);

XYZ(:, 3) = repmat(Z, 49, 1);

plot(XYZ(:, 1), XYZ(:, 2), '-o');