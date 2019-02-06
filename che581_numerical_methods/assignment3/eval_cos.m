function [iter, cos_val, cos_err] = eval_cos(x, err_crtn)

iter = [];
cos_val = [];
cos_err = [];

tru_val = cos(x);
apprx_val = 1;
n = 2;

i = 2; % count

iter(1, 1) = 1;
cos_val(1, 1) = apprx_val;
cos_err(1, 1) = (abs(tru_val - apprx_val) / tru_val) * 100;

% rel_err = cos_err(2,1);

while (1)
    if mod(i, 2) == 0
        apprx_val = apprx_val - ((x^n) / (factorial(n)));
        rel_err = (abs(tru_val - apprx_val) / tru_val) * 100;
        cos_val(i, 1) = apprx_val;
        cos_err(i, 1) = rel_err;
        iter(i, 1) = i;
        n = n + 2;
        i = i + 1;
    elseif mod(i, 2) == 1
        apprx_val = apprx_val + ((x^n) / (factorial(n)));
        rel_err = (abs(tru_val - apprx_val) / tru_val) * 100;
        cos_val(i, 1) = apprx_val;
        cos_err(i, 1) = rel_err;
        iter(i, 1) = i;
        n = n + 2;
        i = i + 1;
    end
    if rel_err < err_crtn; break; end
end

end