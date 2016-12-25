function [ output_args ] = exportTable2CSV( T, filename, order_column )
%EXPORTTABLE2CSV Summary of this function goes here
%   Detailed explanation goes here


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
A = {'Tournament name - Round no.'};
sheet = 1;
xlRange = 'A1';
xlswrite2(filename,A,sheet,xlRange)

B = {'Date:'};
xlRange = 'A2';
xlswrite(filename,B,sheet,xlRange)

writetable(T_reordered,filename, 'Range','A4')
msg = ['Save into the file :' filename];
disp(msg)
msgbox(msg)

fclose('all')

end

