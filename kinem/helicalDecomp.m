function [angle, axis] = helicalDecomp(R, V)

    angle = acos((trace(R) - 1) / 2);
    axis = (1/2*sin(angle)) * ...
            [R(3,2) - R(1,3) ; R(1,3) - R(3,1); R(2,1) - R(1,2)];
    translation = axis' * V;
    point = (1 + cos(angle) / 2*sin(angle)^2) * (eye(3) - R(:,:)') * V;
end


