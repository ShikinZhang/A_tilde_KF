function x_ob = observation(x_real, Sigma_R)

x_ob = Sigma_R * randn(4,size(x_real,2)) + x_real;

end