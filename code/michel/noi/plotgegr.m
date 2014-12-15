function [  ] = plotgegr( a,b,c,d,dt )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global xpos grme grmr
% define the limit for the y-axes
if max(grmr) < max(grme)
    ymax = 5*ceil((max(grme)+1)/5);
else
    ymax = 5*ceil((max(grmr)+1)/5);
end
subplot(a,b,c)
[hAx,s1,p1] = plotyy((1:length(xpos))',grme,(1:length(xpos))',grmr,'stem','stem');


ylabel(hAx(1),'GROOMEE') % left y-axis
ylabel(hAx(2),'GROOMER') % right y-axis
grid on
axis(hAx(1),[0 length(xpos)+1 0 ymax])
axis(hAx(2),[0 length(xpos)+1 0 ymax])
set(hAx(1),'XTick',0:2:length(xpos)+1)
set(hAx(1),'YTick',0:floor(1+(ymax/6)):ymax)
set(hAx(2),'YTick',0:floor(1+(ymax/6)):ymax)
set(hAx(1),'YColor',[255,105,0]/255)
set(hAx(2),'YColor',[0,1,1])
set(s1,'Color',[255,105,0]/255)
set(p1,'Color',[0,1,1])
set(p1,'Marker','x')
set(gca,'Color',[d d d])
pause(dt)
end

