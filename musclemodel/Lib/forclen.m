function [fl] = forclen( lf, lfopt, w)

%  pupose - compute force produced by a muscle at given length
%  ------
%
%  John H. Challis, The Penn. State University
%  April 28, 1998
%
%  calling
%  -------
%  fl = forclen( lf, lfopt, w)
%
%  input
%  -----
%  lf    - current length of fiber
%  lfopt - optimum length of muscle fiber
%  w     - model width parameter
%
%  output
%  ------
%  fl    - fraction of maximum isometric force muscle can produce at current
%          length
%

part = (lf - lfopt) / (w * lfopt);
fl = (1.0 - (part.^2) ); 

%
%
if (fl < 0.0)
fl = 0.0;
end

%
%%
%%%The End%%%
%%
%

