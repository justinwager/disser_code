function [vf] = velforc( fv, vfmax, k)

%  purpose - compute velocity of a muscle given current force contribution
%  -------
%
%  John H. Challis, The Penn. State University
%  April 28, 1998
%
%  calling
%  -------
%  [vf] = velforc( fv, vfmax, k)
%
%  input
%  -----
%  fv    - fraction of maximum isometric force for current length at current velocity
%  vfmax - maximum muscle fiber contraction velocity
%  k     - model shape parameter
%
%  output
%  ------
%  vf    - current velocity of fibers
%
%  notes
%  -----
%  1)  Uses equation of Hill (1938) for concetric phase
%  2)  Uses equation of Fitzhugh (1977) for eccentric phase
%  3)  Muscle shortenining is a positive velocity
%  4)  Muscle lengthening is a negative velocity
%  5)  Maximum eccentric force is assumed to be 1.5*fmmax
%


%%%%%%%%%%%%%%%%%%%%%%%%%
%                       %
%  isometric condition  %
%                       %
%%%%%%%%%%%%%%%%%%%%%%%%%
if fv == 1.0
   vf = 0.0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        %
%  concentric condition  %
%                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%
if fv < 1.0
  vf = -1 * ( (vfmax*fv - vfmax) / (fv*k+1) ); 
end


%%%%%%%%%%%%%%%%%%%%%%%%%
%                       %
%  eccentric condition  %
%                       %
%%%%%%%%%%%%%%%%%%%%%%%%%
if fv > 1.0
  vf = 2 * ( (vfmax*fv - vfmax) / (4*fv*k-6*k -1) ); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                %
%  change direction of velocity  %
%                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vf = -1 * vf;


%
%%%The End%%%
%

