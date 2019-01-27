function [sine_val, sine_err, n] = eval_sine(x, odr_trm)

sine_val = zeros(odr_trm, 1);
sine_err = zeros(odr_trm, 1);

tru_val = sin(x);
apprx_val = x;
n = 3;

sine_val(1, 1) = apprx_val;
sine_err(1, 1) = (abs(tru_val - apprx_val) / tru_val) * 100;

for i = 2:odr_trm
    if mod(i, 2) == 0
        apprx_val = apprx_val - ((x^n) / (factorial(n)));
        rel_err = (abs(tru_val - apprx_val) / tru_val) * 100;
        sine_val(i, 1) = apprx_val;
        sine_err(i, 1) = rel_err;
        n = n + 2;
    elseif mod(i, 2) == 1
        apprx_val = apprx_val + ((x^n) / (factorial(n)));
        rel_err = (abs(tru_val - apprx_val) / tru_val) * 100;
        sine_val(i, 1) = apprx_val;
        sine_err(i, 1) = rel_err;
        n = n + 2;
    end
end

end

