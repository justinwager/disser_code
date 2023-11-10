function [fp] = forcpec( lf, lpecr, spec)

%  pupose - compute force produced by a muscles parallel elastic component at
%  ------   a given length
%
%  John H. Challis, The Penn. State University
%  February 20, 2000
%
%  calling
%  -------
%  fp = forclen( lf, lpecr, x)
%
%  input
%  -----
%  lf    - current length of fiber
%  lpecr - resting length of parallel elastic component
%  spec  - model scale parameter
%
%  output
%  ------
%  fp    - force produced by parallel elastic component
%
%  note
%  ----
%  1)  Model used is Fp = spec * delta(lpec)^3
%  2)  Assumption is that length of pec changes as muscle fiber length changes.
%

if lf < lpecr
   fp = 0.0;
%
else
% 
   fp = (lf-lpecr) * (lf-lpecr) * (lf-lpecr) * spec;
end

%
%%%The End%%%
%

