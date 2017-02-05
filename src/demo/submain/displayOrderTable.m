function displayOrderTable(option, column2sort, table_tmp, handle_display, column2display, sortOrder)

if isfield(option,'column2sortDB') == 0
    bool = true;
elseif strcmp(column2sort,'Sort By') == 0
    bool = true;
else
    bool = false;
end

if bool
    data2 = sortrows(table_tmp(:,column2display), column2sort, sortOrder);
else
    disp('This is SORT BY')
    data2 = table_tmp(:,column2display);
end
data2 = table2cell(data2);
set(handle_display, 'data', data2, 'ColumnName', column2display)