dist = 1
rnd = rand

x = 1;
y = 1;



x_new = x_move_away_random(x,dist,rnd)
y_new = y_move_away_random(y,dist,rnd)

x_c = [x,x_new];
y_c = [y,y_new];
plot(x_c,y_c,'color','r')

hold on;
t = linspace(0,2*pi);
plot(cos(t)+1,sin(t)+1)
plot(1,1)