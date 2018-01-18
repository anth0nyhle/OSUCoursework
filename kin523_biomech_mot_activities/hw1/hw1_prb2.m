% Created by: Anthony Le
% Last updated: 01.17.2018

% KIN 523: Homework 1 - Vector Math and Describing Human Motion
% Due: 01.18.2018 by 7PM
%% Problem 2
close all;
clear;

% load parameters
load('hand.mat');

% global XYZ positions of the three markers, in mm
MH3 = [MH3X, MH3Y, MH3Z];
MH5 = [MH5X, MH5Y, MH5Z];
WRI = [WRIX, WRIY, WRIZ];

% wrist joint center position in local hand xyz
% from problem 1c
WJC_xyz = [-8.13912848115047; 20.8543822348700; -7.80059800074728];

% u vector from WRI to MH3 markers
U = MH3 - WRI; % x-axis
norm_U = vecnorm(U, 2, 2); % magnitude of u

% v vector from WRI to MH5 markers
V = MH5 - WRI; % vector b/w WRI and MH5
norm_V = vecnorm(V, 2, 2); % magnitude of v

% w vector perpendicular to the v and u vectors
W = cross(U, V, 2); % y-axis
norm_W = vecnorm(W, 2, 2); % magnitude of w

% unit vectors of hand xyz coordinate system
I = U ./ norm_U; % unit vector in x
J = W ./ norm_W; % unit vector in y
K = cross(I, J, 2); % unit vector in z

% cat vectors for data processing ahead
HAND_MARKS = [MH3, MH5, WRI];
UNIT_VECS = [I, J, K];

% table for problem 2a
table_2a = [Time, UNIT_VECS];

% transpose of unit vectors
tp_I = transpose(I);
tp_J = transpose(J);
tp_K = transpose(K);

% reshape matrix of unit vectors
UNIT_VECS_stacked = cat(3, I, J, K);
UNIT_VECS_rs = permute(UNIT_VECS_stacked, [2, 3, 1]);
UNIT_VECS_rs2 = permute(UNIT_VECS_stacked, [3, 2, 1]);

% global XYZ origin
XYZ = [0, 0, 0];
X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

% conversion of wrist joint center position in global XYZ
WJC_XYZ = (transpose([I(1, :); J(1, :); K(1, :)]) * WJC_xyz) + transpose(WRI(1, :));
WJC_XYZ = transpose(WJC_XYZ);

% table for problem 2c
table_2c = [Time(1,:) , WJC_XYZ];

% components of e_XYZ in the i, j, k directions; from problem 1d
x_ijk = [0.129213880302701; 0.910385524181768; -0.393067386713025];

% create empty array
E = [];

% global XYZ components of e in the global XYZ coordinate system
for rows = 1:size(UNIT_VECS_rs, 3)
    e_IJK = UNIT_VECS_rs(:, :, rows) * x_ijk;
    E = cat(2, E, e_IJK);
end
E = transpose(E);

% table for problem 2b
table_2b = [Time, E];

origin = zeros(61, 1); % zeros for plotting origin below

% plotting
for i = 50:61
    scatter3(I(i, 1), I(i, 2), I(i, 3), 'b');
    hold on;
    plot3([origin(i, 1), I(i, 1)], [origin(i, 1), I(i, 2)], [origin(i, 1), I(i, 3)], 'b');
    scatter3(I(1,1), I(1, 2),I(1,3), '.g');
    scatter3(0, 0, 0, 'xk');
    scatter3(J(i, 1), J(i, 2), J(i, 3), 'r');
    plot3([origin(i, 1), J(i, 1)], [origin(i, 1), J(i, 2)], [origin(i, 1), J(i, 3)], 'r');
    scatter3(K(1, 1), K(1, 2), K(1, 3), 'y');
    plot3([origin(i, 1), K(i, 1)], [origin(i, 1), K(i, 2)], [origin(i, 1), K(i, 3)], 'y');
    xlabel('x'); ylabel('y'); zlabel('z');
end