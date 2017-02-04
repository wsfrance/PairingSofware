function output = addNewPlayer(TABLE, MATRICE, option)

variableName = TABLE.tablePlayers_forTournament.Properties.VariableNames;

% Delete WSCode
idx = strfind_idx(variableName', 'WSCode');
variableName2 = variableName;
variableName2(idx) = [];

% Ask for the new player
prompt      = variableName2;
dlg_title   = 'New Player';
num_lines   = 1;
defaultans  = variableName2;
answer      = inputdlg(prompt,dlg_title,num_lines, defaultans);

% Generate a random WS Code starting by ZZZ...
% wscode_i = 'ZZabc';
symbols = ['A':'Z' '0':'9'];
MAX_ST_LENGTH = 3;
stLength = randi(MAX_ST_LENGTH);
nums = randi(numel(symbols),[1 stLength]);
wscode_i = ['ZZZ' symbols(nums)];

answer = answer';
cellNewPlayer   = [answer(1:idx-1) wscode_i answer(idx:end)];
tableNewPlayer  = cell2table(cellNewPlayer, 'Variable', variableName);

% Capital Letters
[ tableNewPlayer ] = Capital_FirstLetter( tableNewPlayer, option.columnCapitalLetters );

% Check if it exists in fileforcsv.csv
DBName = option.default_DBOnline ; % 'fileforsw.csv';
[bool_continue1] = checkIfexist (DBName, TABLE, tableNewPlayer);

% Check if it exists already in the local DB
DBNameLocal = option.default_DBLocal; % 'NewPlayers_local.csv';
[bool_continue2] = checkIfexist (DBNameLocal, TABLE, tableNewPlayer);

if bool_continue1 && bool_continue2
    % If not, add it to local DB
    id_tableLocal = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), DBNameLocal);
    tableLocal = TABLE.MEGA_tablePlayers_fromDB{id_tableLocal,2};
    tableLocal = [tableLocal; tableNewPlayer];

    % Update the csv file
    fileName = '../data/playerDB/NewPlayers_local.csv';
    writetable(tableLocal,fileName,'Delimiter',option.delimiter)

    disp('Add Player xxx to database')
end

end


function [bool_continue1] = checkIfexist (DBName, TABLE, tableNewPlayer)

id_tableLocal = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), DBName);
column = {'familyName' 'name'};
tableGlobal   = TABLE.MEGA_tablePlayers_fromDB{id_tableLocal,2};
tableGlobal   = tableGlobal(:,column);
nameAndFamily = tableNewPlayer(:,column);
[bool_exist, idx] = checkIfexist2(nameAndFamily, tableGlobal);

if bool_exist
    disp('- Player already exist in the DB.')
    % Construct a questdlg with three options
    choice = questdlg(['This player already exist in the database ' DBName '. Do you still want to create this player (number ' num2str(idx) ') ?'], ...
        'Question', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            disp([choice ' coming right up.'])
            bool_continue1 = true;
        case 'No'
            disp([choice ' coming right up.'])
            bool_continue1 = false;
    end
else
    bool_continue1 = true;
end
end



function [bool_exist, idx2] = checkIfexist2(nameAndFamily, table)
% Both are tables
globaldata = table2cell(table);
data = table2cell(nameAndFamily);
idx = ismember(globaldata,data);


[tf,loc] = ismember(idx,0);
% returns a matrix, tf, where a row of zeros indicates no zeros in the
% the corresponding row of A
S = zeros(size(tf));
[C,IA,IS] = intersect(tf,S,'rows');
fprintf('The row with no zeros in A is %d\n',IA);

% idx = ismember(table,nameAndFamily);
% idx2 = find(idx==true);

idx2 = IA;

if isempty(idx2) == 1
    bool_exist = false;
else
    bool_exist = true;
end

end