function [  ] = plotanx( a,b,c,d,dt )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
global xpos anx anx_avrg
if max(anx) < max(anx_avrg)
    famax = floor(max(anx_avrg))+1;
else
    famax = floor(max(anx))+1;
end
subplot(a,b,c)
sbp7 = stem((1:length(xpos))',anx_avrg);
sbp7.Color = [50,177,65]/255;
sbp7.Marker = 'o';
hold on,grid on
sbp8 = stem((1:length(xpos))',anx);
sbp8.Color = 'k';
sbp8.Marker = 'o';
hold off
axis([0 length(xpos)+1 0 famax])
set(gca,'Color',[d d d])
pause(dt)
end

