function [  ] = plotall(xpos,ypos,gender,spawning_size,field_size,gela_nr,alpha)
% UNTITLED Summary of this function goes here
% Detailed explanation goes here

% Plot whole Playground
subplot(1,3,1:2);
plot(xpos(1),ypos(1),'.','MarkerSize',40,'Color','w');
hold on;
for j = 1:length(xpos)
    if (gender(j) == 0 && alpha ~= j)                                     % females
      plot(xpos(j),ypos(j),'.','MarkerSize',40,'Color','[1,0.4,0.9]');
    else if (gender(j) ~= 0 && alpha ~= j)                  % normal males
      plot(xpos(j),ypos(j),'.','MarkerSize',40,'Color','[0.1,0.3,0.8]');
        else                                                % alpha male
        plot(xpos(j),ypos(j),'.','MarkerSize',40,'Color','[1,0.8,0.4]');    
      
        end
    end
end
%hold off;
text(xpos(:),ypos(:),num2str(gela_nr),'VerticalAlignment','bottom', 'HorizontalAlignment','left','Color','k','FontSize',14);           %'FontWeight','bold',
title('GELADA BABOON - PLAYGROUND');
grid on;
%bg = imread('grassland.jpg');  % Plot image as background
%imagesc(bg);
rectangle('Position',[-spawning_size/2,-spawning_size/2,spawning_size,spawning_size]);
%text(-0.6,-0.1,int2str(n));
axis([-(field_size/2) (field_size/2) -(field_size/2) (field_size/2)]);  % set field size
hold off;

end
