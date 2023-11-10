function model = ini_singleSegFoot(mkSt, subj)

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
% 9) contact model points

% needs: mkSt - static marker structure from BTK
%        subj - subject parameter structure

% transpose markers into 3x1 instead of 1x3
mkSt = structfun(@transpose,mkSt,'UniformOutput',false);

%% Setup segments, markers, & computed landmarks %%%%%%%%%%%%%%%%%%%%%%%%

model.segNames = {'pelvis','thigh','shank','foot','toes'};

nSegments = length(model.segNames);
for i = 1:nSegments
    model.(model.segNames{i}) = struct();
end

% assign markers to bodies - used to compute R matrices for dynamic trials
model.pelvis.mkG = assignMarkers(mkSt,{'RASIS','LASIS','SAC'});
model.thigh.mkG  = assignMarkers(mkSt,{'TH1','TH2','TH3','TH4','LATKN'});
model.shank.mkG  = assignMarkers(mkSt,{'LATKN','SH1','SH2','SH3','SH4','LATAN','MEDAN'});
model.foot.mkG   = assignMarkers(mkSt,{'POSTC','MET1H','MET5H'});
model.toes.mkG  = assignMarkers(mkSt,{'MET1H','TOE1','TOE2','TOE5'});

% define impt landmarks in global (a la Leardini et al. (2007))
ldmk.IM = mkSt.MEDAN + 0.5*(mkSt.LATAN - mkSt.MEDAN);
ldmk.midASIS = mkSt.LASIS + 0.5*(mkSt.RASIS - mkSt.LASIS);
% ldmk.midPSIS = mkSt.LPSIS + 0.5*(mkSt.RPSIS - mkSt.LPSIS);
% if (isfield(mkSt, 'MEDKN'))
%     ldmk.midFE = mkSt.MEDKN + 0.5*(mkSt.LATKN - mkSt.MEDKN);
% else
%     ldmk.midFE = mkSt.LATKN - [ 0.12;
% end
ldmk.midFE = [mkSt.LATKN(1)+0.04; mkSt.LATKN(2); mkSt.LATKN(3)];
vec = mkSt.RASIS - mkSt.LASIS;  
asisDist = sqrt(vec'*vec);
ldmk.HJC = mkSt.LASIS + [-0.19*asisDist ; -0.36*asisDist ; -0.14*asisDist ];
clear asisDist vec

% assign landmarks to a segment - should include both prox and dist jt
% centers.  Some landmarks will be assigned to multiple segments.
model.pelvis.ldmkG = assignLandmarks(ldmk,{'HJC'});
model.thigh.ldmkG = assignLandmarks(ldmk,{'HJC','midFE'});
model.shank.ldmkG = assignLandmarks(ldmk,{'IM', 'midFE'});
model.foot.ldmkG = assignLandmarks(ldmk,{'IM'});
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
shlen = ldmk.midFE - ldmk.IM;
model.shank.length = shlen;
clear v;

% foot
model.foot.mass = 0.8;
model.foot.I = diag([0.002 0.004 0.004]);
v = mkSt.MET1H - ldmk.IM;
model.foot.com = mkSt.MET1H - 0.5*v;        % [Winter]
clear v;

model.toes.mass = 0.2;
model.toes.I = diag([0.0001 0.0002 0.0001]);
model.toes.com = mean([mkSt.TOE1 mkSt.TOE2 mkSt.TOE5],2);

%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% origins - 3x1 in global %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% origins @ segment COMs
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

midMH = mkSt.MET5H + 0.5*(mkSt.MET1H - mkSt.MET5H);
model.foot.staticR = defFrame(mkSt.POSTC, midMH, mkSt.MET1H);

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

%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Define Joints & Joint Locations (global coords) %%%%%%%%%%%%%%%%%

% setup joints
model.jtNames = {'hipjt';'kneejt';'anklejt'; 'mtpjt'};
model.hipjt.prox = 'pelvis'; model.hipjt.dist = 'thigh';
model.kneejt.prox = 'thigh'; model.kneejt.dist = 'shank';
model.anklejt.prox = 'shank';  model.anklejt.dist = 'foot';
model.mtpjt.prox = 'foot'; model.mtpjt.dist = 'toes';

% static R of joints
model.mtpjt.staticR = model.foot.staticR' * model.toes.staticR;
model.anklejt.staticR = model.shank.staticR' * model.foot.staticR;
model.kneejt.staticR = model.thigh.staticR' * model.shank.staticR;
model.hipjt.staticR = model.pelvis.staticR' * model.thigh.staticR;

% global coords
model.toes.distjt = [0 0 0]';
model.toes.proxjt = mkSt.MET1H;
model.foot.distjt = model.toes.proxjt;
model.foot.proxjt = ldmk.IM;
model.shank.distjt = model.foot.proxjt;
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