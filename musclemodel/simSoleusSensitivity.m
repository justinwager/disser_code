function [q, fm, fl, fv, lmtu, lt, lf, vf, tstr] = simSoleusSensitivity(ankle, moments, dt, params)
% Outputs:    lf - length of fibers in lf / lfopt
%             vf - velocity of fibers in lfopt/s
%             fm - muscle force, normalized to max iso force (0-1)

% muscle model params (Challis & Domire, 2015)
fmmax = params.fmmax;  % [N]
lfopt = params.lfopt; % [m]
w = params.w;
ltr = params.ltr;  % [m]
c = params.c; 
vfmax = params.vfmax;  % [lfopt / s]
k = params.k;
ratio = params.ratio;

% reflen = ltr + lfopt;
reflen = 0.226 + 0.076;
shlen = 0.42;

% get length change in mtu from grieve eqns 
lmtu = (grieve(ankle, zeros(length(ankle),1)) * shlen) + reflen;

% compute muscle force w/ moment arm eqn from Bobbert/Grieve
d = (((180/pi)*(0.30141 - 2*0.00061*ankle))/100)*shlen;
moments(moments<0) = 0;
fm = moments ./ d;
totalParts = ratio + 1;
soleusPortion = ratio / totalParts;
fm = fm * soleusPortion;  % soleus only so reduce force requirement

% fm = moments ./ (0.30141 - 2*0.00061*angles);

% calc lt, lf, vf
lt = tenlen(fmmax,c,ltr, fm);  % [m]
tstr = (lt - ltr) / ltr;
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
fm = fm/fmmax; 
lf = lf/lfopt;    % [lf / lfopt], >1 = fiber is longer than optimal
% vf = vf / vfmax;        % [% of vfmax]