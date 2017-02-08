function [ output_args ] = exportTable2html( tableIn, filename, column, option, caption_str)
%EXPORTTABLE2HTML Summary of this function goes here
%   Detailed explanation goes here

if nargin < 5
    caption_str = [option.tournamentInfo.name ' - Round no.' num2str(option.no_round)];
end



tableIn = tableIn(:,column);

data = table2cell(tableIn);
colheads = tableIn.Properties.VariableNames;


table_cell = [[colheads; data]]; %Add row and col heading cell-arrays onto a double data matrix
% caption_str = [option.tournamentInfo.name ' - Round no.' num2str(option.no_round)];


html_table(table_cell, filename, 'Caption',caption_str, ...
         'DataFormatStr','%1.0f', 'BackgroundColor','#EFFFFF', 'RowBGColour',{'#000099',[],[],[],'#FFFFCC'}, 'RowFontColour',{'#FFFFB5'}, ...
         'FirstRowIsHeading',1, 'FirstColIsHeading',1, 'NegativeCellFontColour','red');


end

