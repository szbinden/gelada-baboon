function [ y ] = move( x,d,figg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% move towards point 0.5/0.5
if abs(0.5-x) > (figg-0.5)*0.9
    y = x+(0.5-x)*d;
    while -figg+1 > y || figg < y
        y = x+d*sin(2*pi*rand);
    end
% move randomly
else
    y = x+d*cos(2*pi*rand);
    while -figg+1 > y || figg < y
        y = x+d*sin(2*pi*rand);
    end
end

