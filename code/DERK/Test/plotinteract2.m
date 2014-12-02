function [  ] = plotinteract2( i,nearest,x,y,a, )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% interaction
if a == 0
    text(x, y, num2str(i),'Color','y','FontWeight','bold','FontSize',14)
% win
elseif a == 1
    text(x, y, num2str(i),'Color','g','FontWeight','bold','FontSize',14)
% loss
elseif a == 2
    text(x, y, num2str(i),'Color','r','FontWeight','bold','FontSize',14)
% after grooming
elseif a == 3 | a == 4
    text(x, y, num2str(i),'Color','m','FontWeight','bold','FontSize',14)
% no interaction
else
    text(x, y, num2str(i),'Color','k','FontWeight','bold','FontSize',14)
end
pause(0.5)
end

