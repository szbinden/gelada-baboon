function [  ] = plotgegr( a,b,c,d,dt )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global xpos grme grmr
if max(grmr) < max(grme)
    gmax = 5*ceil((max(grme)+1)/5);
else
    gmax = 5*ceil((max(grmr)+1)/5);
end
subplot(a,b,c)
sbp5 = stem((1:length(xpos))',grme);
sbp5.Color = 'b';
sbp5.Marker = 'o';
hold on,grid on
sbp6 = stem((1:length(xpos))',grmr);
sbp6.Color = 'm';
sbp6.Marker = 'x';
hold off
axis([0 length(xpos)+1 0 gmax])
set(gca,'Color',[d d d])
pause(dt)
end

