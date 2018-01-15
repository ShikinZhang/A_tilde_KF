function h = draw_circle(cx, cy, cov, color)
theta = 0:pi/100:2*pi;


r1 = sqrt(cov(1,1)) * 3;
r2 = sqrt(cov(2,2)) * 3;

x = r1 * cos(theta) + cx;
y = r2 * sin(theta) + cy;
h = plot(x, y, color);  
end