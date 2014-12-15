function [  ] = plotanx( a,b,c,d,dt )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
global xpos anx anx_avrg
% define the limit for the y-axes
if max(anx) < max(anx_avrg)
    ymax = floor(max(anx_avrg))+1;
else
    ymax = floor(max(anx))+1;
end

subplot(a,b,c)
[hAx,s1,p1] = plotyy((1:length(xpos))',anx,(1:length(xpos))',anx_avrg,'stem','plot');


ylabel(hAx(1),'ANX') % left y-axis
ylabel(hAx(2),'ø-ANX') % right y-axis
grid on
axis(hAx(1),[0 length(xpos)+1 0 ymax])
axis(hAx(2),[0 length(xpos)+1 0 ymax])
set(hAx(1),'XTick',0:2:length(xpos)+1)
set(hAx(1),'YTick',0:floor(1+(ymax/6)):ymax)
set(hAx(2),'YTick',0:floor(1+(ymax/6)):ymax)
set(hAx(1),'YColor','k')
set(hAx(2),'YColor',[50,177,65]/255)
set(s1,'Color','k')
set(p1,'Color',[50,177,65]/255)
set(gca,'Color',[d d d])
pause(dt)
end

