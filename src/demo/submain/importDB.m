function importDB(hObject, eventdata, handles, default_path, files) 

global TABLE option

for i = 1:size(files,1)
    file_i = [default_path files{i}];
    data = csvimport(file_i,'delimiter',option.delimiter);
    disp(['--- Importing: ' file_i])
    
    column_tmp = data(1,:);
    % Delete incorrect characters
    column_tmp = strrep(column_tmp,'?','');
    column_tmp = strrep(column_tmp,'ï','');
    column_tmp = strrep(column_tmp,'»','');
    column_tmp = strrep(column_tmp,'¿','');
    
    TABLE.MEGA_tablePlayers_fromDB{i,1} = files{i};
    TABLE.MEGA_tablePlayers_fromDB{i,2} = array2table(data(2:end,:), 'VariableNames', column_tmp);
            
    % Delete ""
    disp('--- Delete false characters (like ", etc.)')
    TABLE.MEGA_tablePlayers_fromDB{i,2}.name = strrep(TABLE.MEGA_tablePlayers_fromDB{i,2}.name,'"','');
    TABLE.MEGA_tablePlayers_fromDB{i,2}.familyName = strrep(TABLE.MEGA_tablePlayers_fromDB{i,2}.familyName,'"','');
    TABLE.MEGA_tablePlayers_fromDB{i,2}.pseudo = strrep(TABLE.MEGA_tablePlayers_fromDB{i,2}.pseudo,'"','');

    % Capital Letters
    disp(['--- Set Capital Letters to selected columns : ' strjoin(option.columnCapitalLetters,', ')])
    [ TABLE.MEGA_tablePlayers_fromDB{i,2} ] = Capital_FirstLetter( TABLE.MEGA_tablePlayers_fromDB{i,2}, option.columnCapitalLetters );
end

if option.tmp.createTournamentBool == false
    disp('-- Create the variable TABLE.tablePlayers_forTournament')
    % id = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), option.default_DBOnline);
    % TABLE.tablePlayers_forTournament = TABLE.MEGA_tablePlayers_fromDB{id,2}(1,:);
    % TABLE.tablePlayers_forTournament(:,:) = [];
    disp('- Create Tournament database')
    output = create_tablePlayersTournament(TABLE, option);
    TABLE.tablePlayers_forTournament = output;
end