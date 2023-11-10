function [fm, lf, lt] = isometr( lmt, lfopt, w, ltr, c, fmmax, q)

%  purpose - to compute muscle force under isometric conditions
%  -------
%
%  John H. Challis, The Penn. State University
%  June 20, 1999
%
%  calling
%  -------
%  [fm, lf, lt] = isometr( lmt, lfopt, w, ltr, c, fmmax, q)
%
%  input
%  -----
%  lmt   - current length of muscle-tendon complex
%  lfopt - optimum length of muscle fibers
%  w     - width parameters for force-length curve
%  ltr   - resting length of tendon
%  c     - extension of tendon at fmmax
%  fmmax - maximum isometric force
%  q     - current active state of muscle
%
%  output
%  ------
%  fm	 - predicted muscle force
%  lf	 - predicted length of muscle fibers
%  lt    - predicted length of tendon
%
%  calls
%  -----
%  forclen( lf, lfopt, w);
%  tenlen
%
%  notes
%  -----
%  1)  20 iterations performed to compute fm, lf, lt
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                               %
%  initial estimate of length of muscle fibres  %
%												%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lf = lmt - ltr;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                      %
%  interatively estimate muscle force  %
%                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:20
%  compute muscle force
%
[fl] = forclen( lf, lfopt, w);
%
fm = q * fmmax * fl;
%  compute length of tendon
%
[lt] = tenlen( fmmax, c, ltr, fm);
%  new estimate of fiber length
%
lf = lmt - lt;
%
end


%
%%
%%%The End%%%
%%
%

