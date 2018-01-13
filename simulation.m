
%% Simulation part
clear; clc;

dt = 0.1;
tFinal = 80;

%continuous
tSpan = 0:dt:tFinal;
x0 = [0;0;0;1];
[t, x_c] = ode45(@dynamic_c, tSpan, x0);
x_c = x_c' ; 

%discrete reality 
x_d_real(:,1) = x0;
Sigma_Q = [100;100;0.0005;0.0005];
Sigma_Q = diag(Sigma_Q);
for t = dt:dt:tFinal
    A_k = dynamic_d(dt, t);
    n = round(t/dt);
    x_d_real(:,n+1) = A_k * x_d_real(:,n) + sqrt(Sigma_Q) * randn(4,1);
    x_d_real(:,n+1) = normalize(x_d_real(:,n+1));
end

% OB simulation
Sigma_R = [1000;1000;0.005;0.005];
Sigma_R = diag(Sigma_R);
y_ob = observation(x_d_real, sqrt(Sigma_R));

%discrete estimation
x_d(:,1) = [0;0;0;1];
cov_d(:,:,1) = diag([1000 1000 1.3 1.3]);
for t = dt:dt:tFinal
    A_k = dynamic_d(dt, t);
    n = round(t/dt);
    
    x_d(:,n+1) = A_k * x_d(:,n);
    x_d(:,n+1) = normalize(x_d(:,n+1));
    cov_d(:,:,n+1) = A_k * cov_d(:,:,n)*A_k' + Sigma_Q;
    
    K = cov_d(:,:,n+1) * (cov_d(:,:,n+1) + Sigma_R)^-1;
    
    x_d(:,n+1) = x_d(:,n+1) + K*(y_ob(:,n+1) - x_d(:,n+1));
    x_d(:,n+1) = normalize(x_d(:,n+1));
    cov_d(:,:,n+1) = (eye(4) - K) * cov_d(:,:,n+1);
end





%% plot part
% State plot
t = 0:dt:tFinal;
subplot(221)
sig_x = sqrt(reshape(cov_d(1,1,:),[1,size(cov_d,3)]));
plot(t,x_d(1,:),'b', t,x_d(1,:)+3*sig_x,'r', t,x_d(1,:)-3*sig_x,'r', t,x_d_real(1,:),'g')
legend(' estimation', '3 sigma', '3 sigma', ' reality');
title('position of x');
xlabel('p_x');
ylabel('time');


subplot(222)
sig_y = sqrt(reshape(cov_d(2,2,:),[1,size(cov_d,3)]));
plot(t,x_d(2,:),'b', t,x_d(2,:)+3*sig_y,'r', t,x_d(2,:)-3*sig_y,'r', t,x_d_real(2,:),'g')
title('position of y');
xlabel('p_y');
ylabel('time');


subplot(223)
sig_phi_x = sqrt(reshape(cov_d(3,3,:),[1,size(cov_d,3)]));
plot(t,x_d(3,:),'b', t,x_d(3,:)+3*sig_phi_x,'r', t,x_d(3,:)-3*sig_phi_x,'r', t,x_d_real(3,:),'g')
title('angle of x');
xlabel('\phi_x');
ylabel('time');


subplot(224)
sig_phi_y = sqrt(reshape(cov_d(4,4,:),[1,size(cov_d,3)]));
plot(t,x_d(4,:),'b', t,x_d(4,:)+3*sig_phi_y,'r', t,x_d(4,:)-3*sig_phi_y,'r', t,x_d_real(4,:),'g')
title('angle of y');
xlabel('\phi_y');
ylabel('time');

% Trajectory plot
figure;
track_xd = plot(x_d(1,:), x_d(2,:),'b');
hold on
track_xd_real = plot(x_d_real(1,:), x_d_real(2,:), 'g');

for n = 10:40:size(t,2)
   plot(x_d(1,n), x_d(2,n), 'bo');
   plot(x_d_real(1,n), x_d_real(2,n), 'go');
   
   sigma_position = draw_circle(x_d(1,n), x_d(2,n), 3*sig_x(n), 'b--');
   
   x_temp_1 = x_d(:,n);
   x_temp_1(3) = x_temp_1(3) - 3*sig_phi_x(n);
   x_temp_1(4) = x_temp_1(4) + 3*sig_phi_y(n);
   theta = atan2(x_temp_1(4), x_temp_1(3));
   x_temp_1(3) = cos(theta);
   x_temp_1(4) = sin(theta);
   
   x_temp_2 = x_d(:,n); 
   x_temp_2(4) = x_temp_2(4) - 3*sig_phi_y(n);
   x_temp_2(3) = x_temp_2(3) + 3*sig_phi_x(n);
   theta = atan2(x_temp_2(4), x_temp_2(3));
   x_temp_2(3) = cos(theta);
   x_temp_2(4) = sin(theta);
   
   heading_estimation = draw_arrow(x_d(:,n), 20, 'c');
   sigma_heading = draw_arrow(x_temp_1, 10, 'c--');
   draw_arrow(x_temp_2, 10, 'c--');
   heading_reality = draw_arrow(x_d_real(:,n), 20, 'r');
end

hold off;
title('simulation trajectory')
xlabel('p_x');
ylabel('p_y');
legend([track_xd, track_xd_real, sigma_position,...
    heading_estimation, sigma_heading, heading_reality],...
    'trajectory of estimation', 'trajectory of reality', '3 sigma of position',...
    'heading of estimation', '3 sigma of heading', 'heading of reality');
