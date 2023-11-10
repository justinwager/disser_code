%  demo2
%  -----
%
%  purpose - to model the twitch response of a muscle tendon complex 
%  ------- 
% 
%  John H. Challis, The Penn. State University 
%  June 9, 1999 
% 
% 
%  key parameters/variables 
%  ------------------------ 
%  ltr    - resting length of tendon
%  c      - extension of tendon under fmmax
%  fmmax  - maximum isometric force the muscle can produce
%  lfopt  - optimal fiber length
%  w      - shape parameter for force length properties
%  vfmax  - maximum velocity of fiber shortening
%  k      - constant for force velocity properties
%  lmt    - length of the muscle-tendon complex
%  vmt    - velocity of the muscle-tendon complex
%  u      - neural excitation 
%  q      - active stata
%  fm     - muscle force produced
%  tstiff - stiffness of tendon
% 
%  calls 
%  ----- 
%  forclen
%  muforce
%  actstate
%

%%%%%%%%%%%%%
%  tidy-up  %
%           %
%%%%%%%%%%%%%
clear all
close all
clf

%%%%%%%%%%%%%%%%%%%%%%%
%                     %
%  paths for m files  %
%                     %
%%%%%%%%%%%%%%%%%%%%%%%
path(path,'musclemodel/Lib')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                    %
%  define global variables           %
%  1.  for active state dynamics     %
%  2.  for estimating muscle forces  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global u

%%%%%%%%%%%%%%%%%%
%                %
%  introduction  %
%                %
%%%%%%%%%%%%%%%%%%
disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');
disp('demo2 - the figure shows the twitch response of a hypothetical muscle.')
disp('-----   Neural excitations occurs for the first 5 ms only.')
disp('        (This can take some time.)')
disp('(Model parameters - w = 0.60, lfopt = 40, fmmax = 1000')
disp('                    vfmax = 40 * 6, k = 4')
disp('                    ltr = 60, c = 0.04)')
disp('  ')

%%%%%%%%%%%%%%%%%%%%%%
%                    %
%  model parameters  %
%                    %
%%%%%%%%%%%%%%%%%%%%%%
w = 0.60;            %  width of force length curve
lfopt = 40;			 %  optimum length of fibers
fmmax = 1000;        %  maximum isometric force
%
vfmax = 40 * 6;		 %  maximum velocity of shortening
k = 4;               %  shape parameters for force-velocity relationship
%
ltr = 60;            %  resting length of tendon
c = 0.04; 			 %  tendon extension at fmmax
%
tstiff = fmmax / (c * ltr);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  time base, neural excitation, active state, %
%  muscle-tendon length and velocity           %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt = 0.001;
%
t=0.0:dt:1.0;
n = size(t,2);
%
for i=1:n
%
if t(i) < 0.005
   q(i)  = 1.0;
   us(i) = 1.0;
else
   q(i)  = 0.0;
%    us(i) = 0.0;
end
us = interp1(0:0.001:pi, sin(0:0.001:pi), linspace(0,pi, n));
%
lmt(i) = 100;
vmt(i) = 0.0;
%
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          %
%  set initial conditions  %
%                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% q(1)  = 0.5;
% us(1) = 1.0;
%
lt(1) = 60;
lf(1) = 40;
fl(1) = forclen( lf(1), lfopt, w);
fm(1) = q(1) * fl(1) * fmmax;
fv(1) = fm(1) / (q(1) * fl(1) * fmmax);
vf(1) = velforc(fv, vfmax, k);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          %
%  estimate muscle forces  %
%                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=2:n
%
[lf(i),lt(i),vf(i),fl(i),fm(i)]=muforce(dt,w,lfopt,fmmax,ltr,c,k,vfmax,tstiff,q(i-1),fl(i-1),fm(i-1),vf(i-1),lf(i-1),lmt(i-1),vmt(i-1) );
%
u = us(i);
%
[q(i)] = actstate( dt, q(i-1) );
if t(i) < 0.005
	q(i) = 1.0;
end
%
end

%%%%%%%%%%%%%%%%%%
%                %
%  plot results  %
%                %
%%%%%%%%%%%%%%%%%%
%
%  change time to milliseconds
%
t = t*1000;
%
subplot(2,2,1) 
plot( t, q) 
ylabel('Active state') 
title('Model active state')
box off
%
subplot(2,2,2) 
plot( t, vf) 
ylabel('Velocity of Fibers (units/s)') 
title('Velocity of muscle fiber')
box off
% 
subplot(2,2,3) 
plot( t, lf) 
ylabel('Length of Fibers (arbitrary units)') 
xlabel('Time (ms)')
title('Length of muscle fibers')
box off
% 
subplot(2,2,4) 
plot( t, fm) 
ylabel('Muscle Force (N)') 
xlabel('Time (ms)') 
title('Muscle force') 
box off

%%%%%%%%%%%%%%%%%%
%                %
%  remove paths  %
%                %
%%%%%%%%%%%%%%%%%%
rmpath 'Lib'
%%%%%%%%%%%%%%%%%%%
%                 %
%  final message  %
%                 %
%%%%%%%%%%%%%%%%%%%
disp('Analysis Complete')
disp('*****************')
%
%%
%%%The End%%%
%%
%
