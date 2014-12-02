field_size = 2;                         % size of the world
spawning_size = 1; 
num_gelas = 3;  
gela_nr = (1:num_gelas)'; 
i = 1;
nearest_gela = 2;
interact_dist=0.05;

dt = 0.5;

xpos = spawning_size*rand(num_gelas,1)-(spawning_size/2);   % x-positions at the beginning
ypos = spawning_size*rand(num_gelas,1)-(spawning_size/2);

%Plot whole Playground
subplot(1,3,1:2);
plot(xpos(:),ypos(:),'.','Color','k');
title('GELADA BABOON - PLAYGROUND');
grid on;
rectangle('Position',[-spawning_size/2,-spawning_size/2,spawning_size,spawning_size]);
%text(-0.6,-0.1,int2str(n));
axis([-(field_size/2) (field_size/2) -(field_size/2) (field_size/2)]);                  % set field size
text(xpos(:),ypos(:),int2str(gela_nr),'FontSize',14);

%hold off;
pause(1);
plotall(xpos,ypos,spawning_size,field_size,gela_nr,i,nearest_gela,1,dt);

xpos(i) = xpos(i)+x_move_to_individual(xpos(i),ypos(i),xpos(nearest_gela),ypos(nearest_gela),interact_dist);
ypos(i) = ypos(i)+y_move_to_individual(xpos(i),ypos(i),xpos(nearest_gela),ypos(nearest_gela),interact_dist);

plotall(xpos,ypos,spawning_size,field_size,gela_nr,i,nearest_gela,1,dt);

pause(1);

plotall(xpos,ypos,spawning_size,field_size,gela_nr,i,nearest_gela,1,dt);
