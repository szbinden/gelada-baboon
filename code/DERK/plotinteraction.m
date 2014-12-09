function [  ] = plotinteraction(xpos,ypos,spawning_size,field_size,gela_nr,i,nearest,interact_type)
% UNTITLED Summary of this function goes here
% Detailed explanation goes here

% Plot whole Playground
subplot(1,3,1:2);
plot(xpos(:),ypos(:),'.','MarkerSize',40,'Color','k');              % ... ,'MarkerFaceColor','k');
text(xpos(:),ypos(:),num2str(gela_nr),'VerticalAlignment','bottom', 'HorizontalAlignment','left','Color','k','FontSize',14);           %'FontWeight','bold',
title('GELADA BABOON - PLAYGROUND');
grid on;
%bg = imread('grassland.jpg');  % Plot image as background
%imagesc(bg);
rectangle('Position',[-spawning_size/2,-spawning_size/2,spawning_size,spawning_size]);
%text(-field_size,-0.1,int2str(n));
axis([-(field_size/2) (field_size/2) -(field_size/2) (field_size/2)]);  % set field size
%hold off;

%Mark interacting Geladas with color
% interacting
if interact_type == 0
    hold on;
    plot(xpos(i), ypos(i),'.','MarkerSize',40,'Color','y');
    plot(xpos(nearest), ypos(nearest),'.','MarkerSize',40,'Color','y');
    hold off;

% i wins, nearest_gelada looses
elseif interact_type == 1
    hold on;
    plot(xpos(i), ypos(i),'.','MarkerSize',40,'Color','g');
    plot(xpos(nearest), ypos(nearest),'.','MarkerSize',40,'Color','r');
    hold off;

% nearest wins, i looses
elseif interact_type == 2
    hold on;
    plot(xpos(i), ypos(i),'.','MarkerSize',40,'Color','r');
    plot(xpos(nearest), ypos(nearest),'.','MarkerSize',40,'Color','g');
    hold off;

% i grooms nearest
elseif interact_type == 3
    hold on;
    plot(xpos(i), ypos(i),'.','MarkerSize',40,'MarkerFaceColor','m');
    plot(xpos(nearest), ypos(nearest),'.','MarkerSize',40,'MarkerFaceColor','c');
    hold off;

% nearest grooms i
elseif interact_type == 4
    hold on;
    plot(xpos(i), ypos(i),'.','MarkerSize',40,'Color','c');
    plot(xpos(nearest), ypos(nearest),'.','MarkerSize',40,'Color','m');
    hold off;
    
% doing a random walk
elseif interact_type == 5
    hold on;
    plot(xpos(i), ypos(i),'.','MarkerSize',40,'Color','b');
    hold off;

else
%do nothing
end

end

