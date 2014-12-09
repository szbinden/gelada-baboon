function [ y_i_new ] = y_move_to_individual( x_i, y_i, x_neigh, y_neigh, displace)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%calculate distance btw the two baboons
dist = norm([x_neigh,y_neigh]-[x_i,y_i]);

%calculate y component of the normalized vector pointing from i to nearest neighbour)
delta_y = (y_neigh - y_i)/dist;

%calculate y component of move vector(so that i is 'displace' away from neighbour)
displ_y = delta_y*(dist-displace);

%new y coordinate (old coordinate + displacement)
y_i_new = y_i+displ_y;
end