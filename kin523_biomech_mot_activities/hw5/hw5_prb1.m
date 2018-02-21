% Created by: Anthony Le
% Last updated: 02.20.2018

% KIN 523: Homework 5 - 3D Kinematics & Anthropometry
% Due: 02.22.18
%% Problem 1
close all;
clear;

% left foot markers global XYZ positions on avg
r_HEE = [0.155; 0.035; -0.132]; % in m
r_TOE = [0.303; 0.063; -0.124]; % in m
r_MT5 = [0.309; 0.033; -0.191]; % in m

% orientations of marker-based prime xyz unit vectors of foot in global XYZ 
i_prime = [0.981; 0.186; 0.053]; % points anteriorly
j_prime = [0.125; -0.400; -0.908]; % points left
k_prime = [-0.147; 0.898; -0.415]; % points from plantar to dorsal
ijk_prime = [i_prime, j_prime, k_prime];

% orientation of anatomical xyz unit vectors of foot in global XYZ
i = [0.996; -0.087; 0];
j = [0; 0; -1];
k = [0.087; 0.996; 0];
ijk = [i, j, k];

foot_len = 25.4; % in cm
foot_len = foot_len / 100; % convert into m
mark_dia = 9.5; % in mm
mark_dia = mark_dia / 1000; % convert into m

% part a
% global XYZ position of foot tip during static trial
tip_XYZ = r_HEE + [foot_len + (mark_dia / 2);  0;  0];

% part b
% marker-based xyz position of foot tip during static trial
tip_xyz = ijk_prime \ (tip_XYZ - r_TOE); % in m

% part c
% rotational transformation matrix (RTM)
RTM = ijk_prime \ ijk;

% part d
% left foot markers global XYZ positions on avg at preak height of jump
r_HEE_peak = [0.277; 0.417; -0.134]; % in m
r_TOE_peak = [0.408; 0.348; -0.164]; % in m
r_MT5_peak = [0.373; 0.308; -0.214]; % in m

% orientations of marker-based prime xyz unit vectors of foot in global XYZ
% at peak height of jump
i_prime_peak = [0.870; -0.453; -0.196];
j_prime_peak = [-0.451; -0.567; -0.689];
k_prime_peak = [0.201; 0.688; -0.697];
ijk_prime_peak = [i_prime_peak, j_prime_peak, k_prime_peak];

tip_XYZ_peak = r_TOE_peak + (ijk_prime_peak * tip_xyz);

% part e
% orientation of anatomical xyz unit vectors of foot in global XYZ at peak
% height of jump
ijk_peak = ijk_prime_peak * RTM;