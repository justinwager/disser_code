% Computes R & V for all segments in "model" structure
%
% Dependancies: RandV
% Variables:    model   - structure containing model information
%               t       - timeframe number (index for marker data)
%               nSegments, segNames
%
% Outputs:  R & V

for i = 1:nSegments     % iterate over all segments in the model
    
    currSeg = segNames{i};
    segMkNames = fieldnames(model.(currSeg).ptsL);
    nSegMarkers = size(segMkNames,1); 
    
    % get local (blueprint) points on this segment @ this time
    loc_cell = struct2cell(model.(currSeg).ptsL);
    for j = 1:nSegMarkers
        local(j,1:3) = loc_cell{j};
    end
    
    % get this  marker's global coords for this frame
    globAll = model.(currSeg).ptsG;     % changes every frame         
    globTF = structfun(@(x)(x(t,:)),globAll,'UniformOutput',false);  % t = only this frame
    globTF = cell2mat(struct2cell(globTF));

    % compute this timeframe's R & V, global to local
    % 3-d array with last index as timeframe num
    [model.(currSeg).R(:,:,t),model.(currSeg).V(t,:),model.(currSeg).rmsd_R(t,:)] = RandV(local,globTF);
    
    clearvars local globTF j currSeg globAll loc_cell segMkNames nSegMarkers
end  % end segments loop
clearvars i 

