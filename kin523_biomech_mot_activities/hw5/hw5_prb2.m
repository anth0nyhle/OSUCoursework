% Created by: Anthony Le
% Last updated: 02.21.2018

% KIN 523: Homework 5 - 3D Kinematics & Anthropometry
% Due: 02.22.18
%% Problem 2
close all;
clear;

% orientation of anatomical xyz unit vectors of thigh in global XYZ at
% instant of ground contact; proximal segment
i_T = [0.962; 0.110; -0.251];
j_T = [-0.258; 0.053; -0.965];
k_T = [-0.093; 0.992; 0.080];
IJK = [i_T, j_T, k_T];

% orientation of anatomical xyz unit vectors of leg in global XYZ at
% instant of ground contact; distal segment
i_L = [0.991; -0.103; 0.085];
j_L = [0.091; 0.050; -0.995];
k_L = [0.098; 0.993; 0.059];
ijk = [i_L, j_L, k_L];

% part a
% rotation matrix from measured orientations of leg, thigh unit vectors
% at instant of ground contact
% RotM = IJK .* ijk';
RotM = [dot(i_T, i_L), dot(j_T, i_L), dot(k_T, i_L); 
        dot(i_T, j_L), dot(j_T, j_L), dot(k_T, j_L);
        dot(i_T, k_L), dot(j_T, k_L), dot(k_T, k_L)];

% part b
% y, x, z rotation sequence of alpha, beta, gamma
beta = asind(-RotM(3, 2));
alpha = atand(RotM(3, 1) / RotM(3, 3));
gamma = atand(RotM(1, 2) / RotM(2, 2));

% part c
% knee flexion axis unit vector at instant of ground contact
knee_flex = RotM \ j_T; 

% knee abduction axis (i.i. line of nodes) unit vector at instant of ground
% contact
knee_abd = RotM \ (cross(j_T, k_L) / norm(cross(j_T, k_L)));

% knee external rotation axis unit vector  at instant of ground contact
knee_exrot = RotM \ k_L;