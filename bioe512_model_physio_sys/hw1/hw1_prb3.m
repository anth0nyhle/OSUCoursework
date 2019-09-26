% filename: uncontrolled circulation (hw1 prb3)
close all;
clear;

circ_parameters; % initial parameters

K_R0 = Q0 / P_sv0;
K_R1 = K_R0 / 2; % K_R reduced

K_L0 = Q0 / P_pv0;
K_L1 = K_L0 / 2; % K_L reduced

R_s0 = (P_sa0 - (Q0 / K_R0)) / Q0;
R_s1 = R_s0 / 2; % R_s reduced

K_R2 = Q0 / (P_sa0 - (R_s1 * Q0)); % R_s reduced

R_p0 = (P_pa0 - (Q0 / K_L0)) / Q0;
R_p1 = R_p0 / 2; % R_p reduced

K_L2 = Q0 / (P_pa0 - (R_p1 * Q0)); % R_p reduced

% normal values for C_sv, C_pv
C_sv0 = (V_sv0 * K_R0) / Q0;
C_pv0 = (V_pv0 * K_L0) / Q0;

% normal values for C_sa, C_pa
C_sa0 = V_sa0 / (((1 / K_R0) + R_s0) * Q0);
C_pa0 = V_pa0 / (((1 / K_L0) + R_p0) * Q0);

% normal values for T_sv, T_pv, T_sa, T_pa
T_sv0 = C_sv0 / K_R0;
T_pv0 = C_pv0 / K_L0;
T_sa0 = (C_sa0 / K_R0) + C_sa0 * R_s0;
T_pa0 = (C_pa0 / K_L0) + C_pa0 * R_p0;

T_sv1 = C_sv0 / K_R1; % K_R reduced
T_pv1 = C_pv0 / K_L1; % K_L reduced
T_sa1 = (C_sa0 / K_R1) + C_sa0 * R_s0; % K_R reduced
T_pa1 = (C_pa0 / K_L1) + C_pa0 * R_p0; % K_L reduced

T_sa2 = (C_sa0 / K_R0) + C_sa0 * R_s1; % R_s reduced
T_pa2 = (C_pa0 / K_L0) + C_pa0 * R_p1; % R_p reduced

% normal value for V0
% V_0 = V_sa0 + V_sv0;
V0 = (T_sa0 + T_sv0 + T_pa0 + T_pv0) * Q0;

V1 = V0 / 2; % V0 reduced

% table values
Q1 = P_sv0 * K_R1;
Q2 = P_pv0 * K_L1;
Q3 = P_sa0 / ((1 / K_R0) + R_s1);
Q4 = P_pa0 / ((1 / K_L0) + R_p1);
Q5 = V1 / (T_sa0 + T_sv0 + T_pa0 + T_pv0);

Q6 = V0 / (T_sa0 + T_sv0 + T_pa1 + T_pv1); % K_L reduced
Q7 = V0 / (T_sa0 + T_sv0 + T_pa2 + T_pv0); % R_p reduced
Q8 = V0 / (T_sa1 + T_sv1 + T_pa0 + T_pv0); % K_R reduced
Q9 = V0 / (T_sa2 + T_sv0 + T_pa0 + T_pv0); % R_s reduced

% table values
P_sa1 = (Q0 / K_R1) + R_s0 * Q0;
P_sa2 = (Q6 / K_R0) + R_s0 * Q6;
P_sa3 = (Q0 / K_R0) + R_s1 * Q0;
P_sa4 = (Q7 / K_R0) + R_s0 * Q7;
P_sa5 = (Q5 / K_R0) + R_s0 * Q5;

P_sv1 = Q0 / K_R1;
P_sv2 = Q6 / K_R0;
P_sv3 = Q0 / K_R2;
P_sv4 = Q7 / K_R0;
P_sv5 = Q5 / K_R0;

P_pa1 = (Q8 / K_L0) + R_p0 * Q8;
P_pa2 = (Q0 / K_L1) + R_p0 * Q0;
P_pa3 = (Q9 / K_L0) + R_p0 * Q9;
P_pa4 = (Q0 / K_L0) + R_p1 * Q0;
P_pa5 = (Q5 / K_L0) + R_p0 * Q5;

P_pv1 = Q8 / K_L0;
P_pv2 = Q0 / K_L1;
P_pv3 = Q9 / K_L0;
P_pv4 = Q0 / K_L2;
P_pv5 = Q5 / K_L0;

V_sa1 = ((C_sa0 / K_R1) + C_sa0 * R_s0) * Q0;
V_sa2 = ((C_sa0 / K_R0) + C_sa0 * R_s0) * Q6;
V_sa3 = ((C_sa0 / K_R0) + C_sa0 * R_s1) * Q0;
V_sa4 = ((C_sa0 / K_R0) + C_sa0 * R_s0) * Q7;
V_sa5 = ((C_sa0 / K_R0) + C_sa0 * R_s1) * Q5;

V_sv1 = (C_sv0 / K_R1) * Q0;
V_sv2 = (C_sv0 / K_R0) * Q6;
V_sv3 = (C_sv0 / K_R2) * Q0;
V_sv4 = (C_sv0 / K_R0) * Q7;
V_sv5 = (C_sv0 / K_R0) * Q5;

V_pa1 = ((C_pa0 / K_L0) + C_pa0 * R_p0) * Q8;
V_pa2 = ((C_pa0 / K_L1) + C_pa0 * R_p0) * Q0;
V_pa3 = ((C_pa0 / K_L0) + C_pa0 * R_p0) * Q9;
V_pa4 = ((C_pa0 / K_L0) + C_pa0 * R_p1) * Q0;
V_pa5 = ((C_pa0 / K_L0) + C_pa0 * R_p1) * Q5;

V_pv1 = (C_pv0 / K_L0) * Q8;
V_pv2 = (C_pv0 / K_L1) * Q0;
V_pv3 = (C_pv0 / K_L0) * Q9;
V_pv4 = (C_pv0 / K_L2) * Q0;
V_pv5 = (C_pv0 / K_L0) * Q5;