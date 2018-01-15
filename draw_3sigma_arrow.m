function h = draw_3sigma_arrow(x, cov_x, color)
stddev_phi_x = sqrt(cov_x(3,3));
stddev_phi_y = sqrt(cov_x(4,4));
x_temp_1 = x;
x_temp_1(3) = x_temp_1(3) - 3*stddev_phi_x;
x_temp_1(4) = x_temp_1(4) + 3*stddev_phi_y;
theta = atan2(x_temp_1(4), x_temp_1(3));
x_temp_1(3) = cos(theta);
x_temp_1(4) = sin(theta);
   
x_temp_2 = x; 
x_temp_2(4) = x_temp_2(4) - 3*stddev_phi_y;
x_temp_2(3) = x_temp_2(3) + 3*stddev_phi_x;
theta = atan2(x_temp_2(4), x_temp_2(3));
x_temp_2(3) = cos(theta);
x_temp_2(4) = sin(theta);

h = draw_arrow(x_temp_1, 10, color);
h = draw_arrow(x_temp_2, 10, color);


end