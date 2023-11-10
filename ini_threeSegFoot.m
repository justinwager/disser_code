function model = ini_threeSegFoot(mkSt, subj)

% contents:
% 1) set up model structure w/ desired segments [model.(segmentname)]
% 2) define global locations of important landmarks (jt centers, origins, etc)
%       - first in global, transform to local coords of segment after (4)
%       - will be reconstructed into global using R matrices in each trial
% 3) define segment origins & assign exp markers to their segments
% 4) define joint locations for each segment in global coords
% 5) set up segment reference frames
% 6) define body segment inertial parameters
% 7) translate each reference frame to segment's COM
% 8) compute local coords of markers, landmarks, & joint centers

% needs: mkSt - static marker structure from BTK
%        subj - subject parameter structure

% transpose markers into 3x1 instead of 1x3
mkSt = structfun(@transpose,mkSt,'UniformOutput',false);

%% Setup segments, markers, & computed landmarks %%%%%%%%%%%%%%%%%%%%%%%%

model.segNames = {'pelvis','thigh','shank','hf','ff','toes'};
nSegments = length(model.segNames);
for i = 1:nSegments
    model.(model.segNames{i}) = struct();
end
%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Marker & Landmark setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assign markers to bodies - used to compute R matrices for dynamic trials
model.pelvis.mkG = assignMarkers(mkSt,{'RASIS','LASIS','SAC'});
model.thigh.mkG  = assignMarkers(mkSt,{'TH1','TH2','TH3','TH4','LATKN'});
model.shank.mkG  = assignMarkers(mkSt,{'LATKN','SH1','SH2','SH3','SH4','LATAN','MEDAN'});
model.hf.mkG   = assignMarkers(mkSt,{'POSTC','MEDTU','PERON'});
model.ff.mkG  = assignMarkers(mkSt,{'NAVIC','MET5B','MET5H','MET1B','MET1H'});
model.toes.mkG  = assignMarkers(mkSt,{'MET1H','TOE1','TOE2','TOE5'});

% define impt landmarks in global (a la Leardini et al. (2007))
ldmk.IM = mkSt.MEDAN + 0.5*(mkSt.LATAN - mkSt.MEDAN);
ldmk.ID = mkSt.NAVIC + 0.5*(mkSt.MET5B - mkSt.NAVIC);
ldmk.IC = mkSt.MEDTU + 0.5*(mkSt.PERON - mkSt.MEDTU);
ldmk.midFE = [mkSt.LATKN(1)+0.04; mkSt.LATKN(2); mkSt.LATKN(3)];
ldmk.midASIS = mkSt.LASIS + 0.5*(mkSt.RASIS - mkSt.LASIS);
% ldmk.midPSIS = mkSt.LPSIS + 0.5*(mkSt.RPSIS - mkSt.LPSIS);
% if (isfield(mkSt, 'MEDKN'))
%     ldmk.midFE = mkSt.MEDKN + 0.5*(mkSt.LATKN - mkSt.MEDKN);
% else
%     ldmk.midFE = mkSt.LATKN - [ 0.12;
% end
vec = mkSt.RASIS - mkSt.LASIS;
asisDist = sqrt(vec'*vec);
ldmk.HJC = mkSt.LASIS + [-0.19*asisDist ; -0.36*asisDist ; -0.14*asisDist ];
clear asisDist vec

% assign landmarks to a segment - should include both prox and dist jt
% centers.  Some landmarks will be assigned to multiple segments.
model.pelvis.ldmkG = assignLandmarks(ldmk,{'HJC'});
model.thigh.ldmkG = assignLandmarks(ldmk,{'HJC','midFE'});
model.shank.ldmkG = assignLandmarks(ldmk,{'IM', 'midFE'});
model.hf.ldmkG = assignLandmarks(ldmk,{'IM', 'IC', 'ID'});
model.ff.ldmkG = assignLandmarks(ldmk,{'ID'});
%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% BSIP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some from I's Winter (2009) some from Anderson & Pandy (1999)
model.pelvis.mass = 0.142*subj.mass;
model.pelvis.I = diag([0.0973 0.0825 0.0548]);
model.pelvis.com = mean([mkSt.RASIS mkSt.LASIS mkSt.SAC],2);

model.thigh.mass = 0.1*subj.mass;
model.thigh.I = diag([0.1268 0.0332 0.1337]);
v = ldmk.HJC - ldmk.midFE;
model.thigh.com = ldmk.midFE + 0.433*v;
clear v;

model.shank.mass = 0.0465*subj.mass;
model.shank.I = diag([0.0477 0.0048 0.0484]);
v = ldmk.midFE - ldmk.IM;
model.shank.com = ldmk.IM + 0.433*v;        % [Winter]
clear v;

model.hf.mass = 0.4;
model.hf.I = diag([0.001 0.002 0.002]);
model.hf.com(1) = mkSt.POSTC(1) + 0.5*(mkSt.NAVIC(1) - mkSt.POSTC(1));
model.hf.com(2) = mkSt.MEDTU(2) + 0.5*(mkSt.PERON(2) - mkSt.MEDTU(2));
model.hf.com(3) = ldmk.IC(3);
model.hf.com = model.hf.com';

model.ff.mass = 0.4;
model.ff.I = diag([0.001 0.002 0.002]);
model.ff.com = mean([mkSt.MET1B mkSt.MET1H mkSt.MET5H mkSt.MET5B],2);

model.toes.mass = 0.2;
model.toes.I = diag([0.0001 0.0002 0.0001]);
model.toes.com = mean([mkSt.TOE1 mkSt.TOE2 mkSt.TOE5],2);

%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% origins - 3x1 in global %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model.pelvis.origin = ldmk.midASIS;
% % model.thigh.origin  = mkSt.TH1;
% model.shank.origin  = ldmk.IM;
% model.hf.origin   = mkSt.POSTC;
% model.ff.origin  = ldmk.ID;
% model.toes.origin = mkSt.FMH;

for i = 1:nSegments
    currSeg = model.segNames{i};
    if strcmp(currSeg,'static')
        continue
    end
    model.(currSeg).origin = model.(currSeg).com;
end

%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% static R matrices/local frames %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model.pelvis.staticR = defFrame(mkSt.SAC,ldmk.midASIS,mkSt.LASIS);
model.toes.staticR = defFrame(mkSt.MET1H,mkSt.TOE1,mkSt.TOE5);

% thigh
% x: AP
w = unit(mkSt.LATKN, ldmk.midFE);
q = unit(mkSt.LATKN, mkSt.TH1);
u = cross(q,w);
v = cross(w,u);
model.thigh.staticR = [u v w];

% shank
v = unit(ldmk.IM,ldmk.midFE);
q = unit(ldmk.IM,mkSt.LATAN);
u = cross(q,v);
w = cross(u,v);
model.shank.staticR = [u v w];

% hf
% x: AP, from POSTC to IC
% y: up
% z: medially
% u = unit(mkSt.POSTC, ldmk.IC);
% q = unit(mkSt.PERON, mkSt.MEDTU);
% v = cross(q,u);
% w = cross(u,v);
% model.hf.staticR = [u v w];
midMH = mkSt.MET5H + 0.5*(mkSt.MET1H - mkSt.MET5H);
model.hf.staticR = defFrame(mkSt.POSTC,midMH,mkSt.MET1H);

% ff
w = unit(mkSt.MET5H, mkSt.MET1H); 
q = unit(mkSt.MET5B, mkSt.MET5H);
v = cross(w,q);
u = cross(v,w);
model.ff.staticR = [u v w];

clearvars u v w q%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Define Joints & Joint Locations (global coords) %%%%%%%%%%%%%%%%%

% setup joints
model.jtNames = {'hipjt';'kneejt';'anklejt'; 'midftjt'; 'mtpjt'};
model.hipjt.prox = 'pelvis'; model.hipjt.dist = 'thigh';
model.kneejt.prox = 'thigh'; model.kneejt.dist = 'shank';
model.anklejt.prox = 'shank';  model.anklejt.dist = 'hf';
model.midftjt.prox = 'hf'; model.midftjt.dist = 'ff';
model.mtpjt.prox = 'ff'; model.mtpjt.dist = 'toes';

% static R of joints
model.mtpjt.staticR = model.ff.staticR' * model.toes.staticR;
model.midftjt.staticR = model.hf.staticR' * model.ff.staticR;
model.anklejt.staticR = model.shank.staticR' * model.hf.staticR;
model.kneejt.staticR = model.thigh.staticR' * model.shank.staticR;
model.hipjt.staticR = model.pelvis.staticR' * model.thigh.staticR;

% global coords
model.toes.distjt = [0 0 0]';
model.toes.proxjt = mkSt.MET1H;
model.ff.distjt = model.toes.proxjt;
model.ff.proxjt = ldmk.ID;
model.hf.distjt = model.ff.proxjt;
model.hf.proxjt = ldmk.IM;
model.shank.distjt = model.hf.proxjt;
model.shank.proxjt = ldmk.midFE;
model.thigh.distjt = model.shank.proxjt;
model.thigh.proxjt = ldmk.HJC;
model.pelvis.distjt = model.thigh.proxjt;
model.pelvis.proxjt = mkSt.SAC;

%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% local coordinates (blueprints) of markers assigned to each segment %%%%
for i=1:nSegments
    currSeg = model.segNames{i};
    if strcmp(currSeg,'static')
        continue
    end
    
    % pull static R that was just defined above
    Rcurr = model.(currSeg).staticR;
    
    % compute local coords of each marker from global coords
    % does not include landmarks
    model.(currSeg).mkL = structfun(@(x)(Rcurr'*(x - model.(currSeg).origin)), ...
                                   model.(currSeg).mkG, ...
                                   'UniformOutput',false); 
    
    % joint centers
    model.(currSeg).proxjt = Rcurr'*(model.(currSeg).proxjt - model.(currSeg).origin);
    model.(currSeg).distjt = Rcurr'*(model.(currSeg).distjt - model.(currSeg).origin);
    
    % landmarks
    % some segments have no landmarks, skip these and move to next segment
    if ~isfield(model.(currSeg), 'ldmkG')
        continue
    end
    model.(currSeg).ldmk = structfun(@(x)(Rcurr'*(x - model.(currSeg).origin)), ...
                                   model.(currSeg).ldmkG, ...
                                   'UniformOutput',false); 
    
    
    clearvars currSeg Rcurr
end
clearvars i staticFilepath Rcurr; 
%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%