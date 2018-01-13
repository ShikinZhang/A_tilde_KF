function A_k = dynamic_d(dt, t)
v = trac_v(t);
w = trac_w(t);

A_k = eye(4);
A_k(1,3) = v*dt;
A_k(2,4) = v*dt;
A_k(3,4) =-w*dt;
A_k(4,3) = w*dt;
end