function [glob] = getGlobalCoords(R,V,local)
% Computes global coordinates of a point on a segment
% Can handle a single frame (3x1) or a time series (3 x nt)

% Inputs:   R - attitude matrix of segment, 3x3xnt (if only one pose, 3x3)
%           V - vector from global origin to segment COM (3xnt)
%           local - vector of local coordinates on segment
%
% Outputs:  glob - 3 x nt vector of global coordinates

% check for local as 3x1
if size(local,1) == 1
    local = local';
end

nt = size(R,3);

if nt > 1
    for i = 1:nt
        glob(:,i) = V(:,i) + R(:,:,i)*local;
    end
elseif nt == 1
    glob = V + R*local;
end

