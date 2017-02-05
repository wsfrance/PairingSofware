function output = create_tablePlayersTournament(TABLE, option)

id = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), option.default_DBOnline);
subtable = TABLE.MEGA_tablePlayers_fromDB{id,2};
variableName = subtable.Properties.VariableNames;
variableName = [variableName option.additionnalTournamentVariable];
void = repmat({''},size(variableName));
output = cell2table(void,'VariableNames',variableName);
output(:,:) = [];
