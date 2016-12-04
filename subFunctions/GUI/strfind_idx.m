function [ row, col, v ] = strfind_idx( Table, str )
%STRFIND_IDX Summary of this function goes here
%   Detailed explanation goes here

% Table = tablePlayers_fromDB.WSCode;
% str   = WSCode_i;

IndexC= strfind(Table, str);
[row, col, v] = find(not(cellfun('isempty', IndexC)));

end

