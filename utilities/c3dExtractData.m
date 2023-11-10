function [mk,grf,stanceTime] = c3dExtractData(h,mkCutoff,grfCutoff)
%
% Inputs: h - btk aquisition handle from calling 'h = btkReadAcquisition(c3dFilepath)'
%         mkCutoff, grfCutoff - cutoff values for filtering the data
% 
% Uses BTK v0.3.0
% Extracts marker data and ground reaction wrenches from a c3d file then
% filters them using a 4th order butterworth filter and resamples them to
% 101 points (0-100%) in the stance phase (determined w/ 5N threshold).
% All forces are set to 0 when the vertical force is < 5 N.
%
%
% Justin C. Wager, 17 Aug 2016
% Penn State Univ.

forceThreshold = 5;

% get GRF data
grfRaw = btkGetGroundReactionWrenches(h);
grfFreq = btkGetAnalogFrequency(h);
grfdt = 1/grfFreq;
grfnt = length(grfRaw(1).F(:,1));
grfTime(:,1) = 0:grfdt:(grfnt-1)*grfdt;
% convert COP to m
grfRaw(1).P = grfRaw(1).P/1000;
grfRaw(2).P = grfRaw(2).P/1000;

% get marker data, convert to m
mkRaw = btkGetMarkers(h); 
mkFreq = btkGetPointFrequency(h);
mkdt = 1/mkFreq;
mkRaw = structfun(@(x)(x./1000),mkRaw,'UniformOutput',false);  % mm to m

% check for NaN's in grf data before filtering or will make all values NaN
% interpolate if found (arise from Fy == 0)
grfRaw(1) = structfun(@(x)interpnan(x,grfTime),grfRaw(1),'UniformOutput',false);
grfRaw(2) = structfun(@(x)interpnan(x,grfTime),grfRaw(2),'UniformOutput',false);

% filter grf
grf(1) = structfun(@(x)filtstruct(x,grfCutoff,grfdt),grfRaw(1),'UniformOutput',false);
grf(2) = structfun(@(x)filtstruct(x,grfCutoff,grfdt),grfRaw(2),'UniformOutput',false);

% filter marker trajs
mk = structfun(@(x)filtstruct(x,mkCutoff,mkdt),mkRaw,'UniformOutput',false);

% vert dir is y, 2nd component
Fy = grf(1).F(:,2) + grf(2).F(:,2);
if std(Fy) > 5  % for trials that are not static
    % get stance phase end point times
    [strikeFrame,toeoffFrame] = getEventFrames(Fy,forceThreshold);
    strikeTime = (strikeFrame-1) * grfdt; % -1 b/c frame 1 = 0.0sec
    toeoffTime = (toeoffFrame-1) * grfdt;
    
    mkNames = fieldnames(mkRaw);
    mknt = length(mkRaw.(mkNames{1}));
    mkTime(:,1) = 0:mkdt:(mknt-1)*mkdt;
    
    grfnt = length(grf(1).F(:,1));
    grfTime(:,1) = 0:grfdt:(grfnt-1)*grfdt;
    
    stanceTime(:,1) = linspace(strikeTime,toeoffTime,101);
    
    % resample kinem & grf data
    grf(1) = structfun(@(x)(interp1(grfTime,x,stanceTime,'spline')),grf(1),'UniformOutput',false);
    grf(2) = structfun(@(x)(interp1(grfTime,x,stanceTime,'spline')),grf(2),'UniformOutput',false);
    mk = structfun(@(x)(interp1(mkTime,x,stanceTime,'spline','extrap')),mk,'UniformOutput',false);
    
    % when Fy < 5, all forces == 0
    % these were F(:, 2)
    f1zero = find(grf(1).F(:,2) < 5);
    grf(1).F(f1zero,:) = 0;
    f2zero = find(grf(2).F(:,2) < 5);
    grf(2).F(f2zero,:) = 0;
    
    % calc free moment
    grf(1).FM = zeros(101,3);
    grf(2).FM = zeros(101,3);
    grf(1).FM(:,2) = grf(1).M(:,2) - grf(1).F(:,1).*grf(1).P(:,3) + grf(1).F(:,3).*grf(1).P(:,1);
    grf(2).FM(:,2) = grf(2).M(:,2) - grf(2).F(:,1).*grf(2).P(:,3) + grf(2).F(:,3).*grf(2).P(:,1);
%     grf(1).FM(:,3) = grf(1).M(:,3) - grf(1).F(:,1).*grf(1).P(:,2) + grf(1).F(:,2).*grf(1).P(:,1);
%     grf(2).FM(:,3) = grf(2).M(:,3) - grf(2).F(:,1).*grf(2).P(:,2) + grf(2).F(:,2).*grf(2).P(:,1);
end






