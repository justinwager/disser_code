function [R] = defFrame(mk1,mk2,mk3)
%
% Define a reference frame from three markers.
%
% Inputs:  mk1,mk2,mk3  - 3x1 location of markers on the body, mk1 is frame origin
%
% Outputs:   R          - attitude matrix for the position
%
% x-axis: from mk1 to mk2
% y-axis: cross x & mk1 to mk3
% z-axis: cross x,y
%
% Justin C. Wager, Penn State University
% 2016 May 5



% x-axis (u)
vec1 = mk2 - mk1;
u = vec1/norm(vec1);

% y-axis (v)
vec2 = mk3 - mk1;
% % ensure y always up no matter which vectors are chosen
% if vec1(3) > vec2(3)
%     vr = cross(vec1,vec2);
% elseif vec1(3) < vec2(3)
%     vr = cross(vec2,vec1);
% else
%     disp('defFrame vector z coords are equal');
% end
vr = cross(vec2,vec1);
v = vr/norm(vr);

% z-axis (w)
wr = cross(u,v);
w = wr/norm(wr);

% R matrix
R = [u v w];