function [fdata] = filtstruct(data,cutoff,dt)
% Single input data filtering for use with structfun
% 2nd order recursive Butterworth filter 
% Inputs:   data    - data to be filtered, usually x,y,z, marker positions [ ncoords x nt ]
%           cutoff  - filter cutoff
%           dt      - sampling interval
% Outputs:
%       fdata   - filtered coordinate data
%
% Justin C. Wager, Penn State University
% 26 Apr 2016
% Main code by J.H. Challis

% convert data to double for filtfilt
data = double(data);

% set up cutoff frequency,filter order, & dt
forder = 2;

%  adjust cut-off to allow for double pass
cutoff = cutoff / (sqrt(2)-1)^(0.5/forder);

%  compute coefficients
[b,a] = butter(forder, 2*cutoff*dt);

%  padd data to allow for end point problems
[data, nadd] = paddon(data);

%  how much data
[~,n] = size(data);

%  filter the data
for i=1:n
   fdata(:,i) = filtfilt(b,a,data(:,i));
end

%  unpad data
fdata = paddoff( fdata, nadd);

%%% the end %%%