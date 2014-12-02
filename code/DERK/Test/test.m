% 0. SIMonkey
%clear all, clc                          % delete all data

field_size = 1.5;        
num_gelas = 2;   

gela_nr = (1:num_gelas)'; 

%xpos = rand(num_gelas,1);               % x-position
%ypos = rand(num_gelas,1);               % y-position

xpos = [0.25,0.75];               % x-position
ypos = [0.25,0.75]; 
n=1;
xpos(2)=xpos(2)+x_move_to_individual(xpos(2),ypos(2),xpos(1),ypos(1),0.25);
ypos(2)=ypos(2)+y_move_to_individual(xpos(2),ypos(2),xpos(1),ypos(1),0.25);
% 4. position plot of all gelada by their number (live)
        
        plot(xpos(:),ypos(:),'.','Color','w')
        grid on
        rectangle('Position',[0,0,1,1])
        text(-0.6,-0.1,int2str(n))
        axis([-field_size+1 field_size -field_size+1 field_size]);  % set field size
        text(xpos(:),ypos(:),int2str(gela_nr),'FontSize',14)
        title('GELADA BABOON - PLAYGROUND')
 
%w = waitforbuttonpress;
%waitfor(w);



xpos(1)=xpos(1)+x_move_to_individual(xpos(1),ypos(1),xpos(2),ypos(2),0.25);
ypos(1)=ypos(1)+y_move_to_individual(xpos(1),ypos(1),xpos(2),ypos(2),0.25);





