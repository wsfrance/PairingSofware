function [ output_args ] = export_XLS2PDF( filename, filename2, option )
%EXPORT_XLS2PDF Summary of this function goes here
%   Detailed explanation goes here

hExcel = actxserver('Excel.Application');
% hWorkbook = hExcel.Workbooks.Open(sprintf('%s','C:\test.xlsx'));
hWorkbook = hExcel.Workbooks.Open(sprintf('%s',filename));
hWorksheet = hWorkbook.Sheets.Item(1);

% Landscape
% hWorksheet.PageSetup.Orientation = 1; 

% print this sheet to PDF
hWorksheet.ExportAsFixedFormat('xlTypePDF',filename2);
% open file externally
open(filename2)

% Close object
Quit(hExcel)
delete(hExcel)
end

