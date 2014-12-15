function [  ] = plotsbpl( mode,dt )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dspy = 0.95;

if strcmp(mode,'none')
    % don't plot any subplots  
else
    plotvide(4,3,3,dspy,dt)
    plotdom(4,3,6,dspy,dt)
    plotgegr(4,3,9,dspy,dt)
    plotanx(4,3,12,dspy,dt)    
end
end

