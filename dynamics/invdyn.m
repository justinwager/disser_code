function [ proxF, proxM ] = invdyn(extF, distF, distM, dcom, acom, w, wd, distpt, proxpt, m, I, R)
%INVDYN 

%  inputs
%  ------
%  distF            - resultant force acting on the segment at distal endpoint
%  distM            - 101x3 resultant moment acting on the segment at distal endpoint
%  dcom             - position of center of mass of segment
%  acom             - acceleration of segment center of mass
%  w                - angular velocity of segment
%  wd               - angular acceleration of segment
%  distpt,proxpt    - position of proximal and distal endpoint of segment
%  m                - mass of segment
%  I                - moment of inertia of segment
%
%  outputs
%  ------
%  distF      -	force at proximal endpoint (101x3)
%  distM      -	moment at proximal endpoint (101x3)
%

acom = acom';
dcom = dcom';
proxpt = proxpt';
distpt = distpt';

% check distM dimensions - need 101x3
if size(distM,1) <= 3
    distM = distM';
end



% constants
g = -9.80665;
Fg = m*g;

% prox reaction force
proxF = m*acom - (Fg + distF + extF.F);

% prox moment
distr = distpt - dcom;
proxr = proxpt - dcom;
extFr = extF.P - dcom;
for i = 1:length(distM)
    Ig = R(:,:,i)*I*R(:,:,i)';  % 3x3
    proxMcurr = (Ig*wd(:,i))' + cross(w(:,i),(Ig*w(:,i)))' - distM(i,:) - cross(distr(i,:), distF(i,:)) - cross(proxr(i,:), proxF(i,:)) - cross(extFr(i,:),extF.F(i,:));
    proxM(i,:) = proxMcurr';
end

