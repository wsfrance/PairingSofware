function loadDefaultPlayer(hObject, eventdata, handles, defaultDB_name)

global TABLE option

if nargin < 4
    defaultDB_name = option.default_DBOnline;
end

% path = pwd;

% From excel file
% default_DB_filename = [path '/import/Database_Players.xls'];
% [~,~,data] = xlsread(default_DB_filename);

% import each csv
disp('-- Importing each database')
dirName = '../data/playerDB';              %# folder path
files = dir( fullfile(dirName,'*.csv') );   %# list all *.xyz files
files = {files.name}';                      %'# file names

% from CSV
% default_DB_filename = '../data/playerDB/fileforsw.csv';
default_path = '../data/playerDB/';

importDB(hObject, eventdata, handles, default_path, files) 

% Set default Database in memory
list = TABLE.MEGA_tablePlayers_fromDB(:,1);
index = strfind_idx(list, defaultDB_name, option.caseInsensitiveOption);
TABLE.tablePlayers_fromDB = TABLE.MEGA_tablePlayers_fromDB{index,2};

% Set the POP menu to default database
contents = cellstr(get(handles.POP_selectDB,'String'));
index = strfind_idx(contents, defaultDB_name, option.caseInsensitiveOption);
set(handles.POP_selectDB,'Value',index)

% Select Data to vizualize
% data = table2cell(TABLE.tablePlayers_fromDB(:,option.columnTableDB));
% set(handles.TAB_players, 'data', data, 'ColumnName', option.columnTableDB)
% data = table2cell(TABLE.tablePlayers_forTournament(:,option.columnTableDB));
% set(handles.TAB_players_Tournament, 'data', data, 'ColumnName', option.columnTableDB)
refreshTables(hObject, eventdata, handles)

% List of sortBy possibilities and display it into handles.POP_sortBy
sortBy_option = ['Sort By'; option.columnTableDB'];
set(handles.POP_sortBy,'String', sortBy_option)  ;