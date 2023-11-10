function [fdata2] = fdiff2(dt, cutoff, forder, data);

%  differentiate and filter data forward and reverse using butterworth
%  filter on columns of matrix elements, second derivative.
%
%  [fdata2] = fdiff2(dt, cutoff, forder, data)
%
%  John H. Challis, The Penn. State University
%  January 19, 1998
%
%  inputs
%  ------
%  dt     - interval between samples
%  cutoff - required cut-off frequency
%  forder - order of filter
%  data   - the matrix containing the data
%
%  output
%  ------
%  fdata2 - the filtered second derivative of input data
%
%  calls
%  -----
%  paddon  - pads data matrix prior to filtering to remove end point problems
%  paddoff - unpads data matrix after filtering
%

%  adjust cut-off to allow for double pass
%
cutoff = cutoff / (sqrt(2)-1)^(0.5/forder);

%  compute coefficients
%
[b,a] = butter(forder, 2*cutoff*dt);

%  padd data to allow for end point problems
%
[data, nadd] = paddon(data);

%  how much data
%
[n,m] = size(data);

%  filter the data
%
for i=1:n
fdata(i,:) = filtfilt(b,a,data(i,:));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
%  compute second derivative of the data using first order finite difference  %
%																			  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  for beginning of data set
%
fdata2(:,1) = ( fdata(:,3) - (fdata(:,2) *2.) + fdata(:,1) ) / (dt^2);

%  main bulk of data
%
for i=2:m-1
fdata2(:,i) = ( fdata(:,i+1) -  (fdata(:,i) * 2.) + fdata(:,i-1) ) / (dt^2);
end

%  at end of data set
%
fdata2(:,m) = ( fdata(:,m) - (fdata(:,m-1) * 2.) + fdata(:,m-2) ) / (dt^2);

%  unpad data
%
fdata2 = paddoff(fdata2, nadd);


%%% the end %%%
