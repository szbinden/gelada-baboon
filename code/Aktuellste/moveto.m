function [ y ] = moveto( xi,xn,s,d )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% i moves towards nearest by the given distance and diretion (closest distance)
y = xi + (xn-xi)/s*(s-d);
end