function [ output_args ] = exportTable2CSV( T, filename, order_column, option )
%EXPORTTABLE2CSV Summary of this function goes here
%   Detailed explanation goes here

% hWait = waitbar(0,'Please wait...');

% Export to CSV

% [~, ind] = ismember(option.column2displayStanding, T.Properties.VariableNames);
T_reordered = T(:,order_column);

% writetable(T,'Standings.xls','Delimiter',',','QuoteStrings',true)
%filename = 'Standings.xls';

if exist(filename, 'file') == 2
    disp('File already exists. Deleting it')
    delete(filename);
end

% Write Tournament name
A = {[option.tournamentInfo.name ' - Round no.' num2str(option.no_round)]};
sheet = 1;
xlRange = 'A1';
xlswrite2(filename,A,sheet,xlRange)

B = {['Date: ' option.tournamentInfo.date]};
xlRange = 'A2';
xlswrite(filename,B,sheet,xlRange)

writetable(T_reordered,filename, 'Range','A4')
msg = ['Save into the file :' filename];
disp(msg)
% msgbox(msg)

% Put in bold
h = actxserver('Excel.Application');
hWorkbook = h.Workbooks.Open(sprintf('%s',filename));
hWorksheet = hWorkbook.Sheets.Item(1);
cells = hWorksheet.Range('A1:Z4');
set(cells.Font, 'Bold', true)
% hWorksheet.Range('A1:Z1').EntireColumn.AutoFit;
hWorkbook.Save
% Close object
Quit(h)
delete(h)

% close(hWait) 

fclose('all');

end

