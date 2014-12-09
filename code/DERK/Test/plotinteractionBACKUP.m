function [  ] = plotinteraction(xpos,ypos,spawning_size,field_size,gela_nr,i,nearest,interact_type)
% UNTITLED Summary of this function goes here
% Detailed explanation goes here

% Plot whole Playground
subplot(1,3,1:2);
plot(xpos(:),ypos(:),'.','Color','k');
title('GELADA BABOON - PLAYGROUND');
grid on;
%bg = imread('grassland.jpg');  % Plot image as background
%imagesc(bg);
rectangle('Position',[-spawning_size/2,-spawning_size/2,spawning_size,spawning_size]);
%text(-0.6,-0.1,int2str(n));
axis([-(field_size/2) (field_size/2) -(field_size/2) (field_size/2)]);  % set field size
text(xpos(:),ypos(:),int2str(gela_nr),'FontSize',14);
hold off;

%Mark interacting Geladas with color
% interacting
if interact_type == 0
    text(xpos(i), ypos(i), num2str(i),'Color','y','FontWeight','bold','FontSize',14)
    text(xpos(nearest), ypos(nearest), num2str(nearest),'Color','y','FontWeight','bold','FontSize',14)

% i wins, nearest_gelada looses
elseif interact_type == 1
    text(xpos(i), ypos(i), num2str(i),'Color','g','FontWeight','bold','FontSize',14)
    text(xpos(nearest), ypos(nearest), num2str(nearest),'Color','r','FontWeight','bold','FontSize',14)

% nearest wins, i looses
elseif interact_type == 2
    text(xpos(i), ypos(i), num2str(i),'Color','r','FontWeight','bold','FontSize',14)
    text(xpos(nearest), ypos(nearest), num2str(nearest),'Color','g','FontWeight','bold','FontSize',14)

% i grooms nearest
elseif interact_type == 3
    text(xpos(i), ypos(i), num2str(i),'Color','m','FontWeight','bold','FontSize',14)
    text(xpos(nearest), ypos(nearest), num2str(nearest),'Color','b','FontWeight','bold','FontSize',14)

% nearest grooms i
elseif interact_type == 4
    text(xpos(i), ypos(i), num2str(i),'Color','m','FontWeight','bold','FontSize',14)
    text(xpos(nearest), ypos(nearest), num2str(nearest),'Color','b','FontWeight','bold','FontSize',14)
    
% doing a random walk
elseif interact_type == 5
    text(xpos(i), ypos(i), num2str(i),'Color','c','FontWeight','bold','FontSize',14)

else
%do nothing
end

end

