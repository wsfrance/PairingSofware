function output = deletePlayer(TABLE, MATRICE, option, data, idx)


    % If not, add it to local DB
    DBNameLocal = option.default_DBLocal; % 'NewPlayers_local.csv';
    id_tableLocal = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), DBNameLocal);
    tableLocal = TABLE.MEGA_tablePlayers_fromDB{id_tableLocal,2};
    tableLocal(idx,:) = [];

    % Update the csv file
    fileName = '../data/playerDB/NewPlayers_local.csv';
    writetable(tableLocal,fileName,'Delimiter',option.delimiter)

    disp('Delete Player xxx to database')




end