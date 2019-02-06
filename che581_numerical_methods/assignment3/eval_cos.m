function [cos_val, cos_err] = eval_cos(x, err_crtn)

cos_val = [];
cos_err = [];

tru_val = cos(x);
apprx_val = 1 - ((x^2) / 2);
n = 4;

i = 3; % count

cos_val(1, 1) = 1;
cos_val(2, 1) = apprx_val;

cos_err(1, 1) = (abs(tru_val - 1) / tru_val) * 100;
cos_err(2, 1) = (abs(tru_val - apprx_val) / tru_val) * 100;

% rel_err = cos_err(2,1);

while (1)
    if mod(i, 2) == 0
        apprx_val = apprx_val + ((x^n) / (factorial(n)));
        rel_err = (abs(tru_val - apprx_val) / tru_val) * 100;
        cos_val(i, 1) = apprx_val;
        cos_err(i, 1) = rel_err;
        n = n + 2;
        i = i + 1;
    elseif mod(i, 2) == 1
        apprx_val = apprx_val - ((x^n) / (factorial(n)));
        rel_err = (abs(tru_val - apprx_val) / tru_val) * 100;
        cos_val(i, 1) = apprx_val;
        cos_err(i, 1) = rel_err;
        n = n + 2;
        i = i + 1;
    end
    if rel_err < err_crtn; break; end
end

end