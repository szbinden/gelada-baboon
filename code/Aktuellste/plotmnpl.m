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
        if gender(j) == 0                       % females
            plot(xpos(j),ypos(j),'.','MarkerSize',40,'Color','m')
            if alpha == j
                plot(xpos(j),ypos(j),'.','MarkerSize',30,'Color','k')
            end
        else
            plot(xpos(j),ypos(j),'.','MarkerSize',40,'Color','b')% males
            if alpha == j
                plot(xpos(j),ypos(j),'.','MarkerSize',30,'Color','k')
            end
        end
    end
    text(xpos(:),ypos(:),num2str(gela_nr),'VerticalAlignment','bottom','HorizontalAlignment','left','Color','k','FontSize',14)
    text(-spawning_size/2-1,-spawning_size/2-1,num2str(i))
    title('GELADA BABOON - PLAYGROUND');
    rectangle('Position',[-spawning_size/2,-spawning_size/2,spawning_size,spawning_size]);
    axis([-(field_size/2) (field_size/2) -(field_size/2) (field_size/2)]);  % set field size
   
    %Mark interacting Geladas with color
    
    % i loses, nearest wins
    if outcome(i) == 0
        plot(xpos(i),ypos(i),'.','MarkerSize',25,'MarkerEdgeColor','r')
        plot(xpos(nearest),ypos(nearest),'.','MarkerSize',25,'MarkerEdgeColor','g')
    % i wins, nearest loses
    elseif outcome(i) == 1
        plot(xpos(i),ypos(i),'.','MarkerSize',25,'MarkerEdgeColor','g');
        plot(xpos(nearest),ypos(nearest),'.','MarkerSize',25,'MarkerEdgeColor','r')
    % nearest wins, i looses
    elseif outcome(i) == 2
        plot(xpos(i),ypos(i),'.','MarkerSize',25,'MarkerEdgeColor',[0,1,1]);
        plot(xpos(nearest),ypos(nearest),'.','MarkerSize',25,'MarkerEdgeColor',[255,105,0]/255)
    % no fighting/no grooming
    elseif outcome(i) == 3
        plot(xpos(i),ypos(i),'.','MarkerSize',25,'MarkerEdgeColor','w')
    % i moves one step towards nearest
    elseif outcome(i) == 4
        plot(xpos(i),ypos(i),'.','MarkerSize',25,'MarkerEdgeColor','y')
    % i moves randomly
    elseif outcome(i) == 5
        plot(xpos(i),ypos(i),'.','MarkerSize',25,'MarkerEdgeColor','y')
    % inital/final plot
    elseif outcome(i) == 6
       % no additional colors 
    % partners
    else
        plot(xpos(i),ypos(i),'.','MarkerSize',25,'MarkerEdgeColor','y');
        plot(xpos(nearest),ypos(nearest),'.','MarkerSize',25,'MarkerEdgeColor','y')
    end
    set(gca,'Color',[0.95 0.95 0.95])
    hold off
    pause(dt)
end


