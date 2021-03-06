%% 0. SIMonkey
clear all, clc                          % delete all data

%% 1. inital conditions
num_cycl = 200;                         % number of cycles
num_gelas = 14;                         % number of baboons
dt = 0.1;                               % pause between each individul/plot updating time
xpos = rand(num_gelas,1);               % x-position
ypos = rand(num_gelas,1);               % y-position
mov_multip = 0.02;                      % multiplier for moving act
flee_multip = 0.2;                      % multiplier for fleeing act
view = 0.4;                             % baboon's field of vision
activity = 0.8;                         % baboon's activity
field_size = 1.2;                       % field size

dom = 0.7*ones(num_gelas,1);            % value of dominance
stepdom = 0.8;                          % multiplier for changing dominance
dom_min = 0.001;                        % minimum of possible dominance
anx = 0.5*ones(num_gelas,1);            % value of anxiety
anx_inc = 0.01;                         % percentual increas of anxiety after every activation
anx_inc_fight = 0.15;                   % total increase of anxiety after fight
anx_dcr_grmr = 0.1;                     % total increase of anxiety after grooming another monkey;
anx_dcr_grme = 0.15;                     % total increase of anxiety after being groomed by another monkey;
anx_min = 0.001;                        % minimum of possible anxiety

%% 2. auxiliary variables (Hilfsvariablen)
gela_nr = (1:num_gelas)';               % baboon numbering
nearest_gela = 0;                       % nearest OTHER baboon
enem = zeros(num_gelas,num_cycl);       % list of enemies
vict = zeros(num_gelas,1);              % list of victories fights per baboon
defe = zeros(num_gelas,1);              % list of defeats fights per baboon
grmr = zeros(num_gelas,1);              % list of "groomed" per baboon
grme = zeros(num_gelas,1);              % list of "was groomed" per baboon
noin = zeros(num_gelas,1);              % list of "no interactions"

%outcome = rand((num_gelas+1)*num_gelas,num_cycl);           % interaction matrix

outcome = zeros(num_gelas,1);           % 0 - loser
                                        % 1 - winner
                                        % 2 - groomee
                                        % 3 - groomer
                                        % 4 - searching
                                        % 5 - resting
                                    
dom_sum = zeros(num_gelas,1);           % sum of all dominances over n cycles
dom_avrg = zeros(num_gelas,1);          % each individual's average of dominance
anx_sum = zeros(num_gelas,1);           % sum of all anxieties over n cycles
anx_avrg = zeros(num_gelas,1);          % each individual's average of anxiety

if field_size <= 1
    field_size = 1.01;
end
figure
%% 3. loop             
for n = 1:num_cycl                      % loop over cycles
    
    for i = 1:num_gelas                 % loop over baboons | i = "active baboon"
        %% 4. position plot of all gelada by their number (live)
        subplot(1,3,1:2)
        plot(xpos(:),ypos(:),'.','Color','w')
        grid on
        rectangle('Position',[0,0,1,1])
        text(-0.1,-0.1,int2str(n))
        axis([-field_size+1 field_size -field_size+1 field_size]);  % set field size
        text(xpos(:),ypos(:),int2str(gela_nr),'FontSize',14)
        title('GELADA BABOON - PLAYGROUND')
        
        %% 5. find individual
        nearest_dist = field_size*1.5;
        for j = 1:num_gelas             % scan over baboons
            if j ~= i                   % exclude interaction with oneself
        % check if a found individual is in my operating distance
                if norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]) < nearest_dist && norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]) > (exp(dom(i))-1)/10
        % set found distance to new operating distance
                    nearest_dist = norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]);
                    nearest_gela = j;   % set found individual to nearest baboon
                end
            %dd(i+(n-1)*num_gelas,j) = nearest_dist;       % DO NOT DELETE
            end
        end
        
        enem(i,n) = nearest_gela;       % list enemy
        
        % decide if nearest OTHER baboon is near enough for an interaction
        if nearest_dist < view
            %% 6.1 interaction
            % shall i fight or groom?
            if dom(i)/(dom(i)+dom(nearest_gela)) >= rand        %if true -> fight
                
                %%  6.1.1 fight   
                %Attack
                if dom(i)/(dom(i)+dom(nearest_gela)) >= rand    %if true -> i = winner
                    % i = winner | o = loser
                    outcome(i) = 1;                            % outcome(i,n) = 1;          
                    outcome(nearest_gela) = 0;                 % outcome(o+i*num_gelas,n) = 0;
                    % increment victories/defeats
                    vict(i) = vict(i)+1;
                    defe(nearest_gela) = defe(nearest_gela)+1;
                    % plot interactions
                    plotinteract(xpos(i),ypos(i),outcome(i),'bottom');
                    plotinteract(xpos(nearest_gela),ypos(nearest_gela),outcome(nearest_gela),'top');
                    % write new dominances
                    dom(i) = dom(i)+(outcome(i)-(dom(i)/(dom(i)+dom(nearest_gela))))*stepdom;
                    dom(nearest_gela) = dom(nearest_gela)-(outcome(i)-(dom(nearest_gela)/(dom(i)+dom(nearest_gela))))*stepdom;
                    % 'i' doesn't move
                    xpos(i) = xpos(i)+(xpos(nearest_gela)-xpos(i))*2/3;
                    ypos(i) = ypos(i)+(ypos(nearest_gela)-ypos(i))*2/3;
                    % o flees
                    % expected loser flees less far
                    if dom(nearest_gela) <= dom(i)
                        xpos(nearest_gela) = move(xpos(nearest_gela),mov_multip,field_size);
                        ypos(nearest_gela) = move(ypos(nearest_gela),mov_multip,field_size);
                    % unexpected loser flees further
                    else
                        xpos(nearest_gela) = move(xpos(nearest_gela),flee_multip,field_size);
                        ypos(nearest_gela) = move(ypos(nearest_gela),flee_multip,field_size);
                    end
                    
                else
                    % i = loser | o = winner
                    outcome(i) = 0;
                    outcome(nearest_gela) = 1;
                    % increment victories/defeats
                    vict(nearest_gela) = vict(nearest_gela)+1;
                    defe(i) = defe(i)+1;
                    % plot interactions
                    plotinteract(xpos(i),ypos(i),outcome(i),'bottom');
                    plotinteract(xpos(nearest_gela),ypos(nearest_gela),outcome(nearest_gela),'top');
                    % write new dominances
                    dom(i) = dom(i)-(outcome(i)-(dom(i)/(dom(i)+dom(nearest_gela))))*stepdom;
                    dom(nearest_gela) = dom(nearest_gela)+(outcome(i)-(dom(nearest_gela)/(dom(i)+dom(nearest_gela))))*stepdom;
                    % o moves
                    xpos(nearest_gela) = xpos(nearest_gela)+(xpos(i)-xpos(nearest_gela))*2/3;
                    ypos(nearest_gela) = ypos(nearest_gela)+(ypos(i)-ypos(nearest_gela))*2/3;
                    % i flees
                    % expected loser flees less far
                    if dom(nearest_gela) >= dom(i)
                        xpos(i) = move(xpos(i),mov_multip,field_size);
                        ypos(i) = move(ypos(i),mov_multip,field_size);
                    % unexpected loser flees further
                    else
                        xpos(i) = move(xpos(i),flee_multip,field_size);
                        ypos(i) = move(ypos(i),flee_multip,field_size);
                    end
                end
                % set minimum of dominance
                dom(i) = setminof(dom(i),dom_min);
                dom(nearest_gela) = setminof(dom(nearest_gela),dom_min);
                % calculate average dominances
                dom_sum(i) = dom_sum(i)+dom(i);     % sum over n cycles
                dom_avrg(i) = dom_sum(i)/n;          % average over n cycles
                dom_sum(nearest_gela) = dom_sum(nearest_gela)+dom(nearest_gela);
                dom_avrg(nearest_gela) = dom_sum(nearest_gela)/n;
                
                % anxiety grows anyway because of the fight
                anx(i) = anx(i)+anx_inc_fight;
                anx(nearest_gela) = anx(nearest_gela)+anx_inc_fight;
                % set minimum of anxiety
                anx(i) = setminof(anx(i),anx_min);
                anx(nearest_gela) = setminof(anx(nearest_gela),anx_min);
                % calculate average anxieties
                anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
                anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
                anx_sum(nearest_gela) = anx_sum(nearest_gela)+anx(nearest_gela);     
                anx_avrg(nearest_gela) = anx_sum(nearest_gela)/n;
            else
                % 6.1.1 no fight
                % shall i groom? (yes or no)
                if anx(i) >= rand
                    %% 6.1.2 grooming
                    % only groom if own dominance is lower than the other one's is
                    if dom(i) <= dom(nearest_gela)
                        % i = groomer | o = groomee
                        outcome(i) = 3;
                        outcome(nearest_gela) = 2;
                        % increment groomer/groomee
                        grmr(i) = grmr(i)+1;
                        grme(nearest_gela) = grme(nearest_gela)+1;
                        % plot interactions
                        plotinteract(xpos(i),ypos(i),outcome(i),'bottom');
                        plotinteract(xpos(nearest_gela),ypos(nearest_gela),outcome(nearest_gela),'top');
                        % write new anxieties
                        anx(i) = anx(i)-anx_dcr_grmr;
                        anx(nearest_gela) = anx(nearest_gela)-anx_dcr_grme;
                        % set minimum of anxiety
                        anx(i) = setminof(anx(i),anx_min);
                        anx(nearest_gela) = setminof(anx(nearest_gela),anx_min);
                        % calculate average anxieties
                        anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
                        anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
                        anx_sum(nearest_gela) = anx_sum(nearest_gela)+anx(nearest_gela);     
                        anx_avrg(nearest_gela) = anx_sum(nearest_gela)/n;
                        % groomer moves next to groomee
                        xpos(i) = move(xpos(nearest_gela),0.03,field_size);
                        ypos(i) = move(ypos(nearest_gela),0.03,field_size);
                    % the other one is higher rank
                    else
                        % no changes need to be done
                    end
                    
                else
                    % 6.1.2 no grooming
                    outcome(i) = 5;
                    % plot interaction
                    plotinteract(xpos(i),ypos(i),outcome(i),'bottom');
                    anx(i) = anx(i)+anx(i)*anx_inc;
                    % set minimum of anxiety
                    anx(i) = setminof(anx(i),anx_min);
                    % calculate average anxieties
                    anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
                    anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
            
                end
            end
        else
            %% 6.2 no interaction
            % do a random move
            if activity >= rand
                outcome(i) = 4;
                % move randomly
                xpos(i) = move(xpos(i),2*mov_multip,field_size);
                ypos(i) = move(ypos(i),2*mov_multip,field_size);
                % plot interaction
                plotinteract(xpos(i),ypos(i),outcome(i),'top');
                % decrement dominance by not being active
                dom(i) = dom(i)-stepdom/num_gelas;
                % set minimum of dominance
                dom(i) = setminof(dom(i),dom_min);
                % calculate average dominances
                dom_sum(i) = dom_sum(i)+dom(i);     % sum over n cycles
                dom_avrg(i) = dom_sum(i)/n;          % average over n cycles
                % increment anxiety by not being active
                anx(i) = anx(i)+anx(i)*anx_inc;
                % set minimum of anxiety
                anx(i) = setminof(anx(i),anx_min);
                % calculate average anxieties
                anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
                anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
                
            % do not do anything
            else
                outcome(i) = 5;
                % plot interaction
                plotinteract(xpos(i),ypos(i),outcome(i),'top');
                % decrement dominance by not being active
                dom(i) = dom(i)-stepdom/num_gelas;
                % set minimum of dominance
                dom(i) = setminof(dom(i),dom_min);
                % calculate average dominances
                dom_sum(i) = dom_sum(i)+dom(i);     % sum over n cycles
                dom_avrg(i) = dom_sum(i)/n;          % average over n cycles
                % increment anxiety by not being active
                anx(i) = anx(i)+anx(i)*anx_inc;
                % set minimum of anxiety
                anx(i) = setminof(anx(i),anx_min);
                % calculate average anxieties
                anx_sum(i) = anx_sum(i)+anx(i);     % sum over n cycles
                anx_avrg(i) = anx_sum(i)/n;          % average over n cycles
            end
            
            
            end
        
        
        
%         % find strongest gelada
%         bla = 0;                            
%         save = 0;
%         for a = 1:num_gelas
%             if dom(a,n-1) > bla
%                 bla = dom(a,n-1);
%                 save = a;
%             end
%         end
       pause(dt)
       
    
    end
%% 7 subplot 1-4
if max(vict) < max(defe)
    fmax = 5*ceil((max(defe)+1)/5);
else
    fmax = 5*ceil((max(vict)+1)/5);
end
subplot(4,3,3)                          % N�2: plots each baboon's number of victories
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

subplot(4,3,6)                          % N�3: plots each baboon's number of defeats
[LD,B21,S22] = plotyy(gela_nr,dom,gela_nr,dom_avrg,'bar','stem');
xlabel(LD(1),'BABOON')
ylabel(LD(1),'curr-DOM')
ylabel(LD(2),'�-DOM')
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
subplot(4,3,9)                          % N�4: plots each baboon's number of acts as groomer
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

subplot(4,3,12)                          % N�5: plots each baboon's number of acts as groomee
[GEA,B41,S42] = plotyy(gela_nr,anx,gela_nr,anx_avrg,'bar','stem');
xlabel(GEA(1),'BABOON')
ylabel(GEA(1),'curr-ANX')
ylabel(GEA(2),'�-ANX')
ylim(GEA(1),[0,floor(max(anx))+1])
ylim(GEA(2),[0,floor(max(anx_avrg))+1])
GEA(2).YColor = [50,177,65]/255;
B41.EdgeColor = 'b';
S42.Color = [50,177,65]/255;
grid on
end
