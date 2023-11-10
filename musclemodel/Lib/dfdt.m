function [fmdot] = dfdt( t, f0)

%  purpose - present the following ODE df/dt = K.Vt
%  -------
%
%  John H. Challis, The Penn. State University
%  June 10, 1999
%
%  calling
%  -------
%  [fmdot] = dfdt( t, f0)
%
%  input
%  -----
%  t     - time (not used)
%  f0    - initial muscle force
%
%  output
%  ------
%  fmdot - rate of change of muscle force with respect to time
%
%  global
%  ------
%  vt      - change in length of tendon with respect to time
%  tstiff  - stiffness of tendon
%

global vt tstiff
%
fmdot = tstiff * vt;

%
%%
%%%The End%%%
%%
%

