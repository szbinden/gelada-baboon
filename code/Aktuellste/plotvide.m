function [  ] = plotvide( a,b,c,d,dt )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global xpos vict defe
if max(vict) < max(defe)
    fmax = 5*ceil((max(defe)+1)/5);
else
    fmax = 5*ceil((max(vict)+1)/5);
end
subplot(a,b,c)
sbp1 = stem((1:length(xpos))',vict);
sbp1.Color = 'g';
sbp1.Marker = 'o';
hold on,grid on
sbp2 = stem((1:length(xpos))',defe);
sbp2.Color = 'r';
sbp2.Marker = 'x';
hold off
axis([0 length(xpos)+1 0 fmax])
set(gca,'Color',[d d d])
pause(dt)
end

