function [q, fm, fl, fv, lmtu, lt, lf, vf, fm_raw, lf_raw] = simGastroc(ankle, knee, moments, dt)
% Outputs:    lf - length of fibers in lf / lfopt
%             vf - velocity of fibers in lfopt/s
%             fm - muscle force, normalized to max iso force (0-1)

% muscle model params (Challis & Domire, 2015)
fmmax = 2000;  % [N]
lfopt = 0.055; % [m]
w = 0.56;
ltr = 0.365;  % [m]
c = 0.04; 
vfmax = 5.2;  % [lfopt / s]
k = 2.44;

% reflen = ltr + lfopt;
shlen = 0.42;
reflen = 0.42;

% get length change in mtu from grieve eqns 
[~, lmtu_perc] = grieve(ankle, knee);
lmtu = (lmtu_perc * reflen) + reflen;

% compute muscle force w/ moment arm eqn from Bobbert/Grieve
d = (((180/pi)*(0.30141 - 2*0.00061*ankle))/100)*shlen;
moments(moments<0) = 0;
fm = moments ./ d;
fm = fm * 0.3333;  % gastroc only so reduce force requirement

% calc lt, lf, vf
lt = tenlen(fmmax, c, ltr, fm);  % [m]
lf = lmtu - lt;                % [m]
vf = finDiff(lf/lfopt, dt);   % [lfopt/s] for forcvel call, pos = lengthening 

% muscle property fractions
for i = 1:length(lf)
    fl(i) = forclen(lf(i), lfopt, w);
    fv(i) = forcvel(vf(i), vfmax, k);   % vf input in lfopt/s
end

% calc active state (fm = q * fl * fv * fmmax)
q = fm ./ (fl' .* fv' * fmmax);

% enforce active state > 0 (can be neg when muscle force is neg)
q(q<0) = 0;

% normalize
fm_raw = fm;
lf_raw = lf;
fm = fm/fmmax; 
lf = lf/lfopt;    % [lf / lfopt], >1 = fiber is longer than optimal
% vf = vf / vfmax;        % [% of vfmax]