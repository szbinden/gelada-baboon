%% 0 SIMonkey
clear all, clc                          % delete all data

%% 1 inital conditions
crcl = 2;                             % number of cycles
gela = 14;                               % number of baboons
dt = 0.1;                               % plot updating time

xpos = rand(gela,1);                 % x-position
ypos = rand(gela,1);                 % y-position
dpos = 0.02;                            % multiplier for moving act
fpos = 0.2;                             % multiplier for fleeing act
bview = 0.4;                            % baboon's field of vision
acty = 0.8;                             % baboon's activity
flds = 1.2;                             % field size

dom = 0.7*ones(gela,1);              % value of dominance
ddom = 0.8;                            % multiplier for changing dominance
mdom = 0.001;                           % minimum of possible dominance
anx = 0.5*ones(gela,1);                  % value of anxiety
danx = 0.1;                             % multiplier for changing anxiety
manx = 0.001;                           % minimum of possible anxiety

%% 2 auxiliary variables (Hilfsvariablen)
ngela = (1:gela)';                       % baboon numbering
o = 0;                                  % nearest OTHER baboon
enem = zeros(gela,crcl);                % list of enemies
vict = zeros(gela,1);                    % list of victories fights per baboon
defe = zeros(gela,1);                   % list of defeats fights per baboon
grmr = zeros(gela,1);                   % list of "groomed" per baboon
grme = zeros(gela,1);                   % list of "was groomed" per baboon
noin = zeros(gela,1);                   % list of "no interactions"

%w = rand((gela+1)*gela,crcl);           % interacting matrix
w = rand(gela,1);                                        % 0 - loser
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
%% 3 loop             
for n = 1:crcl                          % loop over cycles
    for i = 1:gela                      % loop over baboons | i = "active baboon"
        %% 4 position plot of all gelada by their number (live)
        subplot(1,3,1:2)
        plot(xpos(:),ypos(:),'.','Color','w')
        grid on
        rectangle('Position',[0,0,1,1])
        text(-0.1,-0.1,int2str(n))
        axis([-flds+1 flds -flds+1 flds]);  % set field size
        text(xpos(:),ypos(:),int2str(ngela),'FontSize',14)
        title('GELADA BABOON - PLAYGROUND')
        %% 5 find individual
        ddist = flds*1.5;
        for j = 1:gela                  % scan over baboons
            if j ~= i                   % exclude interacting with oneself
                % check if a found individual is in my operating distance
                if norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]) < ddist && norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]) > (exp(dom(i))-1)/10
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
            %% 6.1 interaction
            % shall i fight or groom? (yes or no)
            if dom(i)/(dom(i)+dom(o)) >= rand
                %%  6.1.1 fight   
                if dom(i)/(dom(i)+dom(o)) >= rand
                    % i = winner | o = loser
                    w(i) = 1;                       % w(i,n) = 1;          
                    w(o) = 0;                       % w(o+i*gela,n) = 0;
                    % increment victories/defeats
                    vict(i) = vict(i)+1;
                    defe(o) = defe(o)+1;
                    % plot interactions
                    plotinteract(xpos(i),ypos(i),w(i),'bottom');
                    plotinteract(xpos(o),ypos(o),w(o),'top');
                    % write new dominances
                    dom(i) = dom(i)+(w(i)-(dom(i)/(dom(i)+dom(o))))*ddom;
                    dom(o) = dom(o)-(w(i)-(dom(o)/(dom(i)+dom(o))))*ddom;
                    % i doesn't move
                    xpos(i) = xpos(i)+(xpos(o)-xpos(i))*2/3;
                    ypos(i) = ypos(i)+(ypos(o)-ypos(i))*2/3;
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
                    w(i) = 0;
                    w(o) = 1;
                    % increment victories/defeats
                    vict(o) = vict(o)+1;
                    defe(i) = defe(i)+1;
                    % plot interactions
                    plotinteract(xpos(i),ypos(i),w(i),'bottom');
                    plotinteract(xpos(o),ypos(o),w(o),'top');
                    % write new dominances
                    dom(i) = dom(i)-(w(i)-(dom(i)/(dom(i)+dom(o))))*ddom;
                    dom(o) = dom(o)+(w(i)-(dom(o)/(dom(i)+dom(o))))*ddom;
                    % o doesn't move
                    xpos(o) = xpos(o)+(xpos(i)-xpos(o))*2/3;
                    ypos(o) = ypos(o)+(ypos(i)-ypos(o))*2/3;
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
                % set minimum of dominance
                dom(i) = setminof(dom(i),mdom);
                dom(o) = setminof(dom(o),mdom);
                % calculate average dominances
                ndom(i) = ndom(i)+dom(i);     % sum over n cycles
                adom(i) = ndom(i)/n;          % average over n cycles
                ndom(o) = ndom(o)+dom(o);
                adom(o) = ndom(o)/n;
                % anxiety grows anyway because of the fight
                anx(i) = anx(i)+danx;
                anx(o) = anx(o)+danx;
                % set minimum of anxiety
                anx(i) = setminof(anx(i),manx);
                anx(o) = setminof(anx(o),manx);
                % calculate average anxieties
                nanx(i) = nanx(i)+anx(i);     % sum over n cycles
                aanx(i) = nanx(i)/n;          % average over n cycles
                nanx(o) = nanx(o)+anx(o);     
                aanx(o) = nanx(o)/n;
            else
                % 6.1.1 no fight
                % shall i groom? (yes or no)
                if anx(i) >= rand
                    %% 6.1.2 grooming
                    % only groom if own dominance is lower than the other one's is
                    if dom(i) <= dom(o)
                        % i = groomer | o = groomee
                        w(i) = 3;
                        w(o) = 2;
                        % increment groomer/groomee
                        grmr(i) = grmr(i)+1;
                        grme(o) = grme(o)+1;
                        % plot interactions
                        plotinteract(xpos(i),ypos(i),w(i),'bottom');
                        plotinteract(xpos(o),ypos(o),w(o),'top');
                        % write new anxieties
                        anx(i) = anx(i)-danx;
                        anx(o) = anx(o)-danx*1.5;
                        % set minimum of anxiety
                        anx(i) = setminof(anx(i),manx);
                        anx(o) = setminof(anx(o),manx);
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
                    % 6.1.2 no grooming
                    w(i) = rand;
                    % plot interaction
                    plotinteract(xpos(i),ypos(i),w(i),'bottom');
                    anx(i) = anx(i)+danx/2;
                    % set minimum of anxiety
                    anx(i) = setminof(anx(i),manx);
                    % calculate average anxieties
                    nanx(i) = nanx(i)+anx(i);     % sum over n cycles
                    aanx(i) = nanx(i)/n;          % average over n cycles
            
                end
            end
        else
            %% 6.2 no interaction
            % do a random move
            if acty >= rand
                % move randomly
                xpos(i) = move(xpos(i),2*dpos,flds);
                ypos(i) = move(ypos(i),2*dpos,flds);
            % do not do anything
            else
                w(i) = rand;
                % plot interaction
                plotinteract(xpos(i),ypos(i),w(i),'top');
                % decrement dominance by not being activ
                dom(i) = dom(i)-ddom/gela;
                % set minimum of dominance
                dom(i) = setminof(dom(i),mdom);
                % calculate average dominances
                ndom(i) = ndom(i)+dom(i);     % sum over n cycles
                adom(i) = ndom(i)/n;          % average over n cycles
                % increment anxiety by not being activ
                anx(i) = anx(i)+danx/2;
                % set minimum of anxiety
                anx(i) = setminof(anx(i),manx);
                % calculate average anxieties
                nanx(i) = nanx(i)+anx(i);     % sum over n cycles
                aanx(i) = nanx(i)/n;          % average over n cycles
            end
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
       pause(dt)
       
    
    end
%% 7 subplot 1-4
if max(vict) < max(defe)
    fmax = 5*ceil((max(defe)+1)/5);
else
    fmax = 5*ceil((max(vict)+1)/5);
end
subplot(4,3,3)                          % N°2: plots each baboon's number of victories
[WD,B11,S12] = plotyy(ngela,vict,ngela,defe,'bar','stem');
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
[LD,B21,S22] = plotyy(ngela,dom,ngela,adom,'bar','stem');
xlabel(LD(1),'BABOON')
ylabel(LD(1),'curr-DOM')
ylabel(LD(2),'ø-DOM')
ylim(LD(1),[0,floor(max(dom))+1])
ylim(LD(2),[0,floor(max(adom))+1])
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
[GRA,B31,S32] = plotyy(ngela,grmr,ngela,grme,'bar','stem');
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
[GEA,B41,S42] = plotyy(ngela,anx,ngela,aanx,'bar','stem');
xlabel(GEA(1),'BABOON')
ylabel(GEA(1),'curr-ANX')
ylabel(GEA(2),'ø-ANX')
ylim(GEA(1),[0,floor(max(anx))+1])
ylim(GEA(2),[0,floor(max(aanx))+1])
GEA(2).YColor = [50,177,65]/255;
B41.EdgeColor = 'b';
S42.Color = [50,177,65]/255;
grid on
end
