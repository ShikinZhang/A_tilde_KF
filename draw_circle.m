function h = draw_circle(cx, cy, r, color)
theta = 0:pi/100:2*pi;
x = r * cos(theta) + cx;
y = r * sin(theta) + cy;
h = plot(x, y, color); 
end