function dxdt = dynamic_c(t, x, k, y_ob, rand_vec)
v = trac_v(t);
w = trac_w(t);
A = zeros(4);
A(1,3) = v;
A(2,4) = v;
A(3,4) =-w;
A(4,3) = w;

dxdt = A*x + k*(y_ob - x) + rand_vec;
end


