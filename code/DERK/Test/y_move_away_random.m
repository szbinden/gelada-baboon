function [ y_new ] = y_move_away_random(y, flee_dist, rand)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% move towards point 0.5/0.5 when overshot 90% of field size
%if abs(0.5-x) > (f-0.5)*0.9
%    y = x+(0.5-x)*d;
% move randomly
%else
%    y = x+d*cos(2*pi*rand);
 %   while -f+1 > y || f < y
 y_new = y+flee_dist*sin(2*pi*rand);
 %   end
end

