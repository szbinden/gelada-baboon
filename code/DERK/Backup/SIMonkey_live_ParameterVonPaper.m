%% 0. SIMonkey
clear all, clc                          % delete all data

%% 1. set inital conditions
%Simulation
num_cycl = 20;                          % number of cycles
fast_mode = 1;                          % 1 -> fast mode activated (for investigations of outcome after several timesteps, interactions can't be watched)
                                        % 0 -> fast mode deactivated (interactions can be watched live, takes a very long time for large 'num_cycl'!)
%World
field_size = 50;                        % size of the world
spawning_size = 30;                     % size of square where geladas are distributed at the beginning

%Gelada Baboons
num_gelas = 12;                         % number of baboons
num_males = 4;                          % number of males (< num_gelas!!)
xpos = spawning_size*rand(num_gelas,1)-(spawning_size/2);   % x-positions at the beginning (random, within 'spawning square')
ypos = spawning_size*rand(num_gelas,1)-(spawning_size/2);   % y-positions at the beginning (random, within 'spawning square')
perspace = 8;                           % a baboons close encounter distance (interaction only happens if other baboon is within this distance)
view = 50;                              % a baboons viewing distance
interact_dist = 1;                      % distance between two geladas when they interact (upon interaction they approach each other to this distance)
flee_dist = 3;                          % fleeing_distance after losing fight
mov_dist = 2;                           % distance of random movement if no one in sight
%mov_multip = 0.02;                     % multiplier for moving act
%flee_multip = 0.2;                     % multiplier for fleeing act
%activity = 0.8;                        % baboon's activity
dom = 0.7*ones(num_gelas,1);            % initial values of dominance
dom_dcr = 0.01;                         % percentual decrease in dominance when gelada does not interact (default: 1%)
%stepdom = 0.8;                          % multiplier for changing dominance
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
dt = 0.5;                               % set length of pause after every activation and every plot
if (fast_mode == 1)
    dt = 0.05;    
end

%Statistics
partn = zeros(num_gelas);               % list of interaction partners
vict = zeros(num_gelas,1);              % list of victories fights per baboon
defe = zeros(num_gelas,1);              % list of defeats fights per baboon
grmr = zeros(num_gelas,1);              % list of "groomed" per baboon
grme = zeros(num_gelas,1);              % list of "was groomed" per baboon
noin = zeros(num_gelas,1);              % list of "no interactions"
%outcome = rand((num_gelas+1)*num_gelas,num_cycl);  % interaction matrix
dom_sum = zeros(num_gelas,1);           % sum of all dominances over n cycles
dom_avrg = zeros(num_gelas,1);          % each individual's average of dominance
anx_sum = zeros(num_gelas,1);           % sum of all anxieties over n cycles
anx_avrg = zeros(num_gelas,1);          % each individual's average of anxiety

%if field_size <= 1
%    field_size = 1.01;
%end
%figure

%% 3. Main loop
% iterate time variable, loop over cycles
for n = 1:num_cycl  
    % iterate over all baboons
    for i = 1:num_gelas     % i = 'active baboon'
        %% 4. position plot of all gelada by their number (live)
        plotall(xpos,ypos,gender,spawning_size,field_size,gela_nr,alpha);
        pause(dt);

        %% 5. find individual for interaction
        nearest_gela = 0;   % nearest OTHER baboon
        nearest_dist = view;    % view is just an auxilary value needed for the following if condition, till a baboon is found
        nearest_male = 0;
        nearest_male_dist = view;   % view is just an auxilary value needed for the following if condition, till a baboon is found
        
        % scan over all baboons
        for j = 1:num_gelas             
        % find individual that is: within my view & nearer to me than the others  & not me &  I did not interact with in the last round                                   
            if (dist(xpos,ypos,i,j) < view && dist(xpos,ypos,i,j) < nearest_dist && (j ~= i) && (just_interacted(i) ~= j) && (just_interacted(j) ~= i))
                nearest_gela = j;   % set found individual to nearest baboon
                nearest_dist = dist(xpos,ypos,i,j);   % set distance to found individual to new 'nearest distance'
            end
            %dd(i+(n-1)*num_gelas,j) = nearest_dist;    % DO NOT DELETE
            
            % for alpha-male: it seeks the nearest other MALE to fight it
            if (alpha == i && gender(j) == 1 && dist(xpos,ypos,i,j) < view && dist(xpos,ypos,i,j) < nearest_male_dist && (j ~= i))
                nearest_male = j;   % set found individual to nearest baboon
                nearest_male_dist = dist(xpos,ypos,i,j);   % set distance to found individual to new 'nearest distance'
            end
            
        end
        
        %if the alpha male found another male within it's view it's gonna fight with this one
        if (nearest_male ~= 0)
        nearest_gela = nearest_male;
        nearest_dist = nearest_male_dist;
        end
        
        % If a partner was found, interactions starts (6.1), else no interaction happens (6.2)
        if (nearest_gela ~= 0)
            % a partner was found
            if (nearest_dist <= perspace)
                %it is near enough to interact with
                %% 6.1 interaction
                
                % Statistics
                partn(i,nearest_gela) = partn(i,nearest_gela)+1;    % list partners
                
                % shall i fight or groom? If following condition is true -> fight (chances of winning are estimated on the basis of the strengths (dom values))
                if (dom(i)/(dom(i)+dom(nearest_gela)) >= rand)
                    
                    %%  6.1.1 fight
                    % 'i' moves to neighbour up to 'interact_dist'
                    xpos(i) = x_move_to_individual(xpos(i),ypos(i),xpos(nearest_gela),ypos(nearest_gela),interact_dist);
                    ypos(i) = y_move_to_individual(xpos(i),ypos(i),xpos(nearest_gela),ypos(nearest_gela),interact_dist);
                    
                    % Plot interaction
                    plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,0);
                    pause(dt);
                    %plotinteract2(i, xpos(i),ypos(i),0,'middle');
                    %plotinteract2(nearest_gela, xpos(nearest_gela),ypos(nearest_gela),0,'middle');
                    
                    % Attack
                    if dom(i)/(dom(i)+dom(nearest_gela)) >= rand    % if true -> i = winner
                        % i = winner | nearest_gelada = loser
                        outcome(i) = 1;                             % outcome(i,n) = 1;
                        %outcome(nearest_gela) = 2;                  % outcome(o+i*num_gelas,n) = 0;
                        winner = i;
                        loser = nearest_gela;
                        
                    else
                        % i = loser | nearest_gela = winner
                        outcome(i) = 2;
                        winner = nearest_gela;
                        loser = i;
                    end
                    
                    % plot outcome
                    plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,outcome(i));
                    pause(dt);
                    
                    % -> winner stays, loser flees in random direction
                    rnd_direction = rand;
                    xpos(loser) = move_away_random(xpos(loser),flee_dist,cos(2*pi*rnd_direction));
                    ypos(loser) = move_away_random(ypos(loser),flee_dist,sin(2*pi*rnd_direction));
                    
                    % plot
                    plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,outcome(i));
                    pause(dt);
                    %plotinteract2(i, xpos(i),ypos(i),outcome(i));
                    %plotinteract2(nearest_gela, xpos(nearest_gela),ypos(nearest_gela),outcome(nearest_gela));
                    
                    % Statistics (increment victories/defeats)
                    vict(winner) = vict(winner)+1;
                    defe(loser) = defe(loser)+1;
                    
                    % Write new dominances
                    stepdom = rand;     % represents intensity of interaction
                    dom(winner) = dom(winner)+(outcome(i)-(dom(winner)/(dom(winner)+dom(loser))))*stepdom;
                    dom(loser) = dom(loser)-(outcome(i)-(dom(loser)/(dom(winner)+dom(loser))))*stepdom;
                    
                    % anxiety of both geladas grows because of the fight
                    anx(i) = anx(i)+anx_inc_fight;
                    anx(nearest_gela) = anx(nearest_gela)+anx_inc_fight;
                    % set minimum of anxiety
                    anx(i) = setminof(anx(i),anx_min);
                    anx(nearest_gela) = setminof(anx(nearest_gela),anx_min);
                    
                    % set minimum of dominance
                    dom(i) = setminof(dom(i),dom_min);
                    dom(nearest_gela) = setminof(dom(nearest_gela),dom_min);
                    
                    % gelada i remembers whith whom he just interacted
                    just_interacted(i) = nearest_gela;
                    
                    %Statistics
                    % calculate average dominances
                    dom_sum(i) = dom_sum(i)+dom(i);     % sum over n cycles
                    dom_avrg(i) = dom_sum(i)/n;          % average over n cycles
                    dom_sum(nearest_gela) = dom_sum(nearest_gela)+dom(nearest_gela);
                    dom_avrg(nearest_gela) = dom_sum(nearest_gela)/n;
                    % calculate average anxieties
                    anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
                    anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
                    anx_sum(nearest_gela) = anx_sum(nearest_gela)+anx(nearest_gela);
                    anx_avrg(nearest_gela) = anx_sum(nearest_gela)/n;
                    
                else
                    % 6.1.1 no fight
                    % shall i groom? (yes or no)
                    % only groom if anxiety bigger than random value & own dominance is lower than the other one's is
                    if (anx(i) >= rand && dom(i) <= dom(nearest_gela))
                        %% 6.1.2 grooming
                        % only groom if own dominance is lower than the other one's is
                       
                        % Groom (i = groomer | nearest_gela = groomee)
                        outcome(i) = 4;
                        
                        % plot interaction
                        plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,0);
                        pause(dt);
                        %plotinteract2(i, xpos(i),ypos(i),0,'middle');
                        %plotinteract2(nearest_gela, xpos(nearest_gela),ypos(nearest_gela),0,'middle');
                        
                        % groomer moves next to groomee
                        xpos(i) = x_move_to_individual(xpos(i),ypos(i),xpos(nearest_gela),ypos(nearest_gela),interact_dist);
                        ypos(i) = y_move_to_individual(xpos(i),ypos(i),xpos(nearest_gela),ypos(nearest_gela),interact_dist);
                        %xpos(i) = move(xpos(nearest_gela),0.03,field_size);
                        %ypos(i) = move(ypos(nearest_gela),0.03,field_size);
                        
                        % plot interactions
                        plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,outcome(i));
                        pause(2*dt);
                        %plotinteract2(i,xpos(i),ypos(i),outcome(i),'bottom');
                        %plotinteract2(nearest_gela,xpos(nearest_gela),ypos(nearest_gela),outcome(nearest_gela),'top');
                        
                        % write new anxieties
                        anx(i) = anx(i)-anx_dcr_grmr;
                        anx(nearest_gela) = anx(nearest_gela)-anx_dcr_grme;
                        % set minimum of anxiety
                        anx(i) = setminof(anx(i),anx_min);
                        anx(nearest_gela) = setminof(anx(nearest_gela),anx_min);
                        
                        %Gelada i remembers whith whom he just interacted
                        just_interacted(i) = nearest_gela;
                        
                        % Statistics
                        % increment groomer/groomee
                        grmr(i) = grmr(i)+1;
                        grme(nearest_gela) = grme(nearest_gela)+1;
                        % calculate average anxieties
                        %anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
                        %anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
                        anx_sum(nearest_gela) = anx_sum(nearest_gela)+anx(nearest_gela);
                        anx_avrg(nearest_gela) = anx_sum(nearest_gela)/n;
                            
                    else
                        % 6.1.2 no grooming
                        % the other one is higher rank or anxiety is not high enough
                        % -> do nothing
                        outcome(i) = 6; 
                        
                        %plot interaction
                        %plotinteraction(xpos,ypos,spawning_size,field_size,gela_nr,i,nearest_gela,1);
                        %pause(dt);
                        %plotinteract2(i,xpos(i),ypos(i),outcome(i),'bottom');
                        
                        %Statistics
                        % calculate average anxieties
                        %anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
                        %anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
                        
                    end

                end
            else
                % move towards the found individual
                outcome(i) = 5;
                
                % plot
                plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,0);  % ... ,nearest_gela,outcome(i));
                pause(dt);
                
                % move 1 step (mov_dist) towards nearest neighbour
                remain_distance = dist(xpos,ypos,i,nearest_gela)-mov_dist;
                xpos(i) = x_move_to_individual(xpos(i),ypos(i),xpos(nearest_gela),ypos(nearest_gela),remain_distance);
                ypos(i) = y_move_to_individual(xpos(i),ypos(i),xpos(nearest_gela),ypos(nearest_gela),remain_distance);
                
                % plot
                plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,0);   % ... ,nearest_gela,outcome(i));
                pause(dt);
                
                % decrement dominance by not being active
                dom(i) = dom(i)-dom_dcr*dom(i);
                % set minimum of dominance
                dom(i) = setminof(dom(i),dom_min);
                
            end
        else
            %% 6.2 no interaction
            % do a random move
%             if activity >= rand
                
            outcome(i) = 5;

            % plot
            plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,outcome(i));
            pause(dt);

            % move randomly
            rnd_direction = rand;   % define random variable
            xpos(i) = move_away_random(xpos(i),mov_dist,cos(2*pi*rnd_direction));
            ypos(i) = move_away_random(ypos(i),mov_dist,sin(2*pi*rnd_direction));
            %xpos(i) = move(xpos(i),2*mov_multip,field_size);
            %ypos(i) = move(ypos(i),2*mov_multip,field_size);

            % plot
            plotinteraction(gela_nr,xpos,ypos,gender,alpha,spawning_size,field_size,i,nearest_gela,outcome(i));
            pause(dt);
            %plotinteract2(i,xpos(i),ypos(i),outcome(i),'top');
            
            % decrement dominance by not being active
            dom(i) = dom(i)-dom_dcr*dom(i);
            % set minimum of dominance
            dom(i) = setminof(dom(i),dom_min);

            % Statistics
            % calculate average dominances
            %dom_sum(i) = dom_sum(i)+dom(i);     % sum over n cycles
            %dom_avrg(i) = dom_sum(i)/n;          % average over n cycles
            % calculate average anxieties
            %anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
            %anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
            
%         else
%             % do not do anything
%             outcome(i) = 5;
%             % plot interaction
%             plotinteract(xpos(i),ypos(i),outcome(i),'top');
%             % decrement dominance by not being active
%             dom(i) = dom(i)-stepdom/num_gelas;
%             % set minimum of dominance
%             dom(i) = setminof(dom(i),dom_min);
%             % calculate average dominances
%             dom_sum(i) = dom_sum(i)+dom(i);     % sum over n cycles
%             dom_avrg(i) = dom_sum(i)/n;          % average over n cycles
%             % increment anxiety by not being active
%             anx(i) = anx(i)+anx(i)*anx_inc;
%             % set minimum of anxiety
%             anx(i) = setminof(anx(i),anx_min);
%             % calculate average anxieties
%             anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
%             anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
        end  
     
        % Anxiety increases anyway after each cycle
        anx(i) = anx(i)+anx(i)*anx_inc;
        % set minimum of anxiety
        anx(i) = setminof(anx(i),anx_min);
        
        % Statistics
        % calculate average anxieties
        anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
        anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
        % calculate average dominances
        dom_sum(i) = dom_sum(i)+dom(i);     % sum over n cycles
        dom_avrg(i) = dom_sum(i)/n;          % average over n cycles


%         % find strongest gelada
%         bla = 0;                            
%         save = 0;
%         for a = 1:num_gelas
%             if dom(a,n-1) > bla
%                 bla = dom(a,n-1);
%                 save = a;
%             end
%         end
       
%         pause(dt)
          
    end
    
% after one round they forget with whom they interacted
just_interacted = zeros(num_gelas,1);
% the male with the highest dominance is defined as the alpha male
alpha = dommax(dom);


%% 7 subplot 1-4 (Values & Statistics)
if max(vict) < max(defe)
    fmax = 5*ceil((max(defe)+1)/5);
else
    fmax = 5*ceil((max(vict)+1)/5);
end
subplot(4,3,3)                          % N°2: plots each baboon's number of victories
[WD,B11,S12] = plotyy(gela_nr,vict,gela_nr,defe,'bar','stem');
xlabel(WD(1),'BABOON')
ylabel(WD(1),'VICTORIES')
ylabel(WD(2),'DEFEATS')
ylim(WD(1),[0,fmax])
ylim(WD(2),[0,fmax])
WD(2).YColor = 'r';
B11.EdgeColor = 'b';
S12.Color = 'r';
grid on

subplot(4,3,6)                          % N°3: plots each baboon's number of defeats
[LD,B21,S22] = plotyy(gela_nr,dom,gela_nr,dom_avrg,'bar','stem');
xlabel(LD(1),'BABOON')
ylabel(LD(1),'curr-DOM')
ylabel(LD(2),'ø-DOM')
ylim(LD(1),[0,floor(max(dom))+1])
ylim(LD(2),[0,floor(max(dom_avrg))+1])
LD(2).YColor = [50,177,65]/255;
B21.EdgeColor = 'b';
S22.Color = [50,177,65]/255;
grid on

if max(grmr) < max(grme)
    gmax = 5*ceil((max(grme)+1)/5);
else
    gmax = 5*ceil((max(grmr)+1)/5);
end
subplot(4,3,9)                          % N°4: plots each baboon's number of acts as groomer
[GRA,B31,S32] = plotyy(gela_nr,grmr,gela_nr,grme,'bar','stem');
xlabel(GRA(1),'BABOON')
ylabel(GRA(1),'GROOMER')
ylabel(GRA(2),'GROOMEE')
ylim(GRA(1),[0,gmax])
ylim(GRA(2),[0,gmax])
GRA(2).YColor = 'r';
B31.EdgeColor = 'b';
S32.Color = 'r';
grid on

subplot(4,3,12)                          % N°5: plots each baboon's number of acts as groomee
[GEA,B41,S42] = plotyy(gela_nr,anx,gela_nr,anx_avrg,'bar','stem');
xlabel(GEA(1),'BABOON')
ylabel(GEA(1),'curr-ANX')
ylabel(GEA(2),'ø-ANX')
ylim(GEA(1),[0,floor(max(anx))+1])
ylim(GEA(2),[0,floor(max(anx_avrg))+1])
GEA(2).YColor = [50,177,65]/255;
B41.EdgeColor = 'b';
S42.Color = [50,177,65]/255;
grid on
end
