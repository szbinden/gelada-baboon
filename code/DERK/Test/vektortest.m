x_i=2;
y_i=1;
x_j=5;
y_j=2;
interact_dist=0.1;
dist = norm([x_j,y_j]-[x_i,y_i]);

pause(3);
x_i = x_move_to_individual(x_i,y_i,x_j,y_j,interact_dist);
y_i = y_move_to_individual(x_i,y_i,x_j,y_j,interact_dist);

