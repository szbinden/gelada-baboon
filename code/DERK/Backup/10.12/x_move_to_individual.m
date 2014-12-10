function [ x_i_new ] = x_move_to_individual( x_i, y_i, x_neigh, y_neigh, displace)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%calculate distance btw the two baboons
dist = norm([x_neigh,y_neigh]-[x_i,y_i]);

%calculate x component of the normalized vector pointing from i to nearest neighbour)
delta_x = (x_neigh - x_i)/dist;

%calculate x component of move vector(so that i is 'displace' away from neighbour)
displ_x = delta_x*(dist-displace);

% new x coordinate (old coordinate + displacement)
x_i_new = x_i + displ_x;
end