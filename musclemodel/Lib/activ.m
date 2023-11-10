function [qdot] = activ( t, q)

%  purpose - computes muscle active state (q) given net neural excitation (u)
%  -------
%
%  John H. Challis, The Penn. State University
%  May 15, 1999
%
%  calling
%  -------
%  [adot] = activ( t, q)
%
%  input
%  -----
%  q - initial condition for active state
%
%  output
%  ------
%  qdot - first derivative of active state of the muscle 0.0 >= u >= 1.00
%
%  working
%  -------
%  trise - constant for time of rise of active state
%  tfall - constant for time of fall of active state
%  qmin - minimum active state
%
%  global
%  ------
%  u - current level of neural excitation 0.0 >= u >= 1.00
%
global u


%  constants
%
trise = 1 / 0.020;
tfall = 1 / 0.200;
qmin  = 0.005;


%  the ODE-
%
qdot = ( (trise) * (u - q) * (u) ) + ( (tfall) * (u - (q - qmin) - (u - q)*u ) );


%
%%%The End%%%
%
