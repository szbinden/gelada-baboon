function [  ] = plotdom( a,b,c,d,dt )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global xpos dom dom_avrg
% define the limit for the y-axes
if max(dom) < max(dom_avrg)
    ymax = floor(max(dom_avrg))+1;
else
    ymax = floor(max(dom))+1;
end
subplot(a,b,c)
[hAx,s1,p1] = plotyy((1:length(xpos))',dom,(1:length(xpos))',dom_avrg,'stem','plot');

ylabel(hAx(1),'DOM') % left y-axis
ylabel(hAx(2),'ø-DOM') % right y-axis
grid on
axis(hAx(1),[0 length(xpos)+1 0 ymax])
axis(hAx(2),[0 length(xpos)+1 0 ymax])
set(hAx(1),'xTick',0:2:length(xpos)+1);
set(hAx(1),'YTick',0:ymax)
set(hAx(2),'YTick',0:ymax)
set(hAx(1),'YColor','k')
set(hAx(2),'YColor',[50,177,65]/255)
set(s1,'Color','k')
set(p1,'Color',[50,177,65]/255)
set(gca,'Color',[d d d])
pause(dt)
end

