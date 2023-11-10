function trialModel = applyTrialMarkers(baseModel,mk)

% copy baseModel to keep segments, etc.
trialModel = baseModel;

% get names of each segment's markers and apply the trajs of trial markers (mk) 
for i = 1:length(baseModel.segNames)
    currSeg = baseModel.segNames{i};
    
    segMarkers = fieldnames(baseModel.(currSeg).mkG);
    trialModel.(currSeg).mkG = assignMarkers(mk,segMarkers);
end

