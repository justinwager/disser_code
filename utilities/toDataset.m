modelType = [repmat({'multi'},21,1); repmat({'single'},21,1)];
trial = repmat({4,5,6}',14,1);
ds = dataset(modelType, trial);
for i = 1:length(subjToProcess)  
    k = 3*i;
    j = k-2;
    s(j:k,1) = i;
end
ds.subject = repmat(s,2,1);

ds.ankPow = [max(powMulti)'; max(powSingle)'];
ds.ankPosWork = [posworkAnkle'; posworkAnkleSingle'];
ds.ankNegWork = [negworkAnkle'; negworkAnkleSingle'];
ds.ankDfVel = [max(angVel_multiraw)'; max(angVel_singleraw)'];
ds.ankPfVel = [min(angVel_multiraw)'; min(angVel_singleraw)'];
ds.ankMom = [min(ankleMomMulti_rawnorm)';min(ankleMomSingle_rawnorm)'];
ds.mfPow = max(powMF)';
ds.mfPosWork = posworkMF';
ds.mfNegWork = negworkMF';
ds.mfDfVel = max(mf_angVel)';
ds.mfPfVel = min(mf_angVel)';
ds.mfMom = min(mf_Mom)';





ds.Properties.VarNames = {'model',	'subj',	'trial',	'pkPower',	'posWork',	'negWork',	'pkPfVel',	'pkDfVel',	'pkMoment',	'pkPowerMF',	'posWorkMF',	'negWorkMF',	'pkPfVelMF',	'pkDfVelMF',	'pkMomentMF'};