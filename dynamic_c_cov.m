function dpdt = dynamic_c_cov(t, p, sigma_R, sigma_Q)
v = trac_v(t);
w = trac_w(t);
A = zeros(4);
A(1,3) = v;
A(2,4) = v;
A(3,4) =-w;
A(4,3) = w;

% the input of p is always column vector, so reshape it
p = reshape(p, [4,4]);

dpdt = A*p + p*A' - p*(sigma_R^-1)*p + sigma_Q;
%reshape for dpdt
dpdt = reshape(dpdt,[16 1]);

end