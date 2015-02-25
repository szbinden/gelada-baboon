%% 0. SIMonkey
clear, clc, close all                        % delete all data

% define some global variables
global gela_nr xpos ypos gender alpha i nearest dom anx dom_avrg anx_avrg outcome vict defe grmr grme field_size spawning_size

%% 1. set inital conditions
% simulation
num_cycl = 200;                         % number of cycles
dt = 0.5;                            % pause between each individul/plot updating time
mode = 'all';                          % decide how the mainplot shall be ploted
                                        % 'none'         - no plots at all during loop
                                        % 'all'          - plot every interaction
% world
field_size = 50;                        % size of the world
spawning_size = 30;                     % size of square where geladas are distributed at the beginning

% gelada Baboons
num_gelas = 16;                         % number of baboons
num_males = 4;                          % number of males (< num_gelas!!)

xpos = spawning_size*rand(num_gelas,1)-(spawning_size/2);   % x-positions at the beginning (random, within 'spawning square')
ypos = spawning_size*rand(num_gelas,1)-(spawning_size/2);   % y-positions at the beginning (random, within 'spawning square')

view_space = 16;                        % a baboons viewing space
interaction_space = 8;                  % a baboons close encounter distance (interaction only happens if other baboon is within this distance)
interact_dist = 1;                      % distance between two geladas when they interact (upon interaction they approach each other to this distance)
flee_dist = 8;                          % fleeing_distance after losing fight
mov_dist = 4;                           % distance of random movement if no one in sight

dom = 0.25*ones(num_gelas,1);            % initial values of dominance
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

alpha = 0;                              % index of the baboon that is the alpha-male
gender = zeros(num_gelas,1);            % gender vector ->  1) set all to zero
ix = randperm(numel(gender));           %                   2) randomize the linear indices
ix = ix(1:num_males);                   %                   3) select the first 
gender(ix) = 1;                         %                   4) set the corresponding positions to 1
dom(ix) = 0.8;
anx(ix) = 0.3;

% Statistics
partn = zeros(num_gelas);               % list of interacting partners

outcome = 6*ones(num_gelas,1);          % outcome:
vict = zeros(num_gelas,1);              %   1       - list of victories per baboon
defe = zeros(num_gelas,1);              %   0       - list of defeats per baboon
grmr = zeros(num_gelas,1);              %   2       - list of "groomed" per baboon
grme = zeros(num_gelas,1);              %   -       - list of "was groomed" per baboon
noin = zeros(num_gelas,1);              %   5       - list of "not interacted" per baboon
rest = zeros(num_gelas,1);              %   3       - list of "rested" per baboon
walk = zeros(num_gelas,1);              %   4       - list of "walked" per baboon

dom_sum = dom;                          % sum of all dominances over n cycles
dom_avrg = dom;                         % each individual's average of dominance
anx_sum = anx;                          % sum of all anxieties over n cycles
anx_avrg = anx;                         % each individual's average of anxiety

% initial plot
plotmnpl('all',0.001)
plotsbpl('all',0.001)
pause(3)
%% 3. Main loop
% iterate time variable, loop over cycles
for n = 1:num_cycl  
    % iterate over all baboons
    for i = 1:num_gelas     % i = 'active baboon'        
        %% 5. find individual for interaction
        nearest = 0;   % nearest OTHER baboon
        nearest_dist = view_space;          % view is just an auxilary value needed for the following if condition, till a baboon is found
        nearest_male = 0;
        nearest_male_dist = view_space;     % view is just an auxilary value needed for the following if condition, till a baboon is found
        
        % scan over all baboons
        for j = 1:num_gelas             
            % find individual that is: within my view, not me &  I did not interact with in the last round                                   
            if dist(xpos,ypos,i,j) < nearest_dist && (j ~= i) && (just_interacted(i) ~= j) && (just_interacted(j) ~= i)
                nearest = j;   % set found individual to nearest baboon
                nearest_dist = dist(xpos,ypos,i,j);         % set distance to found j to new 'nearest distance'
            end
            
            % for males: they seek the nearest other MALE to fight it
            if alpha == i && gender(j) == 1 && dist(xpos,ypos,i,j) < nearest_male_dist && (j ~= i)
                nearest_male = j;   % set found individual to nearest baboon
                nearest_male_dist = dist(xpos,ypos,i,j);    % set distance to found j to new 'nearest male distance'
            end
        end
        
        %if the alpha male found another male within it's view it's gonna interact with this one
        if (nearest_male ~= 0)
        nearest = nearest_male;
        nearest_dist = nearest_male_dist;
        end
        
        % If a partner was found, interactions starts (6.1), else no interaction happens (6.2)
        if (nearest ~= 0)
            %% 6. interaction (a partner was found)
            if (nearest_dist <= interaction_space)          %it is near enough
                %% 6.1 go to other baboon
                % Statistics
                partn(i,nearest) = partn(i,nearest)+1;      % list partners
                
                % plot
                outcome(i) = rand; 
                plotmnpl(mode, dt);
                
                % 'i' moves to neighbour up to 'interact_dist'
                xpos(i) = moveto(xpos(i),xpos(nearest),nearest_dist,interact_dist);
                ypos(i) = moveto(ypos(i),ypos(nearest),nearest_dist,interact_dist);
                
                % plot
                plotmnpl(mode, dt);
                 
                % shall i fight or groom?
                % if true -> fight (chances of winning are estimated on the basis of own relative dominances)
                if (gender(i) == 1 && gender(nearest) == 1 && dom(i)/(dom(i)+dom(nearest)) >= rand) ||...
                        (dom(i)/(dom(i)+dom(nearest)) >= rand && dom(i)/(dom(i)+dom(nearest)) >= rand)
                    %%  6.1.1 fight
                    % Attack
                    % i = winner | nearest = loser   
                    if dom(i)/(dom(i)+dom(nearest)) >= rand                                                       
                        winner = i;
                        loser = nearest;    
                    else
                        winner = nearest;
                        loser = i;
                    end
                    outcome(winner) = 1;
                    outcome(loser) = 0;
                    
                    % Statistics (increment victories/defeats)
                    vict(winner) = vict(winner)+1;
                    defe(loser) = defe(loser)+1;
                    
                    % Write new dominances
                    % represents intensity of interaction
                    dom_step = rand;
                    % dominance changes for the same amount
                    dom_t = (outcome(winner)-(dom(winner)/(dom(winner)+dom(loser))))*dom_step;
                    dom(winner) = dom(winner)+dom_t;
                    dom(loser) = dom(loser)-dom_t;
                    % anxiety grows anyway because of the fight
                    anx(winner) = anx(winner)+anx_inc_fight;
                    anx(loser) = anx(loser)+anx_inc_fight;
                    
                    % winner stays
                    rnd_direction = rand;
                    % loser of male-male fight flees
                    if (alpha == winner && gender(loser) == 1) || (alpha == loser && gender(winner) == 1)
                        xpos(loser) = move(xpos(winner),2*flee_dist,cos(2*pi*rnd_direction));
                        ypos(loser) = move(ypos(winner),2*flee_dist,sin(2*pi*rnd_direction));
                    elseif gender(winner) == 1 && gender(loser) == 1
                        xpos(loser) = move(xpos(winner),flee_dist,cos(2*pi*rnd_direction));
                        ypos(loser) = move(ypos(winner),flee_dist,sin(2*pi*rnd_direction));
                    % loser of other fights flee
                    else
                        xpos(loser) = move(xpos(winner),flee_dist*dom_step,cos(2*pi*rnd_direction));
                        ypos(loser) = move(ypos(winner),flee_dist*dom_step,sin(2*pi*rnd_direction));
                    end
                    
                    % gelada i remembers whith whom he just interacted
                    just_interacted(i) = nearest; 
                else
                    % 6.1.1 no fight
                    % shall i groom? (only groom if anxiety bigger than random value & own dominance is lower than the other one's is)
                    if (anx(i) >= rand && dom(i) <= dom(nearest))
                        %% 6.1.2 grooming
                        % Groom (i = groomer | nearest = groomee)
                        outcome(i) = 2;
                        grmr(i) = grmr(i)+1;
                        grme(nearest) = grme(nearest)+1;
                        
                        % write new anxieties
                        anx(i) = anx(i)-anx_dcr_grmr;
                        anx(nearest) = anx(nearest)-anx_dcr_grme;
                        
                        % gelada i remembers whith whom he just interacted
                        just_interacted(i) = nearest;   
                    else
                        % 6.1.2 no grooming
                        % the other one is higher rank or anxiety is not high enough -> do nothing
                        outcome(i) = 3;
                        rest(i) = rest(i)+1;
                        noin(nearest) = noin(nearest)+1;
                    end
                end
            else
                outcome(i) = 4;
                walk(i) = walk(i)+1;
                noin(nearest) = noin(nearest)+1;
                
                % move one step (mov_dist) towards nearest neighbour
                xpos(i) = moveto(xpos(i),xpos(nearest),nearest_dist,nearest_dist-mov_dist);
                ypos(i) = moveto(ypos(i),ypos(nearest),nearest_dist,nearest_dist-mov_dist); 
            end
        else
            %% 6.2 no interaction (do a random move)
            outcome(i) = 5;
            noin(i) = noin(i)+1;
            
            % move randomly
            rnd_direction = rand;       % define random variable
            xpos(i) = move(xpos(i),mov_dist,cos(2*pi*rnd_direction));
            ypos(i) = move(ypos(i),mov_dist,sin(2*pi*rnd_direction));
            
            % decrement dominance by not being active
            dom(i) = dom(i)-dom_dcr*dom(i);
        end
        % each individual checks if it's the strongest -> and if so, gets the alpha-animal
        if dom(i) == max(dom)
            alpha = i;
        elseif nearest ~= 0 && dom(nearest) == max(dom)
            alpha = nearest;
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
        
        % statistics
        % calculate average of dominance/anxiety
        if outcome(i) == 0 || outcome(i) == 1 || outcome(i) == 5
            dom_sum(i) = dom_sum(i)+dom(i);
            dom_avrg(i) = dom_sum(i)/(1+vict(i)+defe(i)+noin(i));
        end
        anx_sum(i) = anx_sum(i)+anx(i); 
        anx_avrg(i) = anx_sum(i)/(1+vict(i)+defe(i)+grmr(i)+grme(i)+rest(i)+walk(i)+noin(i));
        if nearest ~= 0
            if outcome(nearest) == 0 || outcome(i) == 1
                dom_sum(nearest) = dom_sum(nearest)+dom(nearest);
                dom_avrg(nearest) = dom_sum(nearest)/(1+vict(nearest)+defe(nearest)+noin(nearest));
            end
            anx_sum(nearest) = anx_sum(nearest)+anx(nearest); 
            anx_avrg(nearest) = anx_sum(nearest)/(1+vict(nearest)+defe(nearest)+grmr(nearest)+grme(nearest)+rest(nearest)+walk(nearest)+noin(nearest));
        end
        
        % updated plot
        plotmnpl(mode,dt)
        plotsbpl(mode,dt/10)
    end
    
% after one round they forget with whom they interacted
just_interacted = zeros(num_gelas,1);

end

% final plot
outcome(i) = 6;
plotmnpl('all',dt)
plotsbpl('all',dt/10)