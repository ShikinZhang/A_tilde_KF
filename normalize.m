function x_n = normalize(x)
absolute = sqrt(x(3)^2 + x(4)^2);
x(3) = x(3) / absolute;
x(4) = x(4) / absolute;
x_n = x;
end