function [ dist ] = dist(xpos,ypos,i,j)
% UNTITLED Summary of this function goes here
% Detailed explanation goes here

dist = norm([xpos(i),ypos(i)]-[xpos(j),ypos(j)]);

end
