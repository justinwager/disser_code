vars = {'power', ...
        'w', ...
        'work', ...
        'poswork', ...
        'negwork'};
test = {'max',...
        'min',...
        'max',...
        'max',...
        'min'};
nTrials = 3;
for i = 1:length(subjToProcess)
    curr = ['subj' num2str(subjToProcess(i))]; 
    subjdata = multi.(curr);
    k = (i*nTrials)-(nTrials-1);
    for j = 1:length(vars)
        currvar = vars{j};
        for t = 4:6
            currtr = ['trial' num2str(t)];
            if size(subjdata.(currtr).anklejt.(currvar),2) > 3
                subjdata.(currtr).anklejt.(currvar) = subjdata.(currtr).anklejt.(currvar)';
            end
            
            hold.(currvar)(k) = max(subjdata.(currtr).anklejt.(currvar));
            k = k+1;
        end
    end
end
