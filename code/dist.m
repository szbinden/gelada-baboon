% function for distance between agents
function [dist] = dist(i_x, i_y, j_x, j_y)
dist = sqrt( (i_x-j_x)*(i_x-j_x) + (i_y-j_y)*(i_y-j_y) );
end