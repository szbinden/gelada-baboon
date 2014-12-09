function [  ] = plotall(xpos,ypos,spawning_size,field_size,gela_nr,i,nearest)
% UNTITLED Summary of this function goes here
% Detailed explanation goes here

% Plot whole Playground
subplot(1,3,1:2);
plot(xpos(:),ypos(:),'.','Color','w');
text(xpos(:),ypos(:),int2str(gela_nr),'Color','k','FontWeight','bold','FontSize',14);
title('GELADA BABOON - PLAYGROUND');
grid on;
%bg = imread('grassland.jpg');  % Plot image as background
%imagesc(bg);
rectangle('Position',[-spawning_size/2,-spawning_size/2,spawning_size,spawning_size]);
%text(-0.6,-0.1,int2str(n));
axis([-(field_size/2) (field_size/2) -(field_size/2) (field_size/2)]);  % set field size
%hold off;

end
