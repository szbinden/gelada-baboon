function [  ] = plotvide( a,b,c,d,dt )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global xpos vict defe
if max(vict) < max(defe)
    ymax = 5*ceil((max(defe)+1)/5);
else
    ymax = 5*ceil((max(vict)+1)/5);
end
subplot(a,b,c)
[hAx,s1,p1] = plotyy((1:length(xpos))',vict,(1:length(xpos))',defe,'stem','stem');


ylabel(hAx(1),'VICTORIES') % left y-axis
ylabel(hAx(2),'DEFEATS') % right y-axis
grid on
axis(hAx(1),[0 length(xpos)+1 0 ymax])
axis(hAx(2),[0 length(xpos)+1 0 ymax])
set(hAx(1),'XTick',0:2:length(xpos)+1)
set(hAx(1),'YTick',0:floor(1+(ymax/6)):ymax)
set(hAx(2),'YTick',0:floor(1+(ymax/6)):ymax)
set(hAx(1),'YColor','g')
set(hAx(2),'YColor','r')
set(s1,'Color','g')
set(p1,'Color','r')
set(p1,'Marker','x')
set(gca,'Color',[d d d])
pause(dt)
end

