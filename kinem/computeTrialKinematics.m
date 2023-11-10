function [model] = computeTrialKinematics(model,kinem_dt,seq)
% seq = Cardan/Euler angle decomposition sequence [1 2 3];
% Contents:
% 1) segment and joint R matrices
% 2) global joint center coordinates for each frame
% 3) segment R & V derivs, ang vel, ang acc, Cardan angles
% 4) joint R & V derivs, ang vel, ang acc, Cardan angles

% origin locations are computed as V from RandV function - based off
% experimental markers, and V will be the location of the origin that was
% set during ini_threeSegFoot (because local coords of markers are relative
% to that origin)

% needs: model, kinem_dt
%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extract segment and joint names
nSegments = length(model.segNames);
nJoints = length(model.jtNames);

mknm = fieldnames(model.(model.segNames{1}).mkG);
name = mknm{1};
% check for correct mkG size (should be [nt x 3]), transpose if needed
[n,m] = size(model.(model.segNames{1}).mkG.(name));
if m > 3
    for i = 1:nSegments     % iterate over all segments in the model
        currSeg = model.segNames{i};
        model.(currSeg).mkG = structfun(@transpose,model.(currSeg).mkG,'UniformOutput',false);
    end
end
nt = length(model.(model.segNames{1}).mkG.(name));

%% segment and joint attitude matrices

for t = 1:nt

    % segment R & V, current local frame vs. lab frame
    for i = 1:nSegments     % iterate over all segments in the model
        currSeg = model.segNames{i};
        if (strcmp(currSeg, 'ground'))
            continue
        end
        segMkNames = fieldnames(model.(currSeg).mkL);
        nSegMarkers = size(segMkNames,1); 

        % get local (blueprint) points on this segment @ this time
        % [nMarkers x 3], with each marker as a row
        loc_cell = struct2cell(model.(currSeg).mkL);
        for j = 1:nSegMarkers
            local(j,1:3) = loc_cell{j}';
        end

        % pull this marker's global coords for this frame from mkG struct
        % globTF = [nMarkers x 3], with each marker as a row
        globTF = structfun(@(x)(x(t,:)),model.(currSeg).mkG,'UniformOutput',false);  % t = only this frame
        globTF = cell2mat(struct2cell(globTF));

        % compute this timeframe's R & V in global frame
        % 3-d array with last index as timeframe num
        [model.(currSeg).R(:,:,t),model.(currSeg).V(:,t),model.(currSeg).rmsd_R(t,:)] = RandV(local,globTF);

        clearvars local globTF j currSeg loc_cell segMkNames nSegMarkers;
    end
    % end segment loop
    clearvars i ;
     
    % compute each joint's R & V, dist wrt prox and normalized to static   
    for i = 1:nJoints
        currJt = model.jtNames{i};
        proxSeg = model.(currJt).prox;
        distSeg = model.(currJt).dist;
        model.(currJt).R(:,:,t) = model.(currJt).staticR' * model.(proxSeg).R(:,:,t)' * model.(distSeg).R(:,:,t);
        model.(currJt).V(:,t) = model.(distSeg).V(:,t) - model.(proxSeg).V(:,t);
        if strcmp(currJt, 'kneejt')
            model.(currJt).R(:,:,t) = model.(proxSeg).R(:,:,t)' * model.(distSeg).R(:,:,t);
            [angle, axis] = helicalDecomp(model.(currJt).R(:,:,t), model.(currJt).V(:,t));
            model.(currJt).helical.axis(:,t) = axis;
            model.(currJt).helical.angle(:,t) = angle;
        end
    end; 
    % end joint loop
    clearvars i currJt proxSeg distSeg;
    
end
clearvars t;
%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% coordinates of joint centers for each frame %%%%%%%%%%%%%%%%%%%%%%%%%%%%
for s = 1:nSegments
    currSeg = model.segNames{s};
    
    for i = 1:nt;
        model.(currSeg).proxjtG(:,i) = model.(currSeg).V(:,i) + model.(currSeg).R(:,:,i)*model.(currSeg).proxjt;
        model.(currSeg).distjtG(:,i) = model.(currSeg).V(:,i) + model.(currSeg).R(:,:,i)*model.(currSeg).distjt;
    end
end

%--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% segment Rd, Rdd, Vd, Vdd, wp, wp_skew, wdp, wdp_skew, Cardan angles
for i=1:nSegments
    currSeg = model.segNames{i};
    
    % differentiate R & V
    [model.(currSeg).Rd, model.(currSeg).Rdd] = diffR(model.(currSeg).R, kinem_dt);
    [model.(currSeg).Vd, model.(currSeg).Vdd] = finDiff(model.(currSeg).V, kinem_dt); 
    
    for t=1:nt
        % Cardan angle decomp
        model.(currSeg).angles(:,t) = cardanAngles(model.(currSeg).R(:,:,t),seq);
        
        % omega local (ang vel)
        model.(currSeg).wp_skew(:,:,t) = model.(currSeg).R(:,:,t)' * model.(currSeg).Rd(:,:,t);
        model.(currSeg).wp(:,t) = skew_vec(model.(currSeg).wp_skew(:,:,t))';
        
        % omega global
        model.(currSeg).w_skew(:,:,t) = model.(currSeg).Rd(:,:,t) * model.(currSeg).R(:,:,t)';
        model.(currSeg).w(:,t) = skew_vec(model.(currSeg).w_skew(:,:,t))';
        
        % omega dot local (ang acc)
        model.(currSeg).wdp_skew(:,:,t) = model.(currSeg).R(:,:,t)'*(model.(currSeg).Rdd(:,:,t) - model.(currSeg).R(:,:,t)*model.(currSeg).wp_skew(:,:,t)*model.(currSeg).wp_skew(:,:,t));
        
        %omega dot global
        model.(currSeg).wd_skew(:,:,t) = model.(currSeg).R(:,:,t)*model.(currSeg).wdp_skew(:,:,t);
    end
   
    % ang acc local vector (differentiate ang vel)
    model.(currSeg).wdp = finDiff(model.(currSeg).wp, kinem_dt);
 
    clearvars currSeg;
end;
clearvars i t;
%--%%%%%END SEG KINEM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% joint Rd, Rdd, Vd, Vdd, wp, wp_skew, wdp, wdp_skew...stored in model.(jointName)
for i=1:nJoints
    currJt = model.jtNames{i};
    
    % differentiate R & V
    [model.(currJt).Rd, model.(currJt).Rdd] = diffR(model.(currJt).R, kinem_dt);
%     [model.(currJt).Vd, model.(currJt).Vdd] = finDiff(model.(currJt).V, kinem_dt); 
    
    for t=1:nt
        % Cardan/Euler angle decomp  (seq from above)
        model.(currJt).angles(:,t) = cardanAngles(model.(currJt).R(:,:,t),seq);
        
        % omega (ang vel) local
        model.(currJt).wp_skew(:,:,t) = model.(currJt).R(:,:,t)' * model.(currJt).Rd(:,:,t);
        model.(currJt).wp(:,t) = skew_vec(model.(currJt).wp_skew(:,:,t))';
        
        % omega (ang vel) global
        model.(currJt).w_skew(:,:,t) = model.(currJt).Rd(:,:,t) * model.(currJt).R(:,:,t)';
        model.(currJt).w(:,t) = skew_vec(model.(currJt).w_skew(:,:,t))';        
        
        % omega dot (ang acc) local
        model.(currJt).wdp_skew(:,:,t) = model.(currJt).R(:,:,t)'*(model.(currJt).Rdd(:,:,t) - model.(currJt).R(:,:,t)*model.(currJt).wp_skew(:,:,t)*model.(currJt).wp_skew(:,:,t));
        
        % omega dot global
        model.(currJt).wd_skew(:,:,t) = model.(currJt).R(:,:,t)*model.(currJt).wdp_skew(:,:,t);
    end
   
    % ang acc local vector (differentiate ang vel)
    model.(currJt).wdp = finDiff(model.(currJt).wp, kinem_dt);
    
    clearvars currJt;
end 
clearvars i t;
% END JOINT KINEM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Landmark global coords (from local defined during ini) %%%%%%%%%%%%%%%
% Landmarks
% mk.IM = mk.MM + 0.5*(mk.LM - mk.MM);
% mk.IC = mk.ST + 0.5*(mk.PT - mk.ST);
% mk.ID = mk.TN + 0.5*(mk.VMB - mk.TN);
% mk.midASIS = mk.LASIS + 0.5*(mk.RASIS - mk.LASIS);
% mk.midPSIS = mk.LPSIS + 0.5*(mk.RPSIS - mk.LPSIS);
% mk.midFE = mk.MEDKN + 0.5*(mk.LATKN - mk.MEDKN);
% mk.HJC = mk.LASIS + [-0.19*asisDist ; -0.36*asisDist ; -0.14*asisDist ];
 
% eof