function [iter, cos_val, cos_err] = eval_cos(x, err_crtn)

% initialize empty arrays
iter = [];
cos_val = [];
cos_err = [];

% tru_val = cos(x); % true value
apprx_val = 1; % 1st approximation
n = 2; % coefficient additive

i = 2; % iteration count

iter(1, 1) = 1; % store 1st count
cos_val(1, 1) = apprx_val; % store 1st approximation
% cos_err(1, 1) = (abs(tru_val - apprx_val) / tru_val) * 100; % store 1st approximation error
cos_err(1, 1) = NaN; % no previous approximation to calculate relative error 

while (1)
    if mod(i, 2) == 0 % alternate addition of negative term
        apprx_val = apprx_val - ((x^n) / (factorial(n))); % current value
        rel_err = (abs(apprx_val - cos_val(i-1, 1)) / apprx_val) * 100; % relative error
        cos_val(i, 1) = apprx_val;
        cos_err(i, 1) = rel_err;
        iter(i, 1) = i;
        n = n + 2;
        i = i + 1;
    elseif mod(i, 2) == 1 % alternate addition of positive term
        apprx_val = apprx_val + ((x^n) / (factorial(n))); % current value
        rel_err = (abs(apprx_val - cos_val(i-1, 1)) / apprx_val) * 100; % relative error
        cos_val(i, 1) = apprx_val;
        cos_err(i, 1) = rel_err;
        iter(i, 1) = i;
        n = n + 2;
        i = i + 1;
    end
    % break when relative error meets error criterion
    if rel_err < err_crtn; break; end
end

end