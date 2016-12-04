function [ data, rows] = getCellSelect( UITable )
%GETCELLSELECT Summary of this function goes here
%   Detailed explanation goes here

% UITable = 'TAB_players'

th = findobj('Tag',UITable);
% get current data
data = get(th,'Data');
% get indices of selected rows
rows = get(th,'UserData');


end

