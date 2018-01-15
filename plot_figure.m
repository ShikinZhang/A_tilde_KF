function plot_figure(t, x, cov, x_real, str)
figure('Name', str, 'NumberTitle', 'off')
title("continuous");
subplot(221)
sig_x = sqrt(reshape(cov(1,1,:),[1,size(cov,3)]));
plot(t,x(1,:),'b', t,x(1,:)+3*sig_x,'r', t,x(1,:)-3*sig_x,'r', t,x_real(1,:),'g')
legend(' estimation', '3 sigma', '3 sigma', ' reality');
title('position of x');
xlabel('p_x');
ylabel('time');


subplot(222)
sig_y = sqrt(reshape(cov(2,2,:),[1,size(cov,3)]));
plot(t,x(2,:),'b', t,x(2,:)+3*sig_y,'r', t,x(2,:)-3*sig_y,'r', t,x_real(2,:),'g')
title('position of y');
xlabel('p_y');
ylabel('time');


subplot(223)
sig_phi_x = sqrt(reshape(cov(3,3,:),[1,size(cov,3)]));
plot(t,x(3,:),'b', t,x(3,:)+3*sig_phi_x,'r', t,x(3,:)-3*sig_phi_x,'r', t,x_real(3,:),'g')
title('angle of x');
xlabel('\phi_x');
ylabel('time');


subplot(224)
sig_phi_y = sqrt(reshape(cov(4,4,:),[1,size(cov,3)]));
plot(t,x(4,:),'b', t,x(4,:)+3*sig_phi_y,'r', t,x(4,:)-3*sig_phi_y,'r', t,x_real(4,:),'g')
title('angle of y');
xlabel('\phi_y');
ylabel('time');

end