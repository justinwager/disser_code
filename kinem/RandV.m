function [ R, V, rmsd] = RandV( x, y)

%  purpose - algorithm to determine rigid body attitude matrix and translation vector
%  -------
%
%  author - John H. Challis, The Penn. State University (May 25, 1999)
%  ------
%
%  calling -  [ R, V, rmsd] = RandV( x, y)
%  -------
%
%  inputs
%  ------
%  x - 3D marker coordinates in one reference frame or position 1 
% (JW comment - e.g., local)
%  y - 3D marker coordinates in second reference frame or position 2
%  
%  output
%  ------
%  R    - attitude matrix (sometimes called rotation matrix)
%  V    - translation vector
%  rmsd - root mean square difference of fit
%
%  Notes
%  -----
%  1)  The input data are in the following format,
%      x(i,1:3) - x, y, z coordinates of the ith point
%  2)  There must be >= 3 points for this routine to work.
%  3)  R and V are determined in a least-squares sense.
%  4)  This algorithm is based on Challis, J. H. (1995)
%      "A procedure for determining rigid body transformation parameters."
%       Journal of Biomechanics 28(5): 733-737.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        %
%  how many data points  %
%                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%
[ n, m] = size(x);


%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        %
%  Compute mean vectors  %
%                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%
meanx = mean( x );
meany = mean( y );


%%%%%%%%%%%%%%%%%%%%%
%                   %
%  Compute A and B  %
%                   %
%%%%%%%%%%%%%%%%%%%%%
for i=1:n
   A(i,:) = x(i,:) - meanx;
   B(i,:) = y(i,:) - meany;
end
%
A = A';
B = B';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %
%  compute cross-dispersion matrix  %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C = B * A';


%%%%%%%%%%%%%%%%%%%%%%%
%                     %
%  compute SVD and R  %
%                     %
%%%%%%%%%%%%%%%%%%%%%%%
[ U,W, V] = svd( C );
%
W = diag([1 1 det( U * V' )] );
%
R= U * W * V';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              %
%  compute translation vector  %
%                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V = meany' - ( R * meanx' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Compute root mean square difference of fit  %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ssq = 0;
%
for i=1:n
	yest = (R * x(i,:)') + V;
	ssq = ssq + norm( yest - y(i,:)')^2;
end
%
rmsd = sqrt( ssq /3 / n);


%
%%
%%% The End %%%
%%
%

