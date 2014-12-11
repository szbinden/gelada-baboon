function [  ] = plotdom( a,b,c,d,dt )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global xpos dom dom_avrg
if max(dom) < max(dom_avrg)
    fdmax = floor(max(dom_avrg))+1;
else
    fdmax = floor(max(dom))+1;
end
subplot(a,b,c)
sbp3 = stem((1:length(xpos))',dom_avrg);
sbp3.Color = [50,177,65]/255;
sbp3.Marker = 'o';
hold on,grid on
sbp4 = stem((1:length(xpos))',dom);
sbp4.Color = 'k';
sbp4.Marker = 'o';
hold off
axis([0 length(xpos)+1 0 fdmax])
set(gca,'Color',[d d d])
pause(dt)
end

