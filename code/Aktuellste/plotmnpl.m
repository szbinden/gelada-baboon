function [  ] = plotmnpl( mode,dt )
%UNTITLED Summory of this function goes here
%   Detailed explanation goes here
global gela_nr xpos ypos gender alpha i nearest spawning_size field_size outcome

if strcmp(mode,'none')
    % no ploting during loops
else    
    subplot(1,3,1:2)
    plot(xpos(1),ypos(1),'.','MarkerSize',40,'Color','w')
    hold on, grid on
    for j = 1:length(xpos)
        if (gender(j) == 0 && alpha ~= j)                       % females
            plot(xpos(j),ypos(j),'.','MarkerSize',40,'Color','m')
        else
            if (gender(j) ~= 0 && alpha ~= j)                  % males
                plot(xpos(j),ypos(j),'.','MarkerSize',40,'Color','b')
            else                                                % alpha male
                plot(xpos(j),ypos(j),'.','MarkerSize',40,'Color','k')
            end
        end
    end
    text(xpos(:),ypos(:),num2str(gela_nr),'VerticalAlignment','bottom','HorizontalAlignment','left','Color','k','FontSize',14)
    title('GELADA BABOON - PLAYGROUND');
    rectangle('Position',[-spawning_size/2,-spawning_size/2,spawning_size,spawning_size]);
    axis([-(field_size/2) (field_size/2) -(field_size/2) (field_size/2)]);  % set field size
   
    %Mark interacting Geladas with color
    % interacting
    if outcome(i) == 0
        plot(xpos(i),ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','y');
        plot(xpos(nearest),ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor','y')
    % i wins, nearest_gelada looses
    elseif outcome(i) == 1
        plot(xpos(i),ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','g');
        plot(xpos(nearest),ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor','r')
    % nearest wins, i looses
    elseif outcome(i) == 2
        plot(xpos(i),ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','r')
        plot(xpos(nearest),ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor','g')
    % i grooms nearest
    elseif outcome(i) == 4
        plot(xpos(i),ypos(i),'.','MarkerSize',30,'MarkerEdgeColor',[0,1,1]);
        plot(xpos(nearest),ypos(nearest),'.','MarkerSize',30,'MarkerEdgeColor',[255,105,0]/255)
    % doing a random walk
    elseif outcome(i) == 5
        plot(xpos(i),ypos(i),'.','MarkerSize',30,'MarkerEdgeColor','b')
    end
    set(gca,'Color',[0.95 0.95 0.95])
    hold off
    pause(dt)
end


