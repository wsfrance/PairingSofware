function [inTable] = tableAllocation(sizeTable, inTable, templateOneLine)
% Allocate table inTable as a replicate of templateOneLine

% Empty the table
inTable(:,:) = [];

% Fill the table
for i = 1:sizeTable
    inTable(i,:) = cell2table(templateOneLine);
end
