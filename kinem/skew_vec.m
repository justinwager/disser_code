function avec = skew_vec( amat )
% rip vector from skew symmetric matrix
%
% INPUT
% amat = 3x3 matrix
%
% OUTPUT
% avec = 3x1 vector
%
% REFERENCE
% Haug, Computer-Aided Kinematics and Dynamics of Mechanical Systems, Allyn-Bacon, 1989
%
% UPDATE
% 12.04.23, tested under MATLAB v5.2
%
% AUTHOR
% H.J. Sommer III, Ph.D., Professor of Mechanical Engineering, 337 Leonhard Bldg
% The Pennsylvania State University, University Park, PA  16802
% (814)863-8997  FAX (814)865-9693  hjs1@psu.edu  www.me.psu.edu/sommer/

avec(3,1) = -amat(1,2);
avec(2,1) =  amat(1,3);
avec(1,1) = -amat(2,3);

% bottom of skew_vec

