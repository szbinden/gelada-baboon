function [  ] = plotPGspecs( d )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
global field_size spawning_size i
cla, grid on
    title('GELADA BABOON - PLAYGROUND')
    rectangle('Position',[-spawning_size/2,-spawning_size/2,spawning_size,spawning_size])
    text(-0.1,-0.1,int2str(i))
    set(gca,'Color',[d d d])
    axis([-field_size+1 field_size -field_size+1 field_size]);  % set field size
end

