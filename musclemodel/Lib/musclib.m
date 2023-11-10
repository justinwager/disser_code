%  musclib - routine to introduce the all base routines used in musclelab.
%  -------
%
%  John H. Challis, The Penn. State University
%  January 14, 2002
%
%  Notes
%  -----
%  currently provides basic descriptions of
%  demo1, demo2, demo3, demofl , demofv, demolt, demoq   
%
%
clear


%%%%%%%%%%%%%%%%%%
%                %
%  introduction  %
%				     %
%%%%%%%%%%%%%%%%%%
disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');
disp('musclib - there follows a list and brief description of the library functions in MUSCLELAB.')
disp('=======')
disp('  ')


%%%%%%%%%%%%%%%%%%%%%%
%                    %
%  list starts here  %
%                    %
%%%%%%%%%%%%%%%%%%%%%%
disp('activ - computes muscle active state (q) given net neural excitation (u), (called by actstate)')
disp('-----')
%
%
disp('actstate - computes active state of muscle, (calls activ)')
disp('--------')
%
%
disp('dfdt - ODE df/dt = K.Vt (called by muforce)')
disp('----')
%
%
disp('forclen - computes force produced by a muscle at given length')
disp('-------')
%
%
disp('forcpec - computes force produced by a muscles parallel elastic component at a given length')
disp('-------')
%
%
disp('forcvel - compute force contribution at given velocity of muscle fibers, based on Hill (1938) work')
disp('-------')
%
%
disp('sometr - computes muscle force under isometric conditions')
disp('------')
%
%
disp('muforce - computes muscle force, considering all current conditions of the muscle, (calls dfdt)')
disp('-------')
%
% 
disp('tenlen - to compute the change in length of the tendon due to a given muscle force')
disp('------')
%
%
disp('velforc - compute velocity of a muscle given current force contribution')
disp('-------')
%
%
disp('  '), disp('  '), disp('  '), disp('  ')


%
%%
%%%The End%%%
%%
%

