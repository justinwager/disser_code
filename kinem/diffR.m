function [Rd, Rdd] = diffR(R,dt)
% input:  R = 3x3xnt array of R matrices to be differentiated
%         dt = time interval between points

nt = size(R,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                     %
%  1st and 2nd derivaties w/ 1st order finite difference    %
%             %%% main bulk of data %%%                     %
%                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=2:nt-1
	Rd(:,:,i) = ( R(:,:,i+1) -  R(:,:,i-1)) / (dt + dt);
	Rdd(:,:,i) = ( R(:,:,i+1) - (R(:,:,i) * 2.) + R(:,:,i-1) ) / (dt^2);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%  for beginning of data set  %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rd(:,:,1) = ( R(:,:,2) - R(:,:,1) ) / dt;
Rdd(:,:,1) = ( R(:,:,3) - (R(:,:,2) * 2.) + R(:,:,1) ) / (dt^2);


%%%%%%%%%%%%%%%%%%%%%%%%
%                      %
%  at end of data set  %
%                      %
%%%%%%%%%%%%%%%%%%%%%%%%
Rd(:,:,nt) = ( R(:,:,nt) - R(:,:,nt-1) ) / dt;
Rdd(:,:,nt) = ( R(:,:,nt) - ( R(:,:,nt-1) * 2.) + R(:,:,nt-2) ) / (dt^2);
