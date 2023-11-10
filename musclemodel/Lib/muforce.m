function [lfp, ltp, vfp, flp, fmp] = muforce( dt, w, lfopt, fmmax, ltr, c, k, vfmax, tstiff, qc, flc, fmc, vfc, lfc, lmt, vmt );

%  purpose - to compute muscle force
%  -------
%
%  John H. Challis, The Penn. State University - March 5, 2002  (original - June 10, 1999)
%
%  calling
%  -------
%  [lfp, ltp, vfp, flp, fmp] = muforce( dt, w, lfopt, fmmax, ltr, c, k, vfmax, tstiff, qc, flc, fmc, vfc, lfc, lmt, vmt );
%
%  input
%  -----
%  dt     - integration step time interval
%  w      - width parameters for force-length curve
%  lfopt  - optimum length of muscle fibers
%  fmmax  - maximum isometric force
%  ltr    - resting length of tendon
%  c      - extension of tendon at fmmax
%  k      - shape parameter for force-velocity curve
%  vfmax  - maximum velocity of shortening of muscle
%  tstiff - stiffness of tendon
%  qc     - current active state of muscle
%  flc    - current normalized force-length output of muscle
%  fmc    - current muscle force
%  vfc    - current velocity of muscle fibers
%  lfc    - current length of muscle fibers
%  lmt    - current length of muscle-tendon complex
%  vmtc   - current velocity of muscle-tendon complex
%
%  output
%  ------
%  lfp  - predicted length of muscle fibers
%  ltp  - predicted length of tendon
%  vfp  - predicted velocity of muscle fibers
%  flp  - predicted normalized force-length output of muscle
%  fmp  - predicted muscle force
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           %
%  compute fl contribution  %
%                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          
ltp = tenlen( fmmax, c, ltr, fmc);
lfp = lmt - ltp;
flp = forclen( lfp, lfopt, w);
% disp('ltp')
% disp(ltp)
% disp('lfp')
% disp(lfp)
% disp('flp')
% disp(flp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           %
%  compute fv contribution  %
%                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          
fv = fmc / (qc * flc * fmmax);
% fv = forcvel(vfc,vfmax,k);
% fv = fmc / (qc * flp * fmmax);
% disp('fmc')
% disp(fmc)
% disp('qc')
% disp(qc)
% disp('flc')
% disp(flc)
% disp('fmmax')
% disp(fmmax)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                      %
%  compute current velocity of fibers  %
%                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vfp = velforc( fv, vfmax, k);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              %
%  compute velocity of tendon  %
%                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vt  = (vmt - vfc);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                            %
%  solve ODE using simple Euler integration  %
%                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fmp = fmc + (tstiff * vt * dt);


%
%%
%%%The End%%%
%%
%

%  archive notes
%  -------------
% In the old version the following was used,
%
%  solve ODE using Runge-Kutta
% 
% t0 = 0.0; 
% [t,a] = ode23( 'dfdt', [t0 t0+dt], fmc);
%  extract required value
% n = size(a,1); 
% fmp = a(n);
%
%  Where the following function is defined
%  
% function [fmdot] = dfdt( t, f0)
%  purpose - present the following ODE df/dt = K.Vt
%  -------
%  John H. Challis, The Penn. State University
%  June 10, 1999
%  calling
%  -------
%  [fmdot] = dfdt( t, f0)
%  input
%  -----
%  t     - time (not used)
%  f0    - initial muscle force
%  output
%  ------
%  fmdot - rate of change of muscle force with respect to time
%  global
%  ------
%  vt      - change in length of tendon with respect to time
%  tstiff  - stiffness of tendon
%
% global vt tstiff
% fmdot = tstiff * vt;
%
%
%
