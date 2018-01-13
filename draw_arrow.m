function h = draw_arrow(state, length, color)
cx = state(1);
cy = state(2);
phi_x = state(3);
phi_y = state(4);
x = [cx cx+length*phi_x];
y = [cy cy+ length*phi_y];

h = plot(x,y,color,'linewidth',2);
end