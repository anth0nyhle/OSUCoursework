function F_S = sub_conc(S_0, S, v_m, k_s, t)

F_S = S_0 - (v_m * t) + (k_s * log(S_0 / S)) - S;

end

