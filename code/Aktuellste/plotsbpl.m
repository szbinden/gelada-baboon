function [  ] = plotsbpl( mode,dt )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dspy = 0.95;

if strcmp(mode,'none')
    % don't plot any subplots
elseif strcmp(mode,'position')
    % don't plot any subplots
elseif strcmp(mode,'condition')
    plotgegr(1,3,1,dspy,dt)
elseif strcmp(mode,'ranking')
    plotvide(1,3,1,dspy,dt)
elseif strcmp(mode,'fighting')
    plotvide(2,3,3,dspy,dt)
    plotdom(2,3,6,dspy,dt)
elseif strcmp(mode,'grooming')
    plotgegr(2,3,3,dspy,dt)
    plotanx(2,3,6,dspy,dt)   
elseif strcmp(mode,'all')
    plotvide(4,3,3,dspy,dt)
    plotdom(4,3,6,dspy,dt)
    plotgegr(4,3,9,dspy,dt)
    plotanx(4,3,12,dspy,dt)    
end
end

