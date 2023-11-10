function raw = compileTrialData(single, multi, results, subjToProcess)

raw = struct();
c = 0;
for s = 1:length(subjToProcess)
    for tr = 4:6
        c = c+1;  % subj-trial counter
        currsubj = subjToProcess(s);
        raw.ankleAngleSingle(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.angles;
        raw.ankleAngleMulti(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.angles;
        raw.ankleVelSingle(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.w;
        raw.ankleVelMulti(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.w;
        raw.ankleMomSingle_norm(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).foot.proxM / results.(['subj' num2str(currsubj)]).mass;
        raw.ankleMomMulti_norm(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).hf.proxM / results.(['subj' num2str(currsubj)]).mass;
        raw.ankleMomSingle(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).foot.proxM;
        raw.ankleMomMulti(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).hf.proxM;
        raw.anklePowVecMulti_norm(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.power3dvec / results.(['subj' num2str(currsubj)]).mass;
        raw.anklePowVecSingle_norm(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.power3dvec / results.(['subj' num2str(currsubj)]).mass;
        
        raw.kneeAngleSingle(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.angles;
        raw.kneeAngleMulti(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.angles;
        raw.kneeVelSingle(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.w;
        raw.kneeVelMulti(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.w;
        raw.kneeHelical(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.helical.angle;
%         raw.kneeMomSingle_norm(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).shank.proxM / results.(['subj' num2str(currsubj)]).mass;
%         raw.kneeMomMulti_norm(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).shank.proxM / results.(['subj' num2str(currsubj)]).mass;
%         raw.kneeMomSingle(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).shank.proxM;
%         raw.kneeMomMulti(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).shank.proxM;
%         raw.kneePowVecMulti_norm(:,:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.power3dvec / results.(['subj' num2str(currsubj)]).mass;
%         raw.kneePowVecSingle_norm(:,:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.power3dvec / results.(['subj' num2str(currsubj)]).mass;
        
        % grieve stuff
        raw.ankleZsingle(:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.angles(3,:);
        raw.ankleZmulti(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.angles(3,:);
        raw.ankleVelZSingle(:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.w(3,:)';
        raw.ankleVelZMulti(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.w(3,:)';
        raw.ankleMomZSingle_norm(:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).foot.proxM(:,3) / results.(['subj' num2str(currsubj)]).mass;
        raw.ankleMomZMulti_norm(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).hf.proxM(:,3) / results.(['subj' num2str(currsubj)]).mass;
        raw.ankleMomZSingle(:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).foot.proxM(:,3);
        raw.ankleMomZMulti(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).hf.proxM(:,3);
        raw.shlen(:,c) = single.(['subj' num2str(currsubj)]).trial4.shank.length;
        raw.kneeAngleZsingle(:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.angles(3,:);
        raw.kneeAngleZmulti(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.angles(3,:);
        
        raw.singleTime(:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).time;
        raw.multiTime(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).time;
        
        raw.mtpAngleMulti(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).mtpjt.angles(3,:)';
        raw.mtpAngleSingle(:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).mtpjt.angles(3,:)';
        
        raw.anklePowerMulti(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.power / results.(['subj' num2str(currsubj)]).mass;
        raw.anklePowerSingle(:,c) = single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.power / results.(['subj' num2str(currsubj)]).mass;
        raw.powMF(:,c) =  multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).midftjt.power / results.(['subj' num2str(currsubj)]).mass;
        raw.posWorkMF(c) =  sum(multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).midftjt.poswork) / results.(['subj' num2str(currsubj)]).mass;
        raw.negWorkMF(c) =  sum(multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).midftjt.negwork) / results.(['subj' num2str(currsubj)]).mass;
        raw.posWorkAnkleSingle(c) =  sum(single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.poswork) / results.(['subj' num2str(currsubj)]).mass;
        raw.negWorkAnkleSingle(c) =  sum(single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.negwork) / results.(['subj' num2str(currsubj)]).mass;
        raw.posWorkAnkleMulti(c) =  sum(multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.poswork) / results.(['subj' num2str(currsubj)]).mass;
        raw.negWorkAnkleMulti(c) =  sum(multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.negwork) / results.(['subj' num2str(currsubj)]).mass;
        raw.posWorkKneeSingle(c) =  sum(single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.poswork) / results.(['subj' num2str(currsubj)]).mass;
        raw.negWorkKneeSingle(c) =  sum(single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.negwork) / results.(['subj' num2str(currsubj)]).mass;
        raw.posWorkKneeMulti(c) =  sum(multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.poswork) / results.(['subj' num2str(currsubj)]).mass;
        raw.negWorkKneeMulti(c) =  sum(multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).kneejt.negwork) / results.(['subj' num2str(currsubj)]).mass;
        raw.posWorkHipSingle(c) =  sum(single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).hipjt.poswork) / results.(['subj' num2str(currsubj)]).mass;
        raw.negWorkHipSingle(c) =  sum(single.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).hipjt.negwork) / results.(['subj' num2str(currsubj)]).mass;
        raw.posWorkHipMulti(c) =  sum(multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).hipjt.poswork) / results.(['subj' num2str(currsubj)]).mass;
        raw.negWorkHipMulti(c) =  sum(multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).hipjt.negwork) / results.(['subj' num2str(currsubj)]).mass;
        raw.totalPosWorkSingle(c) = raw.posWorkAnkleSingle(c) + raw.posWorkKneeSingle(c) + raw.posWorkHipSingle(c);
        raw.totalPosWorkMulti(c) = raw.posWorkMF(c) + raw.posWorkAnkleMulti(c) + raw.posWorkKneeMulti(c) + raw.posWorkHipMulti(c);
        
        raw.mfAngVel(:,c) =  multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).anklejt.w(3,:)';
        raw.mfMom(:,c) = multi.(['subj' num2str(currsubj)]).(['trial' num2str(tr)]).ff.proxM(:,3) / results.(['subj' num2str(currsubj)]).mass;
        
        raw.ankleROMSingle(:,c) = max(raw.ankleAngleSingle(:,:,c),[],2) - min(raw.ankleAngleSingle(:,:,c),[],2);
        raw.ankleROMMulti(:,c) = max(raw.ankleAngleMulti(:,:,c),[],2) - min(raw.ankleAngleMulti(:,:,c),[],2);
    end
end