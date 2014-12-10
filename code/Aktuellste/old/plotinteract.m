function [  ] = plotinteract( x,y,a,p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% defeated
if a == 0
    text(x, y, 'D', 'VerticalAlignment',p, 'HorizontalAlignment','right','Color','r','FontWeight','bold','FontSize',14)
% victorious
elseif a == 1
    text(x, y, 'V', 'VerticalAlignment',p, 'HorizontalAlignment','right','Color','g','FontWeight','bold','FontSize',14)
% was groomed
elseif a == 2
    text(x, y, 'Ge', 'VerticalAlignment',p, 'HorizontalAlignment','right','Color','b','FontWeight','bold','FontSize',14)
% groomed
elseif a == 3
    text(x, y, 'Gr', 'VerticalAlignment',p, 'HorizontalAlignment','right','Color','m','FontWeight','bold','FontSize',14)
% no interaction
else
    text(x, y, '-', 'VerticalAlignment',p, 'HorizontalAlignment','right','Color','k','FontWeight','bold','FontSize',14)
end
pause(0.5)
end

