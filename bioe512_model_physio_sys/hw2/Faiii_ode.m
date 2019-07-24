function dYaiii = Faiii_ode(t, y)
l_0 = 220; % in mm
k_1 = 200; % in N/mm
k_2 = 467; % in N/mm
b = 15000; % in Ns/mm

l = 225 - 5 * cos(2 * pi * 5 * t);

dl = 5 * 2 * pi * 5 * sin(2 * pi * 5 * t);
dFaiii = (k_1 * dl) + ((k_1 * k_2 * (l - l_0)) / b) - (((k_1 + k_2) * y(2)) / b);
dYaiii = [dl; dFaiii];