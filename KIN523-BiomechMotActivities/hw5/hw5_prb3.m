% Created by: Anthony Le
% Last updated: 02.22.2018

% KIN 523: Homework 5 - 3D Kinematics & Anthropometry
% Due: 02.22.18
%% Problem 3
close all;
clear;

m_BODY = 56.3; % in kg
l_FOOT = 254; % in mm
l_ANKMTH2 = 142; % in mm
h_ANKLE = 91; % in mm
w_ANKLE = 61; % in mm

% part a
% Dempster & Gaughran
mass_DG = 0.0145 * m_BODY;
MoI_DG = mass_DG * (0.475 * l_ANKMTH2)^2;

% Zatsiorsky
mass_Z = 0.0129 * m_BODY;
MoI_Z = mass_Z * (0.299 * l_FOOT)^2;

% Vaughn, Hinrichs
mass_VH = (0.0083 * m_BODY) + ((2.545e-07) * l_FOOT * h_ANKLE * w_ANKLE) - 0.065;
MoI_VH = (67.508 * l_FOOT) - (42.725 * h_ANKLE) - 10542;