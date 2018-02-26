function dYd = ld_ode(t, y)
l_0 = 220; % in mm
k_1 = 200; % in N/mm
k_2 = 467; % in N/mm
b = 15000; % in Ns/mm

if t >= 0 && t <= 1
    F = 1000 - 1000 * cos(2 * pi * 0.5 * t);
    dF = 1000 * 2 * pi * 0.5 * sin(2 * pi * 0.5 * t);
else
    F = 2000;
    dF = 0;
end

dld = ((1 / k_1) * dF) + (((k_1 + k_2) * F) / (k_1 * b)) - ((k_2 * (y(2) - l_0)) / b);
dYd = [dF; dld];