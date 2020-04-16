function f_cd = freefall_f(m, vel, t, g, c_d)

f_cd = sqrt((g * m) / c_d) * tanh(sqrt((g * c_d / m )) * t) - vel;

end

