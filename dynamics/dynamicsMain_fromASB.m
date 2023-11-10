% outputs: extF,proxF,distF

%%%%%%%%%%%%%%%%%%%%%%%% SINGLE MODEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
footframes = grf.P(:,1) <= singleModel.foot.distjtG(1,:)';
footframes(1:5) = 1;  % always lands on foot segment - ignore noise
singleModel.foot.extF.F(footframes,:) = grf.F(footframes,:);
singleModel.foot.extF.F(~footframes,:) = zeros(length(footframes) - sum(footframes),3);
singleModel.foot.extF.P(footframes,:) = grf.P(footframes,:);
singleModel.foot.extF.P(~footframes,:) = zeros(length(footframes) - sum(footframes),3);
singleModel.foot.extF.M(footframes,:) = grf.M(footframes,:);
singleModel.foot.extF.M(~footframes,:) = zeros(length(footframes) - sum(footframes),3);
singleModel.foot.extF.FM(footframes,:) = grf.FM(footframes,:);
singleModel.foot.extF.FM(~footframes,:) = zeros(length(footframes) - sum(footframes),3);

toeframes = grf.P(:,1) > singleModel.foot.distjtG(1,:)';
toeframes(end-5:end) = 1;  % always take off from toe segment - ignore noise
toeframes(1:5) = 0; % never lands on toe segment - ignore noise
singleModel.toes.extF.F(toeframes,:) = grf.F(toeframes,:);
singleModel.toes.extF.F(~toeframes,:) = zeros(length(toeframes) - sum(toeframes),3);
singleModel.toes.extF.P(toeframes,:) = grf.P(toeframes,:);
singleModel.toes.extF.P(~toeframes,:) = zeros(length(toeframes) - sum(toeframes),3);
singleModel.toes.extF.M(toeframes,:) = grf.M(toeframes,:);
singleModel.toes.extF.M(~toeframes,:) = zeros(length(toeframes) - sum(toeframes),3);
singleModel.toes.extF.FM(toeframes,:) = grf.FM(toeframes,:);
singleModel.toes.extF.FM(~toeframes,:) = zeros(length(toeframes) - sum(toeframes),3);
%%%%%%%%%%%%%% MultiModel


%%%%%%%%% INV DYN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intialize distF to zeros, will set to extF during inv dyn loop below
multiModel.toes.distF = zeros(101,3);
multiModel.toes.distM = zeros(101,3);
% no toes forces for thesis data
multiModel.toes.extF.F = zeros(101,3);
multiModel.toes.extF.M = zeros(101,3);
multiModel.toes.extF.P = zeros(101,3);

hfframes = grf.P(:,1) <= multiModel.hf.distjtG(1,:)';
multiModel.hf.extF.F(hfframes,:) = grf.F(hfframes,:);
multiModel.hf.extF.M(hfframes,:) = grf.M(hfframes,:);
multiModel.hf.extF.P(hfframes,:) = grf.P(hfframes,:);
% set other frames to zero
multiModel.hf.extF.F(~hfframes, :) =  zeros(length(hfframes) - sum(hfframes),3);
multiModel.hf.extF.M(~hfframes, :) =  zeros(length(hfframes) - sum(hfframes),3);
multiModel.hf.extF.P(~hfframes, :) =  zeros(length(hfframes) - sum(hfframes),3);

ffframes = grf.P(:,1) >= multiModel.ff.proxjtG(1,:)';
ffframes(end-10:end) = 1;
multiModel.ff.extF.F(ffframes,:) = grf.F(ffframes,:);
multiModel.ff.extF.M(ffframes,:) = grf.M(ffframes,:);
multiModel.ff.extF.P(ffframes,:) = grf.P(ffframes,:);

% inverse dynamics - mulitsegment model
for i = length(multiModel.segNames):-1:2      % bottom up, except topmost seg (first seg, pelvis)
    currSeg = multiModel.segNames{i};
    nextSeg = multiModel.segNames{i-1};
    
    if ~isfield(multiModel.(currSeg),'extF')
        multiModel.(currSeg).extF.F = zeros(101,3);
        multiModel.(currSeg).extF.P = zeros(101,3);
        multiModel.(currSeg).extF.M = zeros(101,3);
    end
        
    [multiModel.(currSeg).proxF, multiModel.(currSeg).proxM] = ...
      invdyn( multiModel.(currSeg).extF, ...
        multiModel.(currSeg).distF, multiModel.(currSeg).distM, ...  % applied F
        multiModel.(currSeg).V, multiModel.(currSeg).Vdd, ...     % COM kinem
        multiModel.(currSeg).wp, multiModel.(currSeg).wdp, ...    % ang kinem
        multiModel.(currSeg).distjtG, multiModel.(currSeg).proxjtG,... % seg endpoints
        multiModel.(currSeg).mass, multiModel.(currSeg).I, ...       % inertial params
        multiModel.(currSeg).R ...
      );
  
    multiModel.(nextSeg).distF = -multiModel.(currSeg).proxF;
    multiModel.(nextSeg).distM = -multiModel.(currSeg).proxM;
end

% inverse dynamics - single model
singleModel.toes.distF = zeros(101,3);
singleModel.toes.distM = zeros(101,3);
for i = length(singleModel.segNames):-1:2      % bottom up, except topmost seg (first seg, pelvis)
    currSeg = singleModel.segNames{i};
    nextSeg = singleModel.segNames{i-1};

    if ~isfield(singleModel.(currSeg),'extF')
        singleModel.(currSeg).extF.F = zeros(101,3);
        singleModel.(currSeg).extF.P = zeros(101,3);
        singleModel.(currSeg).extF.M = zeros(101,3);
    end
    
    [singleModel.(currSeg).proxF, singleModel.(currSeg).proxM] = ...
      invdyn( singleModel.(currSeg).extF, ...
        singleModel.(currSeg).distF, singleModel.(currSeg).distM, ...  % applied F
        singleModel.(currSeg).V, singleModel.(currSeg).Vdd, ...     % COM kinem
        singleModel.(currSeg).wp, singleModel.(currSeg).wdp, ...    % ang kinem
        singleModel.(currSeg).distjtG, singleModel.(currSeg).proxjtG,... % seg endpoints
        singleModel.(currSeg).mass, singleModel.(currSeg).I, ...       % inertial params
        singleModel.(currSeg).R ...
      );
  
    singleModel.(nextSeg).distF = -singleModel.(currSeg).proxF;
    singleModel.(nextSeg).distM = -singleModel.(currSeg).proxM;
end

% multisegment foot - powers
for jt = 1:length(multiModel.jtNames)
    currJt = multiModel.jtNames{jt};
    distSeg = multiModel.(currJt).dist;
    
    % scalar power
    for i = 1:length(multiModel.(distSeg).proxM)
        multiModel.(currJt).power(:,i) = dot(multiModel.(distSeg).proxM(i,:), multiModel.(currJt).wp(:,i)');
    end
    
    % instantaneous jt power about each axis
    for j = 1:3
        multiModel.(currJt).power3dvec(:,j) = multiModel.(distSeg).proxM(:,j) .* multiModel.(currJt).wp(j,:)';
    end
end

% single segment foot - powers
for jt = 1:length(singleModel.jtNames)
    currJt = singleModel.jtNames{jt};
    distSeg = singleModel.(currJt).dist;
    
    % scalar power
    for i = 1:length(singleModel.(distSeg).proxM)
        singleModel.(currJt).power(:,i) = dot(singleModel.(distSeg).proxM(i,:), singleModel.(currJt).wp(:,i)');
    end
    
    % instantaneous jt power about each axis
    for j = 1:3
        singleModel.(currJt).power3dvec(:,j) = singleModel.(distSeg).proxM(:,j) .* singleModel.(currJt).wp(j,:)';
    end
end

% work
% singleModel.anklejt.work(:,i) = posNegIntegral(singleModel.time, singleModel.anklejt.power);
% multiModel.anklejt.work(:,i) = posNegIntegral(multiModel.time, multiModel.anklejt.power);
[multiModel.midftjt.poswork, multiModel.midftjt.negwork] = posNegIntegral(multiModel.time, multiModel.midftjt.power);
[multiModel.anklejt.poswork, multiModel.anklejt.negwork] = posNegIntegral(multiModel.time, multiModel.anklejt.power);
[multiModel.kneejt.poswork, multiModel.kneejt.negwork] = posNegIntegral(multiModel.time, multiModel.kneejt.power);
[multiModel.hipjt.poswork, multiModel.hipjt.negwork] = posNegIntegral(multiModel.time, multiModel.hipjt.power);
[singleModel.anklejt.poswork, singleModel.anklejt.negwork] = posNegIntegral(multiModel.time, singleModel.anklejt.power);
[singleModel.kneejt.poswork, singleModel.kneejt.negwork] = posNegIntegral(multiModel.time, singleModel.kneejt.power);
[singleModel.hipjt.poswork, singleModel.hipjt.negwork] = posNegIntegral(multiModel.time, singleModel.hipjt.power);


clear ffframes hfframes footframes toeframes