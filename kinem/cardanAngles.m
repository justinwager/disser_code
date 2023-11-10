function [ angles ] = cardanAngles( R, seq )

%  purpose - to compute angles from attitude matrix
%  -------
%
%  John H. Challis, Penn. State University (July 10, 1999)
%
%  calling - [ angles ] = R_to_Angles( R, seq )
%  -------
%
%  input
%  -----
%  R - attitude matrix
%  seq - angle sequence, where 1 corresponds to rotation about X axis
%                              2 corresponds to rotation about Y axis
%                              3 corresponds to rotation about Z axis                                
%
%  output
%  ------
%  angles - attitude angles
%
%  notes
%  -----
%  1)  The routine produces Cardanic angle sequences only.
%  2)  The cyclic patterns are:         X-Y-Z, Y-Z-X, Z-X-Y  ([ 1 2 3 ], [ 2 3 1], [ 3 1 2 ])
%                                       R = Ri( angle(i) ) * Rj( angle(j) ) * Rk( angle(k) )
%  3)  The anti-cyclic patterns are:    X-Z-Y, Y-X-Z, Z-Y-X  ([ 1 3 2 ], [ 2 1 3], [ 3 2 1 ])
%                                       R = Rk( angle(k) ) * Rj( angle(j) ) * Ri( angle(i) )
%  4)  Ths routine is based on the algorithm described by,
%      Woltring, H. J. (1992)  One hundred years of photogrammetry in biolocomotion.
%      In Biolocomotion: A Century of Research using Moving Pictures. (Editors Cappozzo, A., M. Marchetti & V. Tosi)
%      pp. 199-225. Promograph. Italy.
%


%%%%%%%%%%%%%%%%%%%%%%%%%
%                       %
%  set tolerance level  %
%                       %
%%%%%%%%%%%%%%%%%%%%%%%%%
tol = 1E-8;


%%%%%%%%%%%%%%%%%%%%%%
%                    %
%  extract sequence  %
%                    %
%%%%%%%%%%%%%%%%%%%%%%
[ n, m ] = size( seq );
if n == 3
    seq = seq';
end
%
i = seq( 1 ); j = seq( 2 ); k = seq( 3 );
%
if  isequal(seq,[1 2 3]) || isequal(seq,[2 3 1]) || isequal(seq,[3 1 2])
    anti = 0;                                               %  cyclic pattern
else
    anti = 1;                                               %  anti-cyclic pattern
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                        %
%  Cardanic rotations - cyclic sequence  %
%                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if anti == 0
    sipk = R(k,j) + R(j,i);		%  (1+sj)*sin(pi+pk)
    cipk = R(j,j) - R(k,i);		%  (1+sj)*cos(pi+pk)
    simk = R(k,j) - R(j,i);		%  (1-sj)*sin(pi-pk)
    cimk = R(j,j) + R(k,i);		%  (1-sj)*cos(pi-pk)
else


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                            %
%  Cardanic rotations - anticyclic sequence  %
%                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sipk = R(j,k) + R(i,j);		%  (1+sj)*sin(pi+pk)
    cipk = R(j,j) - R(i,k);		%  (1+sj)*cos(pi+pk)
    simk = R(j,k) - R(i,j);		%  (1-sj)*sin(pi-pk)
    cimk = R(j,j) + R(i,k);		%  (1-sj)*cos(pi-pk)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%  allow for rounding errors  %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ( sqrt( sipk ) + sqrt( cipk ) ) > tol
    pipk = atan2( sipk, cipk);
else
    pipk = 0.0;
end
%
if  ( sqrt( simk ) + sqrt( cimk ) ) > tol
    pimk = atan2( simk, cimk);
else
    pimk = 0.0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               %
%  now extract angles - cyclic  %
%                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if anti == 0
    angles(i) =  0.5 * ( pipk + pimk );
	 angles(k) =  0.5 * ( pipk - pimk );
    angles(j) = atan2( 2.0*R(i,k), cos(angles(k))*R(i,i) - sin(angles(k))*R(i,j) - sin(angles(i))*R(j,k) + cos(angles(i))*R(k,k) );
else

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %
%  now extract angles - anticyclic  %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    angles(i) = -0.5 * ( pimk + pipk );
    angles(k) =  0.5 * ( pimk - pipk );
    angles(j) = atan2(-2.0*R(k,i), cos(angles(k))*R(i,i) + sin(angles(k))*R(j,i) + sin(angles(i))*R(k,j) + cos(angles(i))*R(k,k) );
end


%
%%
%%% The End %%%
%%
%

