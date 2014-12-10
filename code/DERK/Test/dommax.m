function [ king ] = dommax(dom)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dom_j = dom(1);
nr_j = 1;
for j = 2:length(dom)
if dom(j) > dom_j
    dom_j = dom(j);
    nr_j = j;
    
end   
    
    king = nr_j;
end

