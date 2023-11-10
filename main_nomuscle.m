% main program for foot model
% anything related to the model (markers, kinematics, kinetics, etc) is
% stored in the "model" structure
% requires:
%   btk (Biomechanical Toolkit)
%   spm1d (Todd Pataky) -- for stats
%   legendflex (by kakearney) -- for plotting using plotter.m
%   boundedline (by kakearney) -- for plotting using plotter.m

clc; clear; close all;
%% Start KINEM/KINEM code -------------------------------------------
kinem_dt = 1/150;
grf_dt = kinem_dt/10;
r2d = 180/pi;
d2r = pi/180;
perc = 0:100;

mkCutoff = 10;
grfCutoff = 45;

seq = [1 2 3];

subjToProcess = [51 81 82 83 85 86 87];
%--------------------------------------------------------------------------

for s = 1:length(subjToProcess)
    %% Subject setup
    subjnum = subjToProcess(s);
    dataDir = 'add data path here';
    c3dpath = fullfile(dataDir, '*.c3d');
    c3dfiles = dir(c3dpath); % returns 8 x 1 structure (6 trials, 1 swing, #8 = 1 static)

    %% Static Trial - construct model -----------------------------------------------
    % KEEP FROM THIS BLOCK: 1) Segment ORIGINS, 2) MARKER LOCAL COORDS, 3) BSIP's

    % Get c3d data using btk & filter
    staticFilepath = [dataDir c3dfiles(8).name];
    hstatic = btkReadAcquisition(staticFilepath);
    if ~isfield(btkGetMarkers(hstatic), 'LATKN')
        hstatic = changeMarkerNames(hstatic);
    end
    [mkSt,grfSt] = c3dExtractData(hstatic,mkCutoff,grfCutoff);
    btkCloseAcquisition(hstatic);
    
    % mean static marker data 
    mkSt = structfun(@(x)(mean(x)),mkSt,'UniformOutput',false);
    
    % rotate static marker data - subject was rotated +90deg about y
    Ry90 = [0 0 -1; 0 1 0; 1 0 0];
    mkSt = structfun(@(x) (Ry90*x')' ,mkSt,'UniformOutput',false);

    % compute whole body mass, height
    Fz = grfSt(1).F(:,2)+grfSt(2).F(:,2);
    subj.mass = mean(Fz)/9.81;
    clearvars Fz

    % setup models            
    if isfield(mkSt, 'SACRU')
        mkSt.SAC = mkSt.SACRU;
        mkSt = rmfield(mkSt, 'SACRU');
    end
    multiModelBase = ini_threeSegFoot(mkSt, subj);
    singleModelBase = ini_singleSegFoot(mkSt,subj);

    clearvars grfSt
    % END STATIC-----------------------------------------------------------------------

    %% Trial Data - Extract & Filter GRF + Markers -------------------------

    for tr = 4:6  % only RF strike trials
        c3dFilepath = [dataDir c3dfiles(tr).name];
        htrial = btkReadAcquisition(c3dFilepath);
        if ~isfield(btkGetMarkers(htrial), 'LATKN')
            htrial = changeMarkerNames(htrial);
        end
        [mk,grf,time] = c3dExtractData(htrial,mkCutoff,grfCutoff);
        btkCloseAcquisition(htrial);
        grf = grf(1);
        stanceDT = time(2) - time(1);
        
        if isfield(mk, 'SACRU')
            mk.SAC = mk.SACRU;
            mk = rmfield(mk, 'SACRU');
        end
          
        multiModel = applyTrialMarkers(multiModelBase,mk);
        singleModel = applyTrialMarkers(singleModelBase,mk);

        %% Kinematics------------------------------------------------------
        % segment & joint R, V, Rd, Rdd, Vd, Vdd, wp, wp_skew, wdp, wdp_skew, Cardan angles
        % segment vars stored in model.segName, joint vars stored in model.jointName
        multiModel = computeTrialKinematics(multiModel, stanceDT, seq);
        singleModel = computeTrialKinematics(singleModel, stanceDT, seq);

        multiModel.time = time;
        singleModel.time = time;
        dynamicsMain_fromASB;

        single.(['subj' num2str(subjnum)]).(['trial' num2str(tr)])= singleModel;
        single.(['subj' num2str(subjnum)]).(['trial' num2str(tr)]).time= time;
        results.(['subj' num2str(subjnum)]).mass = subj.mass;
        multi.(['subj' num2str(subjnum)]).(['trial' num2str(tr)]) = multiModel;
        multi.(['subj' num2str(subjnum)]).(['trial' num2str(tr)]).time= time;
        
    end  % end trials loop
    clear tr;
end  % end subj loop


%% pull vars
% if want new vars in raw, subjMeans, or groupMeans...pull manually in
% compileTrialData (into raw...rest will calculate from that)
% all vars defined in compileTrialData
nSubjs = 7;
nTrialsPerCond = 3;
raw = compileTrialData(single, multi, results, subjToProcess);  % returns 101x3x21, 3x101x21, 101x21, etc
subjMeans = getSubjectMeans(raw, nSubjs, nTrialsPerCond);
[groupMeans, groupSD] = groupMeanSD(subjMeans, nSubjs);

subjMeans.posWorkDistMulti = [ ...
        subjMeans.posWorkHipMulti; ...
        subjMeans.posWorkKneeMulti; ...
        subjMeans.posWorkAnkleMulti; ...
        subjMeans.posWorkMF; ...
    ] / subjMeans.totalPosWorkMulti;

subjMeans.posWorkDistSingle = [ ...
        subjMeans.posWorkHipSingle; ...
        subjMeans.posWorkKneeSingle; ...
        subjMeans.posWorkAnkleSingle; ...
    ] / subjMeans.totalPosWorkSingle;
