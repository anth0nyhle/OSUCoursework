% Created by: Anthony Le
% Last updated: 01.15.2018

% KIN 523: Homework 1 - Vector Math and Describing Human Motion
% Due: 01.18.2018 by 7PM
%% Problem 2
close all;
clear;

load('hand.mat');

% global XYZ positions of the three markers, in mm
MH3 = [MH3X, MH3Y, MH3Z];
MH5 = [MH5X, MH5Y, MH5Z];
WRI = [WRIX, WRIY, WRIZ];

U = MH3 - WRI; % x-axis
norm_U = vecnorm(U, 2, 2);

V = MH5 - WRI; % vector b/w WRI and MH5
norm_V = vecnorm(V, 2, 2);

W = cross(U, V, 2); % y-axis
norm_W = vecnorm(W, 2, 2);

% unit vectors of hand xyz coordinate system
I = U ./ norm_U; % unit vector in x
J = W ./ norm_W; % unit vector in y
K = cross(I, J, 2); % unit vector in z

HAND_MARKS = [MH3, MH5, WRI];
UNIT_VECS = [I, J, K];

table_a = [Time, UNIT_VECS];

% transpose of unit vectors
tp_I = transpose(I);
tp_J = transpose(J);
tp_K = transpose(K);

UNIT_VECS_stacked = cat(3, I, J, K);
UNIT_VECS_rs = permute(UNIT_VECS_stacked, [2, 3, 1]);

[rows, cols] = size(Time);

% global origin
XYZ = [0; 0; 0];

% wrist joint center position in local hand xyz


% unit vector for hand's anterior axis in global XYZ
e_XYZ = [0; 0; -1];

E = [];

% values of e_x, e_y, e_z corresponding to the components of e_XYZ in the
% i, j, k directions
% e_IJK = UNIT_VECS_rs .\ e_XYZ;
% for rows = 1:size(e_IJK, 3)
%     E = cat(1, E, e_IJK(3, :, rows));
% end
for rows = 1:size(UNIT_VECS_rs, 3)
    e_IJK = UNIT_VECS_rs(:, :, rows) \ e_XYZ;
    E = cat(2, E, e_IJK);
end
E = transpose(E);
table_b = [Time, E];