function rpy_angles=getRPY(T)

% This function computes the RPY angles of a transformation matrix T
% and outputs angles phi (rotation about Z), theta (rotation about Y), 
% and psi (rotaton about X) as a 1x3 vector in units of degrees.
% ASA 9-97

% Define vectors n, o, a.
n = T(1:3,1);
o = T(1:3,2);
a = T(1:3,3);

% Check for degeneracy; degeneracy occurs when theta = +/- 90 degrees.
if (n(1) == 0.0) & (n(2) == 0.0)
	theta_rad = pi * 0.5;
	phi_rad = 0.0;
	psi_rad = atan2(-a(2),o(2)); 


% Solve non-degenerate case (with -90 < theta < 90). 
else
	phi_rad = atan2(n(2), n(1));
	c_phi = cos(phi_rad);
	s_phi = sin(phi_rad);
	theta_rad = atan2(-n(3), c_phi*n(1) + s_phi*n(2));
	psi_rad = atan2(s_phi*a(1) - c_phi*a(2), -s_phi*o(1) + c_phi*o(2));
end

% Convert radians to degrees.
rad_to_deg= 180.0/pi;
phi = phi_rad * rad_to_deg;
theta = theta_rad * rad_to_deg;
psi = psi_rad * rad_to_deg;

rpy_angles = [phi theta psi];


% Compute original transformation matrix from RPY angles as a check.
c_phi = cos(phi_rad);
s_phi = sin(phi_rad);
c_theta = cos(theta_rad);
s_theta = sin(theta_rad);
c_psi = cos(psi_rad);
s_psi = sin(psi_rad);
RPY = [c_phi*c_theta c_phi*s_theta*s_psi-s_phi*c_psi c_phi*s_theta*c_psi+s_phi*s_psi 0; ...
       s_phi*c_theta s_phi*s_theta*s_psi+c_phi*c_psi s_phi*s_theta*c_psi-c_phi*s_psi 0; ...
	   -s_theta   c_theta*s_psi  c_theta*c_psi 0; 0 0 0 1];
	
	
	
