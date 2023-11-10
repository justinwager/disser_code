function [xint] = interpnan(x,t)

for i = 1:size(x,2)
    currx = x(:,i);
    nanx = isnan(currx);
    currx(nanx) = interp1(t(~nanx), currx(~nanx), t(nanx));
    xint(:,i) = currx;
end
