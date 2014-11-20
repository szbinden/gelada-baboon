function [ y ] = move( x,d,figg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
y = x+d*cos(2*pi*rand);
while -figg+1 > y || figg < y
    y = x+d*cos(2*pi*rand);
end

end

