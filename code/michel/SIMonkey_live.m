%% SIMonkey
clear all, clc                          % delete all data

%% 0 inital conditions
crcl = 100;                             % number of cycles
gela = 14;                               % number of baboons
dt = 0.01;                               % plot updating time

xpos = rand(gela,1);                 % x-position
ypos = rand(gela,1);                 % y-position
dpos = 0.02;                            % multiplier for moving act
fpos = 0.2;                             % multiplier for fleeing act
bview = 0.4;                            % baboon's field of vision
acty = 0.9;                             % baboon's activity
flds = 1.5;                             % field size

dom = 0.54*ones(gela,1);              % value of dominance
ddom = 0.8;                            % multiplier for changing dominance
anx = 0.5*ones(gela,1);                  % value of anxiety
danx = 0.1;                             % multiplier for changing anxiety

%% 1 auxiliary variables (Hilfsvariablen)
ngela = (1:gela)';                       % baboon numbering
o = 0;                                  % nearest OTHER baboon
enem = zeros(gela,crcl);                % list of enemies
won = zeros(gela,1);                    % list of victories fights per baboon
lost = zeros(gela,1);                   % list of defeats fights per baboon
grmr = zeros(gela,1);                   % list of "groomed" per baboon
grme = zeros(gela,1);                   % list of "was groomed" per baboon
noin = zeros(gela,1);                   % list of "no interactions"

w = rand((gela+1)*gela,crcl);           % interacting matrix
                                        % 0 - loser
                                        % 1 - winner
                                        % 2 - groomee
                                        % 3 - groomer
                                    
ndom = zeros(gela,1);                   % sum of all dominances over n cycles
adom = zeros(gela,1);                   % each individual's average of dominance
nanx = zeros(gela,1);                   % sum of all anxieties over n cycles
aanx = zeros(gela,1);                   % each individual's average of anxiety

if flds <= 1
    flds = 1.01;
end
figure
%% 2 loop
subplot(1,3,1:2)                        
for n = 1:crcl                          % loop over cycles
    for i = 1:gela                      % loop over baboons | i = "active baboon"
        %% 3 position plot of all gelada by their number (live)
        plot(xpos(:),ypos(:),'.','Color','w')
        hold on, grid on
        rectangle('Position',[0,0,1,1])
        text(-0.4,-0.4,int2str(n))
        axis([-flds+1 flds -flds+1 flds]);  % set field size
        text(xpos(:),ypos(:),int2str(ngela),'FontSize',14)
        title('GELADA BABOON - PLAYGROUND')
        %% 4 find individual
        ddist = flds*1.5;
        for j = 1:gela                  % scan over baboons
            if j ~= i                   % exclude interacting with oneself
                % check if a found individual is in my operating distance
                if norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]) < ddist && norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]) > (exp(dom(i))-1)/3
                    % set found distance to new operating distance
                    ddist = norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]);
                    o = j;              % set found individual to nearest baboon
                end
                %dd(i+(n-1)*gela,j) = ddist;       % DO NOT DELETE
            end
        end
        enem(i,n) = o;                % list enemy
        % decide if nearest OTHER baboon is near enough for an interaction
        if ddist < bview
            %% 5 interaction
            % shall i fight or groom? (yes or no)
            if dom(i)/(dom(i)+dom(o)) >= rand
                %%  5- fight   
                if dom(i)/(dom(i)+dom(o)) >= rand
                    % i = winner | o = loser
                    w(i,n) = 1;
                    w(o+i*gela,n) = 0;
                    % plot interactions
                    plotinteract(xpos(i),ypos(i),w(i,n),'bottom');
                    plotinteract(xpos(o),ypos(o),w(o+i*gela,n),'top');
                    % write new dominances
                    dom(i) = dom(i)+(w(i,n)-(dom(i)/(dom(i)+dom(o))))*ddom;
                    dom(o) = dom(o)-(w(i,n)-(dom(o)/(dom(i)+dom(o))))*ddom;
                    % calculate average dominances
                    ndom(i) = ndom(i)+dom(i);     % sum over n cycles
                    adom(i) = ndom(i)/n;          % average over n cycles
                    ndom(o) = ndom(o)+dom(o);     
                    adom(o) = ndom(o)/n;
                    % i doesn't move 
                    xpos(i) = xpos(i);
                    ypos(i) = ypos(i);
                    % o flees
                    % expected loser flees less far
                    if dom(o) <= dom(i)
                        xpos(o) = move(xpos(o),dpos,flds);
                        ypos(o) = move(ypos(o),dpos,flds);
                        % unexpected loser flees further
                    else
                        xpos(o) = move(xpos(o),fpos,flds);
                        ypos(o) = move(ypos(o),fpos,flds);
                    end
                    
                else
                    % i = loser | o = winner
                    w(i,n) = 0;
                    w(o+i*gela,n) = 1;
                    % plot interactions
                    plotinteract(xpos(i),ypos(i),w(i,n),'bottom');
                    plotinteract(xpos(o),ypos(o),w(o+i*gela,n),'top');
                    % write new dominances
                    dom(i) = dom(i)-(w(i)-(dom(o)/(dom(i)+dom(o))))*ddom;
                    dom(o) = dom(o)+(w(i)-(dom(i)/(dom(i)+dom(o))))*ddom;
                    % calculate average dominances
                    ndom(i) = ndom(i)+dom(i);     % sum over n cycles
                    adom(i) = ndom(i)/n;          % average over n cycles
                    ndom(o) = ndom(o)+dom(o);     
                    adom(o) = ndom(o)/n;
                    % o doesn't move
                    xpos(o) = xpos(o);
                    ypos(o) = ypos(o);
                    % i flees
                    % expected loser flees less far
                    if dom(o) >= dom(i)
                        xpos(i) = move(xpos(i),dpos,flds);
                        ypos(i) = move(ypos(i),dpos,flds);
                    % unexpected loser flees further
                    else
                        xpos(i) = move(xpos(i),fpos,flds);
                        ypos(i) = move(ypos(i),fpos,flds);
                    end
                end
                % anxiety grows anyway because of the fight
                anx(i) = anx(i)+danx;
                anx(o) = anx(o)+danx;
                % calculate average anxieties
                nanx(i) = nanx(i)+anx(i);     % sum over n cycles
                aanx(i) = nanx(i)/n;          % average over n cycles
                nanx(o) = nanx(o)+anx(o);     
                aanx(o) = nanx(o)/n;
            else
                %% 5- no fight
                % shall i groom? (yes or no)
                if anx(i) >= rand
                    %% 5- grooming
                    % only groom if own dominance is lower than the other one's is
                    if dom(i) <= dom(o)
                        % i = groomer | o = groomee
                        w(i,n) = 3;
                        w(o+i*gela,n) = 2;
                        plotinteract(xpos(i),ypos(i),w(i,n),'bottom');
                        plotinteract(xpos(o),ypos(o),w(o+i*gela,n),'top');
                        % write new anxieties
                        anx(i) = anx(i)-danx;
                        anx(o) = anx(o)-danx*1.05;
                        % calculate average anxieties
                        nanx(i) = nanx(i)+anx(i);     % sum over n cycles
                        aanx(i) = nanx(i)/n;          % average over n cycles
                        nanx(o) = nanx(o)+anx(o);     
                        aanx(o) = nanx(o)/n;
                        % groomer moves next to groomee
                        xpos(i) = move(xpos(o),0.03,flds);
                        ypos(i) = move(ypos(o),0.03,flds);
                    % the other one is higher rank
                    else
                        % no changes need to be done
                    end
                    
                else
                    %% 5- no grooming
%                     anx(i) = anx(i)+danx/gela;
%                     % calculate average anxieties
%                     nanx(i) = nanx(i)+anx(i);     % sum over n cycles
%                     aanx(i) = nanx(i)/n;          % average over n cycles
            
                end
            end
        else
            %% 5 no interaction
            % do a random move
            if acty >= rand
                % move randomly
                xpos(i) = move(xpos(i),dpos,flds);
                ypos(i) = move(ypos(i),dpos,flds);
                % update anxiety
                anx(i) = anx(i)+danx;
                % calculate average anxieties
                nanx(i) = nanx(i)+anx(i);     % sum over n cycles
                aanx(i) = nanx(i)/n;          % average over n cycles
            % do not do anything
            else
                % no changes need to be done
            end
            % decrease dominance no being activ
            dom(i) = dom(i)-ddom/gela;
            % calculate average dominances
            ndom(i) = ndom(i)+dom(i);     % sum over n cycles
            adom(i) = ndom(i)/n;          % average over n cycles
        end
        % set minimum of dominance
        if dom(i) <= 0.001
            dom(i) = 0.001;
        elseif dom(o) <= 0.001
            dom(o) = 0.001;
        end
        % set minimum of anxiety
        if anx(i) <= 0.001
            anx(i) = 0.001;
        elseif anx(o) <= 0.001
            anx(o) = 0.001;
        end
        
        
%         % find strongest gelada
%         bla = 0;                            
%         save = 0;
%         for a = 1:gela
%             if dom(a,n-1) > bla
%                 bla = dom(a,n-1);
%                 save = a;
%             end
%         end
       hold off
       pause(dt)
    end
%     pause(dt)
%     hold off
end

%% 7 evaluation
for a=1:crcl                            % collect results of fights/grooming acts
    for b=1:gela*(gela+1)
        z = floor((b-1)/gela);
        if w(b,a) == 0                  % increment defeats
            lost(b-(z*gela),1) = lost(b-(z*gela),1)+1;
        elseif w(b,a) == 1              % increment victories
            won(b-(z*gela),1) = won(b-(z*gela),1)+1;
        elseif w(b,a) == 2              % increment groomer acts
            grme(b-(z*gela),1) = grme(b-(z*gela),1)+1;
        elseif w(b,a) == 3              % increment groomee acts
            grmr(b-(z*gela),1) = grmr(b-(z*gela),1)+1;
        elseif z == 0                   % increment "no interaction"
            noin(b-(z*gela),1) = noin(b-(z*gela),1)+1;
        end
    end
end

% for a = 1:gela                          % calculate average of dominances/anxieties
%     adom(a) = sum(dom(a,:))/crcl;
%     aanx(a) = sum(anx(a,:))/crcl;
% end

%% 8 analysis
% figure                                  % N°1: plots all baboons with their dom and anx
% subplot(1,3,1:2)
% axis([-flds+1 flds -flds+1 flds]);
% rectangle('Position',[0,0,1,1])
% hold on,grid on
% for a = 1:crcl
%     for b = 1:gela
%         plot(xpos(b),ypos(b))
%     end
% end
% title('GELADA BABOON - PLAYGROUND')

if max(won) < max(lost)
    fmax = 10*ceil((max(lost)+1)/10);
else
    fmax = 10*ceil((max(won)+1)/10);
end
subplot(4,3,3)                          % N°2: plots each baboon's number of victories
[WD,B11,S12] = plotyy(ngela,won,ngela,adom,'bar','stem');
xlabel(WD(1),'BABOON')
ylabel(WD(1),'VICTORIES')
ylabel(WD(2),'ø-DOM')
ylim(WD(1),[0,fmax])
ylim(WD(2),[0,floor(max(adom))+1])
WD(2).YColor = 'r';
B11.EdgeColor = 'b';
S12.Color = 'r';
grid on


subplot(4,3,6)                          % N°3: plots each baboon's number of defeats
[LD,B21,S22] = plotyy(ngela,lost,ngela,adom,'bar','stem');
xlabel(LD(1),'BABOON')
ylabel(LD(1),'DEFEATS')
ylabel(LD(2),'ø-DOM')
ylim(LD(1),[0,fmax])
ylim(LD(2),[0,floor(max(adom))+1])
LD(2).YColor = 'r';
B21.EdgeColor = 'b';
S22.Color = 'r';
grid on

if max(grmr) < max(grme)
    gmax = 10*ceil((max(grme)+1)/10);
else
    gmax = 10*ceil((max(grmr)+1)/10);
end
subplot(4,3,9)                          % N°4: plots each baboon's number of acts as groomer
[GRA,B31,S32] = plotyy(ngela,grmr,ngela,aanx,'bar','stem');
xlabel(GRA(1),'BABOON')
ylabel(GRA(1),'GROOMER')
ylabel(GRA(2),'ø-ANX')
ylim(GRA(1),[0,gmax])
ylim(GRA(2),[0,floor(max(aanx))+1])
GRA(2).YColor = 'r';
B31.EdgeColor = 'b';
S32.Color = 'r';
grid on

subplot(4,3,12)                          % N°5: plots each baboon's number of acts as groomee
[GEA,B41,S42] = plotyy(ngela,grme,ngela,aanx,'bar','stem');
xlabel(GEA(1),'BABOON')
ylabel(GEA(1),'GROOMEE')
ylabel(GEA(2),'ø-ANX')
ylim(GEA(1),[0,gmax])
ylim(GEA(2),[0,floor(max(aanx))+1])
GEA(2).YColor ='r';
B41.EdgeColor = 'b';
S42.Color = 'r';
grid on





