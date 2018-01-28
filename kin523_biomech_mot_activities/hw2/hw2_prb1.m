% Created by: Anthony Le
% Last updated: 01.27.2018

% KIN 523: Homework 2 - Motion Capture
% Due: 01.30.2018
% Extensive explanation of code for the professor...
%% Problem 1
close all;
clear;
% u: horizontal location, [1:1024]
% v: vertical location, [1:1024]
% delta_u: lens distortion

% 7 control pts, col vectors of 3D position (X, Y, Z) locations
% semicolon operator signifies end of row, col vectors w/ 7 rows, 1 col
X = [0; 0.3; 0.8; 0; 0; 0; 0.8]; % in m
Y = [0; 0; 0; 0.4; 1.0; 0; 1.0]; % in m
Z = [0; 0; 0; 0; 0; 0.3; 0.3]; % in m

% combined 3 col vectors above into a single matrix
% XYZ is a matrix of col vectors X, Y, Z from above, 7 rows, 3 cols
XYZ = [X, Y, Z];

% col vectors of X, Y, Z in XYZ matrix become row vectors of X, Y, Z
% in tp_XYZ matrix, 3 rows, 7 cols
tp_XYZ = transpose(XYZ); % transpose XYZ matrix created above

% 7 control pts, horizontal position locations 
u = [367.6; 323.8; 268.1; 518.4; 703.4; 357.9; 552.4]; % in px

% dot operator signifies element-wise operation
% asterisk operator signifies multiplication
% together, element-wise multiplication
% uXYZ = transpose(-(tp_XYZ .* u)); % col vectors of -ux, -uy, -uz in matrix
uXYZ = -(XYZ .* u); % col vectors of -ux, -uy, -uz in uXYZ matrix, 7 rows, 3 cols

% colon operator signifies the index range of all rows (1-7)
% 2nd # after comma is col index
% extracted individual col vectors from uXYZ matrix
uX = uXYZ(:, 1); % 7 rows, 1 col
uY = uXYZ(:, 2); % 7 rows, 1 col
uZ = uXYZ(:, 3); % 7 rows, 1 col

A = zeros(7, 11); % matrix of zeros, 7 rows, 11 cols

% colon operator signifies the entire index range of rows (1-7)
% 2nd # after comma is col index
A(:, 1) = X; % replace entire 1st col w/ col vector X from above
A(:, 2) = Y; % replace entire 2nd col w/ col vector Y from above
A(:, 3) = Z; % replace entire 3rd col w/ col vector Z from above
A(:, 4) = ones(7, 1); % replace entire 4th col w/ col vector of ones
A(:, 9) = uX; % replace entire 9th col w/ col vector uX from above
A(:, 10) = uY; % replace entire 10th col w/ col vector uY from above
A(:, 11) = uZ; % replace entire 11th col w/ col vector uZ from above

% backslash operator signifies matrix left division or
% inversion of A matrix right multiplied by u col vector
L1 = A \ u; % solve the system of linear equations A*L = u, 11 rows, 1 col

R = (XYZ * L1(9:11)) + ones(7, 1);

% plot (X, Y, Z) position of control points
scatter3(X, Y, Z);
title('Marker (X, Y, Z) Position for 7 Control Points, Camera 1');
xlabel('Marker X Position (m)');
ylabel('Marker Y Position (m)');
zlabel('Marker Z Position (m)');