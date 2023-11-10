function [fdata] = bfiltmat(dt, cutoffs, forder, data);

%  bandpass filters data forward and reverse using butterworth filter
%  on columns of matrix elements
%
%  calling - [fdata] = filtmat(dt, cutoff, forder, data)
%  -------
%
%  John H. Challis, The Penn. State University
%  May 2, 1997
%
%  inputs
%  ------
%  dt      - interval between samples
%  cutoffs - required frequencies of bandpass filter [ co_low co_high]
%  forder  - order of filter
%  data    - the matrix containing the data
%
%  output
%  ------
%  fdata - the filtered input data
%
%  calls
%  -----
%  paddon  - pads data matrix prior to filtering to remove end point problems
%  paddoff - unpads data matrix after filtering
%

%  adjust cut-off to allow for double pass
%
cutoffs = cutoffs / (sqrt(2)-1)^(0.5/forder);

%  compute coefficients
%
[b,a] = butter(forder, 2*cutoffs*dt);

%  padd data to allow for end point problems
%
[data, nadd] = paddon(data);

%  how much data
%
[m,n] = size(data);

%  filter the data
%
for i=1:n
   fdata(:,i) = filtfilt(b,a,data(:,i));
end

%  unpad data
%
fdata = paddoff( fdata, nadd);

%%% the end %%%