function subjMeans = getSubjectMeans(raw, nSubjs, nTrialsPerCond)

for s = 1:nSubjs
    i = s*nTrialsPerCond;
    % for each subject...3d means across trials
    
    subjMeans = structfun(@(x)findSubjMean(x, nSubjs, nTrialsPerCond), raw, 'UniformOutput',...
        false);
%     ankleAngleSingle(:,:,s) = mean(ankleAngleSingle_raw(:,:,i-2:i),3);
%     ankleAngleMulti(:,:,s) = mean(ankleAngleMulti_raw(:,:,i-2:i),3);
%     ankleVelSingle(:,:,s) = mean(ankleVelSingle_raw(:,:,i-2:i),3);
%     ankleVelMulti(:,:,s) = mean(ankleVelMulti_raw(:,:,i-2:i),3);
%     anklePowVecSingle(:,:,s) = mean(anklePowVecSingle_raw(:,:,i-2:i),3);
%     anklePowVecMulti(:,:,s) = mean(anklePowVecMulti_raw(:,:,i-2:i),3);
%     ankleMomSingle_norm(:,:,s) = mean(ankleMomSingle_rawnorm(:,:,i-2:i),3);
%     ankleMomMulti_norm(:,:,s) = mean(ankleMomMulti_rawnorm(:,:,i-2:i),3);
%     ankleMomSingle(:,:,s) = mean(ankleMomSingle_raw(:,:,i-2:i),3);
%     ankleMomMulti(:,:,s) = mean(ankleMomMulti_raw(:,:,i-2:i),3);
end
end  % end main func

function sMean = findSubjMean(x, nSubjs, nTrialsPerCond)
    dims = size(x);
    subjDim = find(dims==(nSubjs*nTrialsPerCond));
    if subjDim == 1 && ndims(x) == 2
        for s = 1:nSubjs
            i = s*nTrialsPerCond;
            sMean(s,:) = mean(x(i-2:i,:),subjDim);
        end
    elseif subjDim == 2 && ndims(x) == 2
        for s = 1:nSubjs
            i = s*nTrialsPerCond;
            sMean(:,s) = mean(x(:,i-2:i),subjDim);
        end
    elseif subjDim == 1 && ndims(x) == 3
        for s = 1:nSubjs
            i = s*nTrialsPerCond;
            sMean(s,:,:) = mean(x(i-2:i,:,:),subjDim);
        end
    elseif subjDim == 2 && ndims(x) == 3
        for s = 1:nSubjs
            i = s*nTrialsPerCond;
            sMean(:,s,:) = mean(x(:,i-2:i,:),subjDim);
        end
    elseif subjDim == 3 && ndims(x) == 3
        for s = 1:nSubjs
            i = s*nTrialsPerCond;
            sMean(:,:,s) = mean(x(:,:,i-2:i),subjDim);
        end
    else  % ndims == 1
        sMean = mean(x);
    end
end
