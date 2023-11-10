function [xd, xdd] = finDiff(x,dt)
% input:  x = vector to be differentiated
%         dt = time interval between points

% transpose to be nt x 3
if size(x,1) == 3
    x = x';
    trans = 1;
else
    trans = 0;
end

nt = size(x,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                     %
%  1st and 2nd derivaties w/ 1st order finite difference    %
%             %%% main bulk of data %%%                     %
%                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=2:nt-1
	xd(i,:) = ( x(i+1,:) -  x(i-1,:)) / (dt + dt);
	xdd(i,:) = ( x(i+1,:) - (x(i,:) * 2.) + x(i-1,:) ) / (dt^2);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%  for beginning of data set  %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xd(1,:) = ( x(2,:) - x(1,:) ) / dt;
xdd(1,:) = ( x(3,:) - (x(2,:) * 2.) + x(1,:) ) / (dt^2);


%%%%%%%%%%%%%%%%%%%%%%%%
%                      %
%  at end of data set  %
%                      %
%%%%%%%%%%%%%%%%%%%%%%%%
xd(nt,:) = ( x(nt,:) - x(nt-1,:) ) / dt;
xdd(nt,:) = ( x(nt,:) - ( x(nt-1,:) * 2.) + x(nt-2,:) ) / (dt^2);

% undo transpose 
if trans == 1
    xd = xd';
    xdd = xdd';
end

