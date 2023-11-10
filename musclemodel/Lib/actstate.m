function [q] = actstate( dt, q0)

%  purpose - to compute active state of muscle
%  -------
%
%  John H. Challis, The Penn. State University
%  May 15, 1999
%
%  calling
%  -------
%  [q] = actstate( dt, q0)
%
%  input
%  -----
%  dt    - interval of time for which neural excitation applies
%  q0    - current active state of the muscle
%
%  output
%  ------
%  q    - current active state of the muscle 0.0 >= q >= 1.00
%
%  calls
%  -----
%  ode23
%  activ
%

%  initial conditions
%
t0 = 0.0;
tf = dt;

%  solve ODE
%
[t,a] = ode23('activ',[t0 tf], q0);


%  extract required value
%
n = size(a,1);
q = a(n);


%
%%%The End%%%
%

