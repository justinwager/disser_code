function [local] = getLocalCoords(R,V,glob)

local = R' * (glob - V);
