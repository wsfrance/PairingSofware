function output = editExistingPlayer(TABLE, MATRICE, option, data, idx)

variableName = data.Properties.VariableNames;

% % Delete WSCode
% idx = strfind_idx(variableName', 'WSCode');
% variableName2 = variableName;
% variableName2(idx) = [];

% Ask for the new player
prompt      = variableName;
dlg_title   = 'Edit existing Player';
num_lines   = 1;
defaultans  = table2cell(data);
answer      = inputdlg(prompt,dlg_title,num_lines, defaultans);

if isempty(answer) == 0
    cellNewPlayer   = answer;
    tableNewPlayer  = cell2table(cellNewPlayer', 'Variable', variableName);

    % If not, add it to local DB
    DBNameLocal = option.default_DBLocal; % 'NewPlayers_local.csv';
    id_tableLocal = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), DBNameLocal);
    tableLocal = TABLE.MEGA_tablePlayers_fromDB{id_tableLocal,2};
    tableLocal(idx,:) = tableNewPlayer;

    % Update the csv file
    fileName = '../data/playerDB/NewPlayers_local.csv';
    writetable(tableLocal,fileName,'Delimiter',option.delimiter)

    disp('Add Player xxx to database')
else
    disp('- Editing was cancelled')
end



end