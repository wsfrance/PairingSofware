function refreshTables(hObject, eventdata, handles, type)

global TABLE option
if nargin < 4 
    refreshTables(hObject, eventdata, handles, 'DB')
    refreshTables(hObject, eventdata, handles, 'tournament')
else
    switch type
        case 'DB'        
            column2sort     = option.column2sortDB      ;
            table_tmp       = TABLE.tablePlayers_fromDB ;
            handle_display  = handles.TAB_players       ;
            column2display  = option.columnTableDB      ;
            sortOrder       = option.sortOrderDB        ;
            displayOrderTable(option, column2sort, table_tmp, handle_display, column2display, sortOrder)

        case 'tournament'
            column2sort     = option.column2sortTournament      ;
            table_tmp       = TABLE.tablePlayers_forTournament  ;
            handle_display  = handles.TAB_players_Tournament    ;
            column2display  = [option.columnTableDB option.additionnalTournamentVariable];
            sortOrder       = option.sortOrderTournament        ;
            displayOrderTable(option,column2sort, table_tmp, handle_display, column2display, sortOrder)

            % data = table2cell(TABLE.tablePlayers_forTournament(:,option.columnTableDB));
            % set(handles.TAB_players_Tournament, 'data', data, 'ColumnName', option.columnTableDB)
        otherwise
            disp('case not known')
    end
end