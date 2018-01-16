% Created by: Anthony Le
% Last updated: 01.15.2018

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

% wrist joint center offset from WRI marker
offset = [-11, 0, -21];

% actual wrist joint center position in global XYZ
WJC = WRI + offset;

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

% [rows, cols] = size(Time);

% global XYZ origin
XYZ = [0, 0, 0];

% create empty arrays
WJC_xyz = [];
WJC_XYZ = [];
WJC_cov1 = [];
WJC_cov2 = [];

% conversion of wrist joint center position in local hand xyz
for rows = 1:size(UNIT_VECS_rs2, 3)
    WJC_cov1 = UNIT_VECS_rs2(:, :, rows) * transpose(WJC(rows, :) - WRI(rows, :));
    WJC_xyz = cat(2, WJC_xyz, WJC_cov1);
end
WJC_xyz = transpose(WJC_xyz);

% conversion of wrist joint center position in global XYZ
for rows = 1:size(UNIT_VECS_rs, 3)
    WJC_cov2 = (UNIT_VECS_rs(:, :, rows) * transpose(WJC_xyz(rows, :))) + transpose(WRI(rows, :));
    WJC_XYZ = cat(2, WJC_XYZ, WJC_cov2);
end
WJC_XYZ = transpose(WJC_XYZ);

% table for problem 2c
table_2c = [Time, WJC_XYZ];

% unit vector for hand's anterior axis in global XYZ
e_XYZ = [0; 0; -1];

% create empty array
E = [];

% values of e_x, e_y, e_z corresponding to the components of e_XYZ in the
% I, J, K directions
% e_IJK = UNIT_VECS_rs .\ e_XYZ;
% for rows = 1:size(e_IJK, 3)
%     E = cat(1, E, e_IJK(3, :, rows));
% end
for rows = 1:size(UNIT_VECS_rs, 3)
    e_IJK = UNIT_VECS_rs(:, :, rows) \ e_XYZ;
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