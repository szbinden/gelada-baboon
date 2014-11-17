%% SIMonkey
%% 0 inital conditions
% number of circles
crcl = 8;
% number of baboons
gelba = 8;
% position
xpos = zeros(gelba,crcl);
ypos = zeros(gelba,crcl);
dpos = 1;
% dominance
dom = rand(gelba,crcl);
ddom = 0.5;
w = zeros(gelba,crcl);
% anxiety
anx = rand(gelba,crcl);
danx = 0.1;
%% 1 find individual
% found baboon
o = 5;
%% 2 interaction
for n = 1:crcl
    % i = "active baboon" | o = "nearest other baboon"
    for i = 1:gelba
        % to fight?
        if dom(i,n)/(dom(i,n)+dom(o,n)) >= rand
            % real fight
            if dom(i,n)/(dom(i,n)+dom(o,n)) >= rand
                % winner
                w(i,n) = 1;
                dom(i,n) = dom(i,n)+(w(i,n)-(dom(i,n)/(dom(i,n)+dom(o,n))))*ddom;
            else
                % loser
                w(i,n) = 0;
                dom(i,n) = dom(i,n)-(w(i,n)-(dom(o,n)/(dom(i,n)+dom(o,n))))*ddom;
                xpos(i,n) = dpos*cos(2*pi*rand);
                ypos(i,n) = dpos*sin(2*pi*rand);
            end
            anx(i,n) = anx(i,n)+danx;
        % to groom?
        else
            % grooming
            if anx(i,n) >= rand
                % groomer
                anx(i,n) = anx(i,n)-danx;
                % groomee
                anx(o,n) = anx(o,n)-danx-0.1;
            else
                xpos(i,n) = dpos*cos(2*pi*rand);
                ypos(i,n) = dpos*sin(2*pi*rand);
            end
        end
    end
end
plot(xpos,ypos,'o');