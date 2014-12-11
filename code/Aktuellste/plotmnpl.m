function [  ] = plotmnpl( mode,dt )
%UNTITLED Summory of this function goes here
%   Detailed explanation goes here
global gela_nr xpos ypos gender alpha i nearest spawning_size field_size outcome

if strcmp(mode,'none')
    % no ploting during loops
else
    strcmp(mode,'all')
    
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
    
    %Mark interacting Geladas with color
    % interacting
    if outcome(i) == 0
        hold on;
        plot(xpos(i), ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','y');
        plot(xpos(nearest), ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor','y');
        hold off;
        
        % i wins, nearest_gelada looses
    elseif outcome(i) == 1
        hold on;
        plot(xpos(i), ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','g');
        plot(xpos(nearest), ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor','r');
        hold off;
        
        % nearest wins, i looses
    elseif outcome(i) == 2
        hold on;
        plot(xpos(i), ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','r');
        plot(xpos(nearest), ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor','g');
        hold off;
        
        % i grooms nearest
    elseif outcome(i) == 3
        hold on;
        plot(xpos(nearest), ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor','[0.5,0.1,0.9]');
        plot(xpos(i), ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','[0.7,0.5,1]');
        hold off;
        
        % nearest grooms i
    elseif outcome(i) == 4
        hold on;
        plot(xpos(i), ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','[0.5,0.1,0.9]');
        plot(xpos(nearest), ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor','[0.7,0.5,1]');
        hold off;
        
        % doing a random walk
    elseif outcome(i) == 5
        hold on;
        plot(xpos(i), ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','b');
        hold off;
        
    else
        %do nothing
    end
    
    pause(dt)
    
end


