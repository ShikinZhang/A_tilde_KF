
%% Simulation part
clear; clc;

%initial parameter
dt = 0.1;
tFinal = 80;
x0 = [0;0;0;1];
Sigma_Q = [100;100;0.0005;0.0005];
Sigma_Q = diag(Sigma_Q);
Sigma_R = [1000;1000;0.005;0.005];
Sigma_R = diag(Sigma_R);

% 
% %discrete reality 
% x_d_real(:,1) = x0;
% for t = dt:dt:tFinal
%     A_k = dynamic_d(dt, t);
%     n = round(t/dt);
%     x_d_real(:,n+1) = A_k * x_d_real(:,n) + sqrt(Sigma_Q) * randn(4,1);
%     x_d_real(:,n+1) = normalize(x_d_real(:,n+1));
% end

% continuous reality
tSpan = 0:dt:tFinal;
x_c_real(:,1) = x0;
for t = dt:dt:tFinal
    n = round(t/dt);
    rand_vec = sqrt(Sigma_Q) * randn(4,1);
    [t_, x_temp] = ode45(@(t, x) dynamic_c(t, x, 0, 0, rand_vec), [t-dt, t-dt/2, t], x_c_real(:,n));
    x_temp = x_temp';
    x_c_real(:,n+1) = x_temp(:,end);
end

% OB simulation

y_ob = observation(x_c_real, sqrt(Sigma_R));


%continuous estimation
x_c(:,1) = x0;
cov_c(:,:,1) = diag([1000 1000 1.3 1.3]);
for t = dt:dt:tFinal
    n = round(t/dt);
    k = cov_c(:,:,n)*Sigma_R^-1; 
    [t_, x_temp] = ode45(@(t, x) dynamic_c(t, x, k, y_ob(:,n), 0), [t-dt, t], x_c(:,n));
    x_temp = x_temp';
    x_c(:,n+1) = x_temp(:,end);
    
    
    [t_, cov_temp] = ode45(@(t, p) dynamic_c_cov(t, p, Sigma_R, Sigma_Q), [0, dt], cov_c(:,:,n));
    cov_temp = cov_temp';
    cov_temp = cov_temp(:,end);
    cov_temp = reshape(cov_temp, [4,4]);
    cov_c(:,:,n+1) = cov_temp;
end



%discrete estimation
x_d(:,1) = [0;0;0;1];
cov_d(:,:,1) = diag([1000 1000 1.3 1.3]);
for t = dt:dt:tFinal
    A_k = dynamic_d(dt, t);
    n = round(t/dt);
    
    x_d(:,n+1) = A_k * x_d(:,n);
    x_d(:,n+1) = normalize(x_d(:,n+1));
    cov_d(:,:,n+1) = A_k * cov_d(:,:,n)*A_k' + Sigma_Q*dt^2;
    
    K = cov_d(:,:,n+1) * (cov_d(:,:,n+1) + Sigma_R)^-1;
    
    x_d(:,n+1) = x_d(:,n+1) + K*(y_ob(:,n+1) - x_d(:,n+1));
    x_d(:,n+1) = normalize(x_d(:,n+1));
    cov_d(:,:,n+1) = (eye(4) - K) * cov_d(:,:,n+1);
end





%% plot part
% State plot
t = 0:dt:tFinal;

plot_figure(t, x_d, cov_d, x_c_real, "discrete");
plot_figure(t, x_c, cov_c, x_c_real, "continuous");
% Trajectory plot
figure;
hold on
track_xd = plot(x_d(1,:), x_d(2,:),'b');
track_xc = plot(x_c(1,:), x_c(2,:),'r');
track_xc_real = plot(x_c_real(1,:), x_c_real(2,:), 'g');

for n = 10:40:size(t,2)
   plot(x_d(1,n), x_d(2,n), 'bo');
   plot(x_c_real(1,n), x_c_real(2,n), 'go');
   
   sigma_position = draw_circle(x_d(1,n), x_d(2,n), cov_d(:,:,n), 'b--');
   draw_circle(x_c(1,n), x_c(2,n), cov_c(:,:,n), 'r--');
   draw_arrow(x_c(:,n), 20, 'r');
   draw_3sigma_arrow(x_c(:,n), cov_d(:,:,n), 'r');
   
   heading_estimation = draw_arrow(x_d(:,n), 20, 'b');
   sigma_heading = draw_3sigma_arrow(x_d(:,n), cov_d(:,:,n), 'b');
   heading_reality = draw_arrow(x_c_real(:,n), 20, 'g');
end

hold off;
title('simulation trajectory')
xlabel('p_x');
ylabel('p_y');

legend([track_xc, track_xd, track_xc_real],...
    'trajectory of continuous','trajectory of discrete', 'trajectory of real');
