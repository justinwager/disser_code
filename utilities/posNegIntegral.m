function [pos, neg] = posNegIntegral(x, y)
% compute the integral of positive and negative portions of a curve
% start = frame to start looking for x-intercept, can be used to avoid
% portions of the curve that cross zero early on

if size(y,2) > 1
    y = y';
end
if size(x,2) > 1
    x = x';
end

% get rid of zeros at start and end of data
data_start = find(y,1);
data_end = find(y, 1, 'last');
starting_zeros = data_start - 1;
ending_zeros = length(x) - data_end;
y_orig = y;
x_orig = x;
y = y(data_start:data_end);
x = x(data_start:data_end);
n = length(x);

% find frames when y = 0, used for separating pos and neg locations
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
x_idx = zci(y);
x_idx = x_idx(x_idx<n);

for i = 1:length(x_idx)
    % next line may not be accurate but usually is for biomech data
    % could need to include x_idx(i)-1 at the start of the range
    idx_rng = x_idx(i):x_idx(i)+1;                                     
    xval(i) = interp1(y(idx_rng), x(idx_rng), 0, 'linear','extrap');
    yval(i) = interp1(x(idx_rng), y(idx_rng), xval(i), 'linear','extrap');
end

% construct posInt vars, including 0
pos = zeros(1,length(x_idx)+1);
neg = zeros(1,length(x_idx)+1);
for i = 1:length(x_idx)
    % set data for integral
    if i==1            
        integx = [x(1:x_idx(i)); xval(i)]; 
        integy = [y(1:x_idx(i)); yval(i)]; 
    else
        xstart = x_idx(i-1);    
        integx = [xval(i-1); x(x_idx(i-1)+1 : x_idx(i)); xval(i)];
        integy = [yval(i-1); y(x_idx(i-1)+1 : x_idx(i)); yval(i)];
    end
    
    nanidx = isnan(integy);
    integy(nanidx) = [];
    integx(nanidx) = [];
    
    % integrate
    if mean(integy, 'omitnan')>0
        pos(i) = trapz(integx,integy);
    elseif mean(integy, 'omitnan')<0
        neg(i) = trapz(integx,integy);
    else  % mean is 0
        disp('zero period in PosNegIntegral');
    end
end

% integrate last period
integx = [xval(end); x(x_idx(end)+1:end)]; 
integy = [yval(end); y(x_idx(end)+1:end)]; 

% integrate
if mean(integy, 'omitnan')>0
    pos(end) = trapz(integx,integy);
elseif mean(integy, 'omitnan')<0
    neg(end) = trapz(integx,integy);
else  % mean is 0
    disp('zero period in PosNegIntegral');
end



