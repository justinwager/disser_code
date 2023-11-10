function [mrkStruct] = assignMarkers(markerStruct,markersToAssign)
%
% Inputs:
%       markerStruct         - structure with all markers
%       markersToAssign     - cell of char arrays with name of markers to assign
%
% Outputs:
%       mrkStruct       - structure with one field for each marker
%
% Justin C. Wager, Penn State University
% 29 Apr 2016
%

nMarkers = length(markersToAssign);
for i = 1:nMarkers
    mrkName = markersToAssign{i};
    mrkStruct.(mrkName) = getfield(markerStruct,mrkName);
end