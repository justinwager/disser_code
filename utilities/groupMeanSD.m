function [groupMean, groupSD] = groupMeanSD(subjMeans, numsubjs)
    
    groupMean = structfun(@(x) calcGroupMean(x, numsubjs), subjMeans, ...
                        'UniformOutput', false);                
    groupSD = structfun(@(x) calcGroupSD(x, numsubjs), subjMeans, ...
                        'UniformOutput', false);
end

function xMean = calcGroupMean(x, numsubjs)
    dims = size(x);
    subjDim = find(dims==numsubjs);  % mean across this dim
    xMean = mean(x, subjDim);
end

function xSD = calcGroupSD(x, numsubjs)
    dims = size(x);
    subjDim = find(dims==numsubjs);  % mean across this dim
    xSD = std(x, [], subjDim);
end