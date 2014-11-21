%% SIMonkey
clear all, clc                          % delete all data

%% 0 inital conditions
crcl = 300;                             % number of circles
gela = 8;                              % number of baboons


xpos = rand(gela,crcl);                 % x-position
ypos = rand(gela,crcl);                 % y-position
dpos = 0.1;                             % multiplier for moving/fleeing act
bview = .6;                            % baboon's field of vision
ndist = 3;                              % nearest distance
flds = 1.5;                             % field size

dom = rand(gela,crcl);                  % value of dominance
ddom = 0.15;                             % multiplier for changing dominance
sdom = 0;                             % attacker must have a "sdom" higher dominance to attack
anx = rand(gela,crcl);                  % value of anxiety
danx = 0.3;                             % multiplier for changing anxiety

%% 1 auxiliary variables (Hilfsvariablen)
ngela = (1:gela);                       % baboon numbering
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
anxfinit = zeros(gela,1);
domfinit = zeros(gela,1);

lgnd = {1,gela};

%% 2 loop
if flds < 1
    flds = 1.01;
end
for n = 2:crcl                          % loop over cycles
    for i = 1:gela                      % loop over baboons | i = "active baboon"
        lgnd{i} = [' = ' num2str(i)];   % legend to identify baboons
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
                dd(i+(n-2)*gela,j) = ddist;       % DO NOT DELETE
            end
        end
        enem(i,n-1) = o;                % list enemy
        %% 4 interaction
        % decide if nearest OTHER baboon is near enough for an interaction
        if norm([xpos(i),ypos(i)]-[xpos(o),ypos(o)]) < bview
            % shall i fight? (relative dominance greater than rand)
            if (dom(i,n-1)/(dom(i,n-1)+dom(o,n-1)) >= rand) && (dom(i,n-1) > dom(o,n-1) + sdom)
                %%  41 fight (win or lose)    
                if dom(i,n-1)/(dom(i,n-1)+dom(o,n-1)) >= rand
                    % i = winner | o = loser
                    w(i,n-1) = 1;
                    w(o+i*gela,n-1) = 0;
                    dom(i,n) = dom(i,n-1)+(w(i,n-1)-(dom(i,n-1)/(dom(i,n-1)+dom(o,n-1))))*ddom;
                    dom(o,n) = dom(o,n-1)-(w(i,n-1)-(dom(i,n-1)/(dom(i,n-1)+dom(o,n-1))))*ddom;
                    % i takes o's position 
                    xpos(i,n) = xpos(o,n-1);
                    ypos(i,n) = ypos(o,n-1);
                    % o flees
                    xpos(o,n) = move(xpos(o,n-1),1.5*dpos,flds);
                    ypos(o,n) = move(ypos(o,n-1),1.5*dpos,flds);      
                else
                    % i = loser | o = winner
                    w(i,n-1) = 0;
                    w(o+i*gela,n-1) = 1;
                    dom(i,n) = dom(i,n-1)-(w(i,n-1)-(dom(o,n-1)/(dom(i,n-1)+dom(o,n-1))))*ddom;
                    dom(o,n) = dom(o,n-1)+(w(i,n-1)-(dom(o,n-1)/(dom(i,n-1)+dom(o,n-1))))*ddom;
                    % i flees
                    xpos(i,n) = move(xpos(i,n-1),1.5*dpos,flds);
                    ypos(i,n) = move(ypos(i,n-1),1.5*dpos,flds);
                    % o takes i's position
                    xpos(o,n) = xpos(i,n-1);
                    ypos(o,n) = ypos(i,n-1);
                end
                % set minimum of dominance
                if dom(i,n) <= 0.001
                    dom(i,n) = 0.001;
                elseif dom(o,n) <= 0.001
                    dom(o,n) = 0.001;
                end
                % anxiety grows anyway because of the fight
                anx(i,n) = anx(i,n)+danx;
                anx(o,n) = anx(o,n)+danx;
            
            else
                %% 42 no fight
                % update dominance
                dom(i,n) = dom(i,n-1);
                % shall i groom? (yes or no)
                if anx(i,n-1) >= rand
                    %% 421 grooming
                    % only groom if own dominance is lower than the other one's is
                    if dom(i,n) <= dom(o,n)
                        % i = groomer | o = groomee
                        w(i,n-1) = 3;
                        w(o+i*gela,n-1) = 2;
                        anx(i,n) = anx(i,n-1)-danx;
                        anx(o,n) = anx(o,n-1)-danx*1.3;
                        % groomer moves next to groomee
                        xpos(i,n) = move(xpos(o,n-1),0.05,flds);
                        ypos(i,n) = move(ypos(o,n-1),0.05,flds);
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
            % move
            xpos(i,n) = move(xpos(i,n-1),dpos,flds);
            ypos(i,n) = move(ypos(i,n-1),dpos,flds);
            % update dominance/anxiety
            dom(i,n) = dom(i,n-1);
            anx(i,n) = anx(i,n-1)+danx/gela;
        end
        % set minimum of anxiety
        if anx(i,n) <= 0.001
            anx(i,n) = 0.001;
        elseif anx(o,n) <= 0.001
            anx(o,n) = 0.001;
        end
        
        domfinit(i) = ceil(5*sum(dom(i,:)/n)); % labels all points with their dominance
        anxfinit(i) = ceil(5*sum(anx(i,:)/n));
        plot(xpos(:,(n-1)),ypos(:,(n-1)),'w')
        grid on
        for a= 1:gela
        %text(xpos(a,n-1), ypos(a,(n-1)), int2str(domfinit(a)), 'VerticalAlignment','top', 'HorizontalAlignment','right')
        %text(xpos(a,n-1), ypos(a,n-1), int2str(anxfinit(a)), 'VerticalAlignment','bottom', 'HorizontalAlignment','right')
        text(xpos(a,n-1), ypos(a,n-1), int2str(a), 'VerticalAlignment','top', 'HorizontalAlignment','left')
        end
        axis([-flds+1 flds -flds+1 flds]);
    end
    %drawnow;                            % update plot
    n
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
            grme(b-(z*gela),1) = grme(b-(z*gela),1)+1;
        elseif w(b,a) == 3              % increment groomee acts
            grmr(b-(z*gela),1) = grmr(b-(z*gela),1)+1;
        elseif z == 0                   % increment "no interaction"
            noin(b-(z*gela),1) = noin(b-(z*gela),1)+1;
        end
    end
    a
end

for a = 1:gela                          % calculate average of dominances/anxieties
    adom(a) = sum(dom(a,:))/crcl;
    aanx(a) = sum(anx(a,:))/crcl;
end
hold off

%% 6 plot
figure                                  % N�1: plots all baboons with their dom and anx
subplot(1,3,1:2)
axis([-flds+1 flds -flds+1 flds]);
rectangle('Position',[0,0,1,1])
hold on,grid on
for a = 1:crcl
    % domfinit = cellstr(num2str(ceil(100*dom(:,a)))); % labels all points with their dominance
    % anxfinit = cellstr(num2str(ceil(100*anx(:,a)))); % labels all points with their anxiety
    for b = 1:gela
        plot(xpos(b,:),ypos(b,:))
        if a > 1
            if xpos(b,a) ~= xpos(b,a-1) || ypos(b,a) ~= ypos(b,a-1)
                %text(xpos(b,a), ypos(b,a), domfinit(b), 'VerticalAlignment','top', 'HorizontalAlignment','right')
                %text(xpos(b,a), ypos(b,a), anxfinit(b), 'VerticalAlignment','bottom', 'HorizontalAlignment','right')
            end
        end
    end
end
title('GELADA BABOON - PLAYGROUND')
legend(lgnd,'FontSize',10,'FontWeight','bold')

subplot(4,3,3)                          % N�2: plots each baboon's number of wins
[WD,B11,S12] = plotyy(ngela,won,ngela,adom,'bar','stem');
WD(2).YColor = 'r';
B11.EdgeColor = 'b';
S12.Color = 'r';
grid on
title('BLUE = victories/baboon    RED = average dominance/baboon')

subplot(4,3,6)                          % N�2: plots each baboon's number of wins
[LD,B21,S22] = plotyy(ngela,lost',ngela,adom','bar','stem');
LD(2).YColor = 'r';
B21.EdgeColor = 'b';
S22.Color = 'r';
grid on
title('BLUE = defeats/baboon    RED = average dominance/baboon')

subplot(4,3,9)                          % N�3: plots each baboon's number of
[GRA,B31,S32] = plotyy(ngela,grmr,ngela,aanx,'bar','stem');
GRA(2).YColor = 'r';
B31.EdgeColor = 'b';
S32.Color = 'r';
grid on
title('BLUE = groomer act/baboon    RED = average anxiety/baboon')

subplot(4,3,12)                          % N�3: plots each baboon's number of
[GEA,B41,S42] = plotyy(ngela,grme,ngela,aanx,'bar','stem');
GEA(2).YColor = 'r';
B41.EdgeColor = 'b';
S42.Color = 'r';
grid on
title('BLUE = groomee act/baboon    RED = average anxiety/baboon')

