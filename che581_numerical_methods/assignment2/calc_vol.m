function tank_vol = calc_vol(R, d)

if d <= R
    tank_vol = pi * R * (d / 3);
else
    tank_vol = (pi * R * (d / 3)) + (R * d);
end

end

