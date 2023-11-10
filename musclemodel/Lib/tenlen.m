function [lt] = tenlen( fmmax, c, ltr, fm);

%  purpose - to compute the change in length of the tendon due to a given 
%  -------   muscle force
%
%  lt = tenlen( fmax, c, ltr, fm);
%
%  John H. Challis, The Penn. State University
%  February 23, 1998
%
%  input
%  -----
%  fmmax  - maximum isometric force possible by muscle
%  c      - extension of tendon at fmmax expressed as fraction of tendon length
%  ltr    - the resting length of the tendon
%  fm     - current muscle force
%
%  output
%  ------
%  lt  - the current length of the tendon
%

constant = c / fmmax;

%  compute length
%
lt = ltr + (ltr * constant * fm);

%
%%%THE END%%%
%

