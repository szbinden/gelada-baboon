function [ y ] = move( x,d,s )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global field_size
% move towards point 0.5/0.5 when overshot 90% of field size and no one in
% sight
if abs(x) > (field_size/2)*0.9
    y = x-(x*s);
% move randomly
else
    y = x+d*s;
    if -field_size/2 > y || field_size/2 < y
        y = x+d*-s;
    end
end

