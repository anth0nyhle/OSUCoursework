% Created by: Anthony Le
% Last updated: 01.17.2018

% KIN 523: Homework 1 - Vector Math and Describing Human Motion
% Due: 01.18.2018 by 7PM
%% Problem 1
close all;
clear;

% r_MH3: 3rd metacarpal head (knuckle of the middle finger)
% r_MH5: 5th metacarpal head (knuckle of the pinky)
% r_WRI: lunate bone at the wrist

% global XYZ positions of the three markers, in mm
r_MH3 = [366.0; 10.9; 1139.5];
r_MH5 = [350.4; -29.1; 1125.4];
r_WRI = [292.7; 3.5; 1149.1];

% wrist joint center offset from WRI marker
offset = [-11; 0; -21];

% actual wrist joint center position in global XYZ
WJC = r_WRI + offset;

% u vector from WRI to MH3 markers
u = r_MH3 - r_WRI; % x-axis
norm_u = norm(u, 2); % magnitude of u

% v vector from WRI to MH5 markers
v = r_MH5 - r_WRI; % vector b/w WRI and MH5
norm_v = norm(v, 2); % magnitude of v

% w vector perpendicular to the v and u vectors
w = cross(u, v, 1); % y-axis
norm_w = norm(w, 2); % magnitude of w

% unit vectors of hand xyz coordinate system
i = u / norm_u; % unit vector in x
j = w / norm_w; % unit vector in y
k = cross(i, j, 1); % unit vector in z

% cat vectors for data processing ahead
hand_marks = [r_MH3, r_MH5, r_WRI];
unit_vecs = [i, j, k];

% transpose of unit vector matrix
tp_unit_vecs = transpose(unit_vecs);

% global XYZ origin
XYZ = [0; 0; 0];
X = [1; 0; 0];
Y = [0; 1; 0];
Z = [0; 0; 1];

% conversion of wrist joint center position in local hand xyz
WJC_xyz = tp_unit_vecs * (WJC - r_WRI);

% unit vector for hand's anterior axis in global XYZ
e_XYZ = [0; 0; -1];

% values of e_x, e_y, e_z corresponding to the components of e_XYZ in the
% i, j, k directions
e_ijk = unit_vecs \ e_XYZ;

% plotting
% scatter3(hand_marks(1, :), hand_marks(2, :), hand_marks(3, :));
% text(hand_marks(1, 1), hand_marks(2, 1), hand_marks(3, 1), 'MH3');
% text(hand_marks(1, 2), hand_marks(2, 2), hand_marks(3, 2), 'MH5');
% text(hand_marks(1, 3), hand_marks(2, 3), hand_marks(3, 3), 'WRI');
% hold on;

% scatter3(hand_marks(1, :), hand_marks(2, :), hand_marks(3, :));
% hold on;
% scatter3(unit_vecs(1, :), unit_vecs(2, :), unit_vecs(3, :));
% text(unit_vecs(1, 1), unit_vecs(2, 1), unit_vecs(3, 1), 'i');
% text(unit_vecs(1, 2), unit_vecs(2, 2), unit_vecs(3, 2), 'j');
% text(unit_vecs(1, 3), unit_vecs(2, 3), unit_vecs(3, 3), 'k');
% hold on;
% scatter3(xyz(1, :), xyz(2, :), xyz(3, :));
% scatter3(WJC(1, :), WJC(2, :), WJC(3, :));

% u_vec = [r_WRI, u];
% w_vec = [r_WRI, w];
% v_vec = [r_WRI, v];
% i_vec = [XYZ, i];
% j_vec = [XYZ, j];
% k_vec = [XYZ, k];
% plot3(u_vec(1, :), u_vec(2, :), u_vec(3, :));
% plot3(w_vec(1, :), w_vec(2, :), w_vec(3, :));
% plot3(v_vec(1, :), v_vec(2, :), v_vec(3, :));
% plot3(i_vec(1, :), i_vec(2, :), i_vec(3, :));
% plot3(j_vec(1, :), j_vec(2, :), j_vec(3, :));
% plot3(k_vec(1, :), k_vec(2, :), k_vec(3, :));