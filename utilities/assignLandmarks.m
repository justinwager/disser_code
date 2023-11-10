function [ldmkStruct] = assignLandmarks(landmarkStruct,landmarksToAssign)
%
% Inputs:
%       landmarkStruct         - structure with all markers
%       landmarksToAssign     - cell of char arrays with name of markers to assign
%
% Outputs:
%       mrkStruct       - structure with one field for each marker
%
% Justin C. Wager, Penn State University
% 29 Apr 2016
%

nMarkers = length(landmarksToAssign);
for i = 1:nMarkers
    ldmkName = landmarksToAssign{i};
    ldmkStruct.(ldmkName) = getfield(landmarkStruct,ldmkName);
end