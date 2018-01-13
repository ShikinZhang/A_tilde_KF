function dxdt = dynamic_c(t, x)
v = trac_v(t);
w = trac_w(t);
dxdt(1:4,1) = 0;
% 
% mu = sqrt(x(3)^2 + x(4)^2);
% x(3) = x(3) / mu;
% x(4) = x(4) / mu;


dxdt(1) = v * x(3);
dxdt(2) = v * x(4);
dxdt(3) =-w * x(4);
dxdt(4) = w * x(3);


end


