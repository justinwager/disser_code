function [solPercChange, gastrocPercChange] = grieve(theta1, theta2)
% calculate soleus and gastroc perc change from reference position, using equations of 
% Grieve, Pheasant, & Cavanagh (1978)
%
% input:  theta1            - ankle angle in degrees (standing reference position =
%                             90 degrees)
%         theta2            - knee angle in degrees
%
% output: solPercChange     - percent change (of seg length) of soleus mtu
%         gastrocPercChange - percent change (of seg length) of gastroc mtu

anklePercChange = -22.18468 + 0.30141*theta1 - 0.00061*theta1.^2;
kneePercChange = 6.46251 - 0.07987*theta2 + 0.00011*theta2.^2;

solPercChange = anklePercChange / 100;
gastrocPercChange = (anklePercChange + kneePercChange) / 100;
