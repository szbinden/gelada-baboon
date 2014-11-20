%% SIMonkey
clear all, clc                          % delete all data

%% 0 inital conditions
crcl = 200;                             % number of circles
gela = 15;                               % number of baboons

xpos = rand(gela,crcl);                 % x-position
ypos = rand(gela,crcl);                 % y-position
dpos = 0.1;                               % multiplier for moving/fleeing act
bview = 0.2;                              % baboon's field of vision
ndist = 10;                             % nearest distance
flds = 1.5;                               % field size (4th quarter)

dom = rand(gela,crcl);                  % value of dominance
ddom = 0.2;                             % multiplier for changing dominance
anx = rand(gela,crcl);                  % value of anxiety
danx = 0.05;                             % multiplier for changing anxiety

%% 1 auxiliary variables (Hilfsvariablen)
ngela = (1:gela)';                      % baboon numbering
o = 0;                                  % nearest OTHER baboon
enem = zeros(gela,crcl);                % list of enemies
won = zeros(gela,1);                    % list of won fights per baboon
lost = zeros(gela,1);                   % list of lost fights per baboon
grmr = zeros(gela,1);                   % list of interactions as groomer per baboon
grme = zeros(gela,1);                   % list of interactions as groomee per baboon
noin = zeros(gela,1);                   % list of "no interactions"

w = rand((gela+1)*gela,crcl);           % interacting matrix
                                        % 0 - loser
                                        % 1 - winner
                                        % 2 - groomee
                                        % 3 - groomer
                                    
adom = zeros(gela,1);                   % each individual's average of dominance
aanx = zeros(gela,1);                   % each individual's average of anxiety


%% 2 loop

for n = 2:crcl                          % loop over circles
    for i = 1:gela                      % loop over baboons | i = "active baboon"
        %% 3 find individual
        ddist = ndist;
        for j = 1:gela                  % scan over baboons
            if j ~= i                   % exclude interacting with oneself
                % check if a found individual is in my operating distance
                if (norm([xpos(i,n-1),ypos(i,n-1)]-[xpos(j,n-1),ypos(j,n-1)]) < ddist)
                    % set found distance to new operating distance
                    ddist = norm([xpos(i,n-1),ypos(i,n-1)]-[xpos(j,n-1),ypos(j,n-1)]);
                    o = j;              % set found individual to nearest baboon
                end
                %DO NOT DELETE: dd(i+(n-2)*gela,j) = ddist;
            end
        end
        enem(i,n-1) = o;                % list enemy
        %% 4 interaction
        % decide if baboon i is near enough nearest OTHER baboon for an interaction
        if norm([xpos(i),ypos(i)]-[xpos(o),ypos(o)]) < bview
            % shall i fight? (relative dominance greater than rand)
            if dom(i,n-1)/(dom(i,n-1)+dom(o,n-1)) >= rand && dom(i,n-1) > dom(o,n-1) + 0.2
                %%  41 fight (win or lose)    
                if dom(i,n-1)/(dom(i,n-1)+dom(o,n-1)) >= rand
                    % i = winner | o = loser
                    w(i,n-1) = 1;
                    w(o+i*gela,n-1) = 0;
                    dom(i,n) = dom(i,n-1)+(w(i,n-1)-(dom(i,n-1)/(dom(i,n-1)+dom(o,n-1))))*ddom;
                    dom(o,n) = dom(o,n-1)-(w(i,n-1)-(dom(i,n-1)/(dom(i,n-1)+dom(o,n-1))))*ddom;
                    % i doesn't move
                    xpos(i,n) = xpos(i,n-1);
                    ypos(i,n) = ypos(i,n-1);
                    % o moves
                    xpos(o,n) = move(xpos(o,n-1),dpos,flds);
                    ypos(o,n) = move(ypos(o,n-1),dpos,flds);      
                else
                    % i = loser | o = winner
                    w(i,n-1) = 0;
                    w(o+i*gela,n-1) = 1;
                    dom(i,n) = dom(i,n-1)-(w(i,n-1)-(dom(o,n-1)/(dom(i,n-1)+dom(o,n-1))))*ddom;
                    dom(o,n) = dom(o,n-1)+(w(i,n-1)-(dom(o,n-1)/(dom(i,n-1)+dom(o,n-1))))*ddom;
                    % i moves
                    xpos(i,n) = move(xpos(i,n-1),dpos,flds);
                    ypos(i,n) = move(ypos(i,n-1),dpos,flds);
                    % o doesn't move
                    xpos(o,n) = xpos(o,n-1);
                    ypos(o,n) = ypos(o,n-1);
                end
                % set minimum of dominance
                if dom(i,n) <= 0.001
                    dom(i,n) = 0.001;
                elseif dom(o,n) <= 0.001
                    dom(o,n) = 0.001;
                end
                % anxiety grows anyway because of fight
                anx(i,n) = anx(i,n)+danx;
                anx(o,n) = anx(o,n)+danx;
            
            else
                %% 42 no fight
                % update dominance
                dom(i,n) = dom(i,n-1);
                % shall i groom? (yes or no)
                if anx(i,n-1) >= rand
                    %% 421 grooming
                    % only groom if own RELATIVE dominance is lower than
                    % the others is
                    if dom(i,n) <= dom(o,n)
                        % i = groomer | o = groomee
                        w(i,n-1) = 3;
                        w(o+i*gela,n-1) = 2;
                        anx(i,n) = anx(i,n-1)-danx;
                        anx(o,n) = anx(o,n-1)-danx-0.05;
                        % set minimum of anxiety
                        if anx(i,n) <= 0.001
                            anx(i,n) = 0.001;
                        elseif anx(o,n) <= 0.001
                            anx(o,n) = 0.001;
                        end
                        xpos(i,n) = xpos(o,n-1)+0.05*rand;
                        ypos(i,n) = ypos(o,n-1)+0.01;
                    end
                else
                    %% 422 no grooming
                    anx(i,n) = anx(i,n-1)+danx/gela;
                    xpos(i,n) = move(xpos(i,n-1),dpos,flds);
                    ypos(i,n) = move(ypos(i,n-1),dpos,flds);
                end
            end
        else
            %% 5 no interaction
            % move randomly            
            xpos(i,n) = move(xpos(i,n-1),dpos,flds);
            ypos(i,n) = move(ypos(i,n-1),dpos,flds);
            % update dominance/anxiety
            dom(i,n) = dom(i,n-1);
            anx(i,n) = anx(i,n-1)+danx;
        end
    end
end
%% 5 evaluation
for a=1:crcl                            % collect results of fights/grooming acts
    for b=1:gela*(gela+1)
        z = floor((b-1)/gela);
        if w(b,a) == 0                  % increment victories
            lost(b-(z*gela),1) = lost(b-(z*gela),1)+1;
        elseif w(b,a) == 1              % increment defeats
            won(b-(z*gela),1) = won(b-(z*gela),1)+1;
        elseif w(b,a) == 2              % increment groomer acts
            grme(b-(z*gela),1) = grmr(b-(z*gela),1)+1;
        elseif w(b,a) == 3              % increment groomee acts
            grmr(b-(z*gela),1) = grme(b-(z*gela),1)+1;
        elseif b <= gela                % increment "no interaction"
            noin(b,1) = noin(b-(z*gela),1)+1;
        end
    end
end

for a = 1:gela                          % calculate average of dominances/anxieties
    adom(a) = 5*sum(dom(a,:)/crcl);
    aanx(a) = 5*sum(anx(a,:)/crcl);
end


%% 6 plot
figure                                  % N°1: plots all baboons with their dom and anx
subplot(1,3,1:2)
rectangle('Position',[0,0,1,1])
hold on,grid on
for d = 1:crcl
    domfinit = cellstr(num2str(ceil(100*dom(:,d)))); % labels all points with their dominance
    anxfinit = cellstr(num2str(ceil(100*anx(:,d)))); % labels all points with their anxiety

    for c = 1:gela
        plot(xpos(c,:),ypos(c,:),'o')
        if d > 1
            if xpos(c,d) ~= xpos(c,d-1) || ypos(c,d) ~= ypos(c,d-1)
                %text(xpos(c,d), ypos(c,d), domfinit(c), 'VerticalAlignment','top', 'HorizontalAlignment','right')
                %text(xpos(c,d), ypos(c,d), anxfinit(c), 'VerticalAlignment','bottom', 'HorizontalAlignment','right')
                
            end
        end
    end
end
title('PLAY FIELD         upper value = dominance percent          lower value = anxiety percent')


subplot(2,3,3)                                 % N°2: plots each baboon's number of wins
bar(adom,'r')                                  %      in front of their average dominance
hold on
bar(won,0.4)
title('RED = average dominance/baboon   BLUE = wins/baboon')

subplot(2,3,6)                                 % N°3: plots each baboon's number of
bar(aanx,'r')                                  %      groomer acts in front of their 
hold on                                        %      average anxiety
bar(grmr,0.4)
title('RED = average anxiety/baboon   BLUE = groomer act/baboon')
