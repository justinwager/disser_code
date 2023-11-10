function [uvec] = unit(mk1,mk2)

vec = mk2-mk1;
mag = norm(mk2-mk1);

uvec = vec/mag;