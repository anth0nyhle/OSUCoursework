function dS = moment_ode(e)
k_1 = 1.2365;
k_2 = 64.01;
k_3 = 240;
k_4 = 0;

if e >= 0 && e <= e_toe
    ds = k_1 * (exp(k_2 * e) - 1);
elseif e > e_toe
    ds = k_3 * e + k_4;
end

dS = [e, ds];