function [fdata1] = fdiff1(dt, cutoff, forder, data);

%  differentiate and filter data forward and reverse using butterworth
%  filter on columns of matrix elements
%  [fdata1] = fdiff1(dt, cutoff, forder, data)
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
%  fdata1 - the filtered first derivative of input data
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
%  compute first derivative of the data using first order finite difference	 %
%																			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  for beginning of data set
%
fdata1(:,1) = ( fdata(:,2) - fdata(:,1) ) / dt;

%  main bulk of data
%
for i=2:m-1
fdata1(:,i) = ( fdata(:,i+1) -  fdata(:,i-1) ) / (dt + dt);
end

%  at end of data set
%
fdata1(:,m) = ( fdata(:,m) - fdata(:,m-1) ) / dt;


%  unpad data
%
fdata1 = paddoff( fdata1, nadd);


%%% the end %%%
