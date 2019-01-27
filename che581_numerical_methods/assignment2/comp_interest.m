function F_table = comp_interest(P, i, n)

F_table = zeros(n, 2);

for j = 1:n
    F = P * (1 + i)^j;
%     P = F;
    F_table(j, 1) = j;
    F_table(j, 2) = F;
end

end

