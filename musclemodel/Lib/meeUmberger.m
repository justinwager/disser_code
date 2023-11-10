function [Edot] = meeUmberger(A, fm, vf, lf, fl, lfopt, fmmax, percFT);
% percFT
% A
% fmmax
% fm
% vf
% lf
% lfopt % meters

vfmaxST = 5; % lfopt/s, not from Umberger...need to figure a good value out
vfmaxFT = 10;  % lfopt/s, not from Umberger...need to figure a good value out

sigma = 250000; % [Pa]
density = 1059.7;  % [km.m^-3]
muscleMass = (fmmax / sigma) * density * lfopt;
A_am = A^0.6;
A_s = A^2;
S = 1.5; % aerobic conditions
alphaST = 100 / vfmaxST;  % 1 / lfopt/s
alphaFT = 153 / vfmaxFT;  % 1 / lfopt/s
alphaL = 4 * alphaST;     % 1 / lfopt/s
h_am = 1.28 * percFT + 25;  % perc
w_ce = (fm*vf*lfopt)/muscleMass;  % W / kg

if lf <= lfopt
    if vf <= 0
        h_sl = -alphaST * vf * (1 - percFT / 100) - alphaFT * vf * (percFT / 100); % unitless?
        h_sl = h_sl * A_s * S;  % unitless?
    else
        h_sl = alphaL * vf * A * S;  % unitless?
    end
    
    Edot = h_am * A_am * S + h_sl - w_ce;  % W/kg but mostly unitless?
else
    if vf <= 0
        h_sl = -alphaST * vf * (1 - percFT / 100) - alphaFT * vf * (percFT / 100);
        h_sl = h_sl * fl * A_s * S;
    else
        h_sl = alphaL * vf * fl * A * S;
    end
    
    Edot = (0.4*h_am + 0.6*h_am*fl) * A_am * S ...
        + h_sl - w_ce;
end
