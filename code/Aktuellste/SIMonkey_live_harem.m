%% 0. SIMonkey
clear, clc, close all                        % delete all data

% define some global variables
global gela_nr xpos ypos gender alpha i nearest dom anx dom_avrg anx_avrg outcome vict defe grmr grme field_size spawning_size

%% 1. set inital conditions
%Simulation
num_cycl = 20;                          % number of cycles
dt = 1;                              % pause between each individul/plot updating time
mode = 'all';                           % decide how the mainplot shall be ploted
                                        % 'none'         - no plots at all during loop
                                        % 'all'          - plot every interaction
%World
field_size = 50;                        % size of the world
spawning_size = 30;                     % size of square where geladas are distributed at the beginning

%Gelada Baboons
num_gelas = 12;                         % number of baboons
num_males = 4;                          % number of males (< num_gelas!!)

xpos = spawning_size*rand(num_gelas,1)-(spawning_size/2);   % x-positions at the beginning (random, within 'spawning square')
ypos = spawning_size*rand(num_gelas,1)-(spawning_size/2);   % y-positions at the beginning (random, within 'spawning square')

view_dist = 50;                         % a baboons viewing distance
perspace = 8;                           % a baboons close encounter distance (interaction only happens if other baboon is within this distance)
interact_dist = 1;                      % distance between two geladas when they interact (upon interaction they approach each other to this distance)
flee_dist = 4;                          % fleeing_distance after losing fight
mov_dist = 3;                           % distance of random movement if no one in sight

dom = 0.7*ones(num_gelas,1);            % initial values of dominance
dom_dcr = 0.01;                         % percentual decrease in dominance when gelada does not interact (default: 1%)
dom_min = 0.001;                        % minimum of a geladas dominance

anx = 0.5*ones(num_gelas,1);            % initial values of anxiety
anx_inc = 0.01;                         % percentual increase in anxiety after every activation (default: 1%)
anx_inc_fight = 0.15;                   % absolute increase in anxiety after fight
anx_dcr_grmr = 0.1;                     % absolute increase in anxiety after grooming another monkey;
anx_dcr_grme = 0.15;                    % absolute increase in anxiety after being groomed by another monkey;
anx_min = 0.001;                        % minimum of a geladas anxiety

%% 2. set auxiliary variables (Hilfsvariablen)
gela_nr = (1:num_gelas)';               % baboon numbering
just_interacted = zeros(num_gelas,1);   % a geladas memory (it remembers for one cycle with whom it just interacted, to avoid several interactions with the same gelada)
outcome = zeros(num_gelas,1);           % 1 - winner, 2 - loser, 3 - groomee, 4 - groomer, 5 - searching, 6 - resting
alpha = 0;                              % index of the baboon that is the alpha-male
gender = zeros(num_gelas,1);            % gender vector ->  1) set all to zero
ix = randperm(numel(gender));           %                   2) randomize the linear indices
ix = ix(1:num_males);                   %                   3) select the first 
gender(ix) = 1;                         %                   4) set the corresponding positions to 1

%Statistics
partn = zeros(num_gelas);               % list of interaction partners
vict = zeros(num_gelas,1);              % list of victories fights per baboon
defe = zeros(num_gelas,1);              % list of defeats fights per baboon
grmr = zeros(num_gelas,1);              % list of "groomed" per baboon
grme = zeros(num_gelas,1);              % list of "was groomed" per baboon
dom_sum = zeros(num_gelas,1);           % sum of all dominances over n cycles
dom_avrg = zeros(num_gelas,1);          % each individual's average of dominance
anx_sum = zeros(num_gelas,1);           % sum of all anxieties over n cycles
anx_avrg = zeros(num_gelas,1);          % each individual's average of anxiety

%% 3. Main loop
% iterate time variable, loop over cycles
for n = 1:num_cycl  
    % iterate over all baboons
    for i = 1:num_gelas     % i = 'active baboon'
        %% 5. find individual for interaction
        nearest = 0;   % nearest OTHER baboon
        nearest_dist = view_dist;    % view is just an auxilary value needed for the following if condition, till a baboon is found
        nearest_male = 0;
        nearest_male_dist = view_dist;   % view is just an auxilary value needed for the following if condition, till a baboon is found
        
        % scan over all baboons
        for j = 1:num_gelas             
            % find individual that is: within my view & nearer to me than the others  & not me &  I did not interact with in the last round                                   
            if (dist(xpos,ypos,i,j) < view_dist && dist(xpos,ypos,i,j) < nearest_dist && (j ~= i) && (just_interacted(i) ~= j) && (just_interacted(j) ~= i))
                nearest = j;   % set found individual to nearest baboon
                nearest_dist = dist(xpos,ypos,i,j);   % set distance to found individual to new 'nearest distance'
            end
            
            % for alpha-male: it seeks the nearest other MALE to fight it
            if (alpha == i && gender(j) == 1 && dist(xpos,ypos,i,j) < view_dist && dist(xpos,ypos,i,j) < nearest_male_dist && (j ~= i))
                nearest_male = j;   % set found individual to nearest baboon
                nearest_male_dist = dist(xpos,ypos,i,j);   % set distance to found individual to new 'nearest distance'
            end
        end
        
        %if the alpha male found another male within it's view it's gonna fight with this one
        if (nearest_male ~= 0)
        nearest = nearest_male;
        nearest_dist = nearest_male_dist;
        end
        
        % If a partner was found, interactions starts (6.1), else no interaction happens (6.2)
        if (nearest ~= 0)
            %% 6. interaction (a partner was found)
            if (nearest_dist <= perspace)   %it is near enough
                %% 6.1 go to other baboon
                % Statistics
                partn(i,nearest) = partn(i,nearest)+1;    % list partners
                
                % plot
                outcome(i)=0; 
                plotmnpl(mode, dt);
                
                % 'i' moves to neighbour up to 'interact_dist'
                xpos(i) = x_move_to_individual(xpos(i),ypos(i),xpos(nearest),ypos(nearest),interact_dist);
                ypos(i) = y_move_to_individual(xpos(i),ypos(i),xpos(nearest),ypos(nearest),interact_dist);
                
                % plot
                plotmnpl(mode, dt);
                 
                % shall i fight or groom? If following condition is true -> fight (chances of winning are estimated on the basis of the strengths (dom values))
                if (dom(i)/(dom(i)+dom(nearest)) >= rand)
                    %%  6.1.1 fight
                    % Attack
                    if dom(i)/(dom(i)+dom(nearest)) >= rand    % if true -> i = winner
                        % i = winner | nearest = loser
                        outcome(i) = 1;                             % outcome(i,n) = 1;
                        %outcome(nearest) = 2;                  % outcome(o+i*num_gelas,n) = 0;
                        winner = i;
                        loser = nearest;    
                    else
                        % i = loser | nearest = winner
                        outcome(i) = 2;
                        winner = nearest;
                        loser = i;
                    end
                    
                    % plot outcome
                    plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest,outcome(i));
                    
                    % -> winner stays, loser flees in random direction
                    rnd_direction = rand;
                    xpos(loser) = move_away_random(xpos(loser),flee_dist,cos(2*pi*rnd_direction));
                    ypos(loser) = move_away_random(ypos(loser),flee_dist,sin(2*pi*rnd_direction));
                    
                    % Statistics (increment victories/defeats)
                    vict(winner) = vict(winner)+1;
                    defe(loser) = defe(loser)+1;
                    
                    % Write new dominances
                    stepdom = rand;     % represents intensity of interaction
                    dom(winner) = dom(winner)+(outcome(i)-(dom(winner)/(dom(winner)+dom(loser))))*stepdom;
                    dom(loser) = dom(loser)-(outcome(i)-(dom(loser)/(dom(winner)+dom(loser))))*stepdom;
                    
                    % anxiety of both geladas grows because of the fight
                    anx(i) = anx(i)+anx_inc_fight;
                    anx(nearest) = anx(nearest)+anx_inc_fight;
                    
                    % gelada i remembers whith whom he just interacted
                    just_interacted(i) = nearest; 
                else
                    % 6.1.1 no fight
                    % shall i groom? (only groom if anxiety bigger than random value & own dominance is lower than the other one's is)
                    if (anx(i) >= rand && dom(i) <= dom(nearest))
                        %% 6.1.2 grooming
                        % Groom (i = groomer | nearest = groomee)
                        outcome(i) = 4;
                       
                        % write new anxieties
                        anx(i) = anx(i)-anx_dcr_grmr;
                        anx(nearest) = anx(nearest)-anx_dcr_grme;
                        
                        %Gelada i remembers whith whom he just interacted
                        just_interacted(i) = nearest;
                        
                        % Statistics
                        % increment groomer/groomee
                        grmr(i) = grmr(i)+1;
                        grme(nearest) = grme(nearest)+1;   
                    else
                        % 6.1.2 no grooming
                        % the other one is higher rank or anxiety is not high enough -> do nothing
                        outcome(i) = 6; 
                    end
                end
            else
                % move towards the found individual
                outcome(i) = 5;
                
                % move 1 step (mov_dist) towards nearest neighbour
                remain_distance = dist(xpos,ypos,i,nearest)-mov_dist;
                xpos(i) = x_move_to_individual(xpos(i),ypos(i),xpos(nearest),ypos(nearest),remain_distance);
                ypos(i) = y_move_to_individual(xpos(i),ypos(i),xpos(nearest),ypos(nearest),remain_distance);
                
                % decrement dominance by not being active
                dom(i) = dom(i)-dom_dcr*dom(i);  
            end
        else
            %% 6.2 no interaction (do a random move)
            outcome(i) = 5;

            % move randomly
            rnd_direction = rand;   % define random variable
            xpos(i) = move_away_random(xpos(i),mov_dist,cos(2*pi*rnd_direction));
            ypos(i) = move_away_random(ypos(i),mov_dist,sin(2*pi*rnd_direction));
            
            % decrement dominance by not being active
            dom(i) = dom(i)-dom_dcr*dom(i);
        end
        
         % each individual checks if it's the strongest -> and if so, gets the alpha-animal
        if dom(i) == max(dom);
        alpha = i;
        end
        
        % Anxiety increases anyway after each cycle
        anx(i) = anx(i)+anx(i)*anx_inc;
        % set minimum of dominance/anxiety
        dom(i) = setminof(dom(i),dom_min);
        anx(i) = setminof(anx(i),anx_min);
        if (nearest ~= 0)
            dom(nearest) = setminof(dom(nearest),dom_min);
            anx(nearest) = setminof(anx(nearest),anx_min);
        end
        
        % Statistics
        % calculate averages of dom / anx
        dom_sum = dom_sum+dom;                 % sum over baboons and cycles
        dom_avrg = dom_sum/((n-1)*num_gelas+i);   % average over all updates
        anx_sum = anx_sum+anx;                 % sum
        anx_avrg = anx_sum/((n-1)*num_gelas+i);   % average over all updates
        
        % Plot
        plotmnpl(mode,dt)
        plotsbpl(mode,dt/10)
    end
    
% after one round they forget with whom they interacted
just_interacted = zeros(num_gelas,1);

end
