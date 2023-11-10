function [fv] = forcvel( vf, vfmax, k)

%  purpose - compute force contribution at given velocity of muscle fibers, based on Hill (1938) work
%  -------
%
%  John H. Challis, The Penn. State University
%  April 28, 1998
%
%  calling
%  -------
%  [fv] = forcvel( vf, vfmax, k)
%
%  input
%  -----
%  vf    - current velocity of fibers
%  vfmax - maximum muscle fiber contraction velocity
%  k     - model shape parameter
%
%  output
%  ------
%  fv    - fraction of maximum isometric force for current length at current velocity
%
%  notes
%  -----
%  1)  Uses equation of Hill (1938) for concetric phase
%  2)  Uses equation of Fitzhugh (1977) for eccentric phase
%  3)  Muscle shortenining is a positive velocity
%  4)  Muscle lengthening is a negative velocity
%  5)  Maximum eccentric force is assumed to be 1.5*fmmax
%
%  change direction of velocity
%
vf1 = -1 * vf;

%  isometric condition
if vf1 == 0
   fv = 1.0;
end

%  concentric condition
if vf1 > 0
  fv = (vfmax - vf1) / (vfmax + k * vf1);
end

%  eccentric condition
if vf1 < 0
  k = k * 2;
  fv = 1.5 - 0.5 * ( (vfmax + vf1) / (vfmax - k * vf1) );
end
%
%%%The End%%%
%

