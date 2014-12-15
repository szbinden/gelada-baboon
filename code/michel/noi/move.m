function [ y ] = move( x,s,d )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global field_size
% move towards point 0/0 when overshot 90% of field space
if abs(x) > (field_size/2)*0.9
    y = x-(x*s);
% move randomly
else
    y = x+d*s;
    if -field_size/2 > abs(y) || field_size/2 < abs(y)
        y = x+d*-s;
    end
end

