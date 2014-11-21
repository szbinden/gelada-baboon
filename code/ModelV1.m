%clear old data
clc;
clear all;

% parameters for the World
height = 200;       % dimension of the world in y
width = 200;        % dimension of the world in x
t0 = 0;             % initial time
dt = 1;             % size of timesteps
T = 0;              % # of timesteps
% N = 12;           % # of agents

% parameters for the agents/monkeys
MaxView = 50;
StepSize = 30;      % Step size for random step if no neighbour near enough

% initial state of the 12 agents
dom0 = [16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 32, 32];
anx0 = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, ];
posX_0 = width*rand(1,12);
posY_0 = height*rand(1,12);

%MAIN-PROGRAM:

% state of the agents (theese are modified by the program!)
dom = dom0;
anx = anx0;
posX = posX_0;
posY = posY_0;
Name = ['1','2','3','4','5','6','7','8','9','10','11','12'];
scatter(posX, posY);


for t=t0:dt:T
%timeloop (current time is time t)
    for i=1:length(posX_0)
    %agents loop (current agent is agent i)
        
        %find nearest neighbour (nearest neighbour is called nearest_agent)
        nearest_agent = 0;
        nearest_dist = 1000;
        for j=1:length(posX_0)
            if (j~=i)
                if ( dist(posX(i),posY(i),posX(j),posY(j)) < nearest_dist)
                nearest_dist = dist(posX(i),posY(i),posX(j),posY(j));
                nearest_agent = j;
                end
            end
        end
                
        %decide if agent i is near enough nearest_agent for an interaction
        %and perform random step if not
        if dist(posX(i),posY(i),posX(nearest_agent),posY(nearest_agent)) > MaxView
            
            %perform random step
            direction = rand(1,1);
            posX(i) = posX(i) + StepSize*cos(2*pi*direction);
            posY(i) = posY(i) + StepSize*sin(2*pi*direction);
            
            %Display that the agent did a random step
            DispRand =['Distance to next neighbour is too big! Agent ',num2str(i),' performed a random step'];
            disp(DispRand);
         
        else
            %Display that the agents are interacting
            DispInter = ['Agent ',num2str(i),' interacts with agent ',num2str(nearest_agent)];
            disp(DispInter);
            
            %INTERACTION
            %interaction between 'i' and 'nearest_agent' & update data
            %
            %
            %
            %
            
        end
    end  
end
