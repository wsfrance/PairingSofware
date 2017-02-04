function [ out_table ] = Capital_FirstLetter( array_str, column )
%CAPITAL_FIRSTLETTER Summary of this function goes here
%   Detailed explanation goes here

out_table = array_str;

for k = 1:size(column,2)
    column_k = column{k};
    subtable = array_str{:,{column_k}};
    out_array_str = capitalize(subtable);
    if size(out_array_str,1) == 1
        out_table{:,column_k} = out_array_str;
    else
        out_table(:,column_k) = out_array_str;
    end
end




end


function out_array_str = capitalize(array_str)

[m,n]=size(array_str);
out_array_str = cell(m,n);

for i = 1:m
    for j = 1:n
        str = array_str{i,j};
        % str='this is a tEST';
        str=lower(str);
        idx=regexp([' ' str],'(?<=\s+)\S','start')-1;
        str(idx)=upper(str(idx));
        out_array_str{i,j} = str;
    end
end

end
