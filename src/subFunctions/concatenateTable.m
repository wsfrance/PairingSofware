function output = concatenateTable(globalTable, subtable)

    variableGlobal = globalTable.Properties.VariableNames;
    variableLocal = subtable.Properties.VariableNames;
    
    % Common variable
    commonVariables = intersect(variableGlobal,variableLocal);
    
    % Final variable
    finalvarialbe = union(variableGlobal,variableLocal);
    
    % Find variable not present in variableGlobal
    notIn_variableGlobal = setdiff(variableLocal, variableGlobal)
    
    % Find variable not present in variableLocal
    notIn_variableLocal = setdiff(variableGlobal, variableLocal)
    
    % Fill each table
    globalTable2 = copyTable(globalTable, notIn_variableGlobal, finalvarialbe);
    subtable2    = copyTable(subtable, notIn_variableLocal, finalvarialbe);
    
    output = [globalTable2; subtable2];
    disp('Finish')
end


function subtable2 = copyTable(subtable, notIn_variableLocal, finalvarialbe)


if isempty(notIn_variableLocal) == 0
        void = repmat({''},size(notIn_variableLocal));
        newtable = cell2table(void,'VariableNames',notIn_variableLocal);
        subtable2 = [subtable newtable];
    else
        subtable2 = subtable;
end

subtable2 = subtable2(:,finalvarialbe);
    
end