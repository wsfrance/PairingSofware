function [ row, col, v ] = strfind_idx( Table, str, caseInsensitiveOption )
%STRFIND_IDX Summary of this function goes here
%   Detailed explanation goes here

% Table = tablePlayers_fromDB.WSCode;
% str   = WSCode_i;

if nargin < 3
    caseInsensitiveOption = true;
    disp('No caseInsensitiveOption. Putting by default to true')
end

if caseInsensitiveOption
    Table = lower(Table);
    str = lower(str);
end

IndexC= strfind(Table, str);
[row, col, v] = find(not(cellfun('isempty', IndexC)));

end

