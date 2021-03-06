function varargout = BushiSoftGUI(varargin)
% BUSHISOFTGUI MATLAB code for BushiSoftGUI.fig
%      BUSHISOFTGUI, by itself, creates a new BUSHISOFTGUI or raises the existing
%      singleton*.
%
%      H = BUSHISOFTGUI returns the handle to a new BUSHISOFTGUI or the handle to
%      the existing singleton*.
%
%      BUSHISOFTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUSHISOFTGUI.M with the given input arguments.
%
%      BUSHISOFTGUI('Property','Value',...) creates a new BUSHISOFTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BushiSoftGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BushiSoftGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BushiSoftGUI

% Last Modified by GUIDE v2.5 16-Feb-2017 11:06:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BushiSoftGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BushiSoftGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BushiSoftGUI is made visible.
function BushiSoftGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BushiSoftGUI (see VARARGIN)

% Choose default command line output for BushiSoftGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BushiSoftGUI wait for user response (see UIRESUME)
% uiwait(handles.BushiSoftGUI);

%--------------------------------------------------------------------------
% User Personal Code

% Clean up console
clc
disp('Cleaning up console')
disp('Cleaning up variables')
clearvars -global

h = waitbar(0.50,'Welcome to the New Pairing Software. Please wait ...');

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Tournament Pairing Software')
disp('Author: malganis35')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

disp('Opening of the software')

disp('- Change automatically the directory')
currentpath = fileparts(mfilename('fullpath'));
cd(currentpath)

global TABLE option timer

% Add path, subfunctions, etc.
disp('- Add paths : subfunctions, externalLibs, etc.')
addPath_bushisoft( );

% User Define
disp('Load Default Config')
defaultConfig; % Default config
    
    disp('- Allocate table for QR codes')
    TABLE.playerQR = [];
    
% disp('- Ask Login and Password')
% [login, password] = logindlg('Title','Login Title');
% if strcmp(login, 'wsfrance') == 1 || strcmp(password, 'etoile') == 1    
    
    disp('- Quit the Application')
    quitApplication ();

    % Visibility off for tournament
    disp('- Visibility off for tournament elements of GUI')
    mode = 'off';
    showHandlesTournament(handles, mode);

    % Set title
    set(handles.BushiSoftGUI, 'Name', 'Tournament Pairing Software (by malganis35)');

    % Create Data
    disp('- Generate Tables from local DB: tablePlayers_fromDB and tablePlayers_forTournament / Refresh Local DB')
    warning('off','all')
    BUT_refreshLocalDB_Callback(hObject, eventdata, handles)
    warning('on','all')
    
    % Remove spaces at the begining and at the end
    % tablePlayers_fromDB_tmp = table2cell(tablePlayers_fromDB);
    % tablePlayers_fromDB_tmp = strtrim(tablePlayers_fromDB_tmp);
    % tablePlayers_fromDB = tablePlayers_fromDB_tmp;

    % Initialize functions to Tables
    disp('- Initialize functions (@cellSelect) to Tables')
    set(handles.TAB_players, 'CellSelectionCallback',@cellSelect); 
    % set(handles.TAB_players,'CellSelectionCallback',@MouseClickHandler); % for single and double click
    set(handles.TAB_players_Tournament, 'CellSelectionCallback',@cellSelect);

    % Logo
    disp('- Display Logo on the Software')
    displayLogo(hObject, eventdata, handles) 

    % delete all files in /export
    fclose('all');
    disp('- Delete all files in /export')
    delete('export/*.xls')
    delete('export/*.xlsx')
    delete('export/*.pdf')
    delete('export/*.html')
    delete('export/*.csv')
    
    % Save state automatically
    % disp('- Save state automatically of the GUI')
    % timer.b = saveState(option.periodOfSave);
      
% else
%     disp('Wrong password of username')
%     % close
% end

close(h)


% --- Outputs from this function are returned to the command line.
function varargout = BushiSoftGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in BUT_addPlayer.
function BUT_addPlayer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_addPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

% Get the cells selected in 'TAB_players'
UITable = 'TAB_players';
[ data, rows] = getCellSelect( UITable );
rows = unique(rows); % to avoid multiple selection on the same line

% If the selection is not empty, transfer player from
% TABLE.tablePlayers_fromDB to TABLE.tablePlayers_forTournament
if isempty(data)~=1
    list_data = data(rows,1);
    % Loop if multiple players are selected
    bool_msg = false;
    
    % Find index of players on the DB database based on their WSCode
    IDX = ismember(TABLE.tablePlayers_fromDB.WSCode, list_data);
    idx = find(IDX == true);
    selected_data = TABLE.tablePlayers_fromDB(idx,:);
    
    % Delete data that are already in the DB for tournament
    wsCodeTmp = selected_data.WSCode;
    IDX = ismember(TABLE.tablePlayers_forTournament.WSCode, wsCodeTmp);
    idx = find(IDX == true);
    if isempty(idx) == false
        bool_msg = true; 
    end
    selected_data(idx,:) = [];
    
    % Add data to the table tablePlayers_forTournament
    output = concatenateTable(TABLE.tablePlayers_forTournament, selected_data);
    TABLE.tablePlayers_forTournament = output;
    
%     % Old code    
%     for i = 1:length(rows)
%         % Rely on WSCode that is unique for players
%         WSCode_i = list_data{i,1};
%         Index = strfind_idx( TABLE.tablePlayers_fromDB.WSCode, WSCode_i, option.caseInsensitiveOption );
%         selected_data = TABLE.tablePlayers_fromDB(Index,:);
%         % check if player is already added
%         Index2 = strfind_idx( TABLE.tablePlayers_forTournament.WSCode, WSCode_i, option.caseInsensitiveOption );
%         if isempty(Index2)==1       
%             % add selected players to tablePlayers_forTournament
%             % TABLE.tablePlayers_forTournament = [TABLE.tablePlayers_forTournament; selected_data];
%             output = concatenateTable(TABLE.tablePlayers_forTournament, selected_data);
%             TABLE.tablePlayers_forTournament = output;           
%         else
%             bool_msg = true;            
%         end
%     end

    if bool_msg
        msg = 'Selected Player(s) are already in the tournament';
        handles_i = handles.TXT_error;
        prefix = '';
        displayErrorMsg( msg, handles_i, prefix )
    end
    % display the data
    refreshTables(hObject, eventdata, handles) 
else
    % If no player in the DB, it is an error
    msg = 'There is no player in the DB !!';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end
    
    
% --- Executes on button press in BUT_removePlayer.
function BUT_removePlayer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_removePlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE

UITable = 'TAB_players_Tournament';
[ data, rows ] = getCellSelect( UITable );
rows = unique(rows);

if isempty(data)~=1
    % display the data
    TABLE.tablePlayers_forTournament (rows,:) = [];
    refreshTables(hObject, eventdata, handles)
else
    % If no player in the tournament list, it is an error
    msg = 'There is no player in the tournament';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end


% --- Executes on button press in BUT_uniqueWSCode.
function BUT_uniqueWSCode_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_uniqueWSCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE
[a,b,c] = unique(TABLE.tablePlayers_forTournament.WSCode);
TABLE.tablePlayers_forTournament = TABLE.tablePlayers_forTournament(b,:);
refreshTables(hObject, eventdata, handles)


function EDIT_tournamentName_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_tournamentName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_tournamentName as text
%        str2double(get(hObject,'String')) returns contents of EDIT_tournamentName as a double


% --- Executes during object creation, after setting all properties.
function EDIT_tournamentName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_tournamentName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_beginTournament.
function BUT_beginTournament_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_beginTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global timer
% stop(timer.b)
MENU_beginTournament_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function MENU_File_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_Player_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_Player (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_Tournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_Tournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_newPlayer_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_newPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% futureFunctionalityMsg(handles)

global TABLE MATRICE option
addNewPlayer(TABLE, MATRICE, option)
defaultDB_name = option.default_DBLocal;
BUT_refreshLocalDB_Callback(hObject, eventdata, handles, defaultDB_name);

% --------------------------------------------------------------------
function MENU_editPlayerInfo_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_editPlayerInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% futureFunctionalityMsg(handles)
global TABLE MATRICE option
contents = cellstr(get(handles.POP_selectDB,'String'));
name_DB = contents{get(handles.POP_selectDB,'Value')};

if strcmp(name_DB, option.default_DBLocal) == 1
    idTable = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), option.default_DBLocal);
    data = TABLE.MEGA_tablePlayers_fromDB{idTable,2};
    UITable = 'TAB_players';
    [ ~, idx ] = getCellSelect( UITable );
    if isempty(idx) == 0
        data = data(idx,:);
        editExistingPlayer(TABLE, MATRICE, option, data, idx);
        defaultDB_name = option.default_DBLocal;
        BUT_refreshLocalDB_Callback(hObject, eventdata, handles, defaultDB_name)
    else
        msg = 'Please select a player';
        handles_i = handles.TXT_error;
        prefix = '- ';
        displayErrorMsg( msg, handles_i, prefix )  
    end
else
    msg = ['Error. A player can only be edited if it belongs to the local database: ' option.default_DBLocal];
    handles_i = handles.TXT_error;
    prefix = '- ';
    displayErrorMsg( msg, handles_i, prefix )  
end


% --------------------------------------------------------------------
function MENU_managePlayersLocalDB_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_managePlayersLocalDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
manageLocalPlayerGUI();



% --------------------------------------------------------------------
function MENU_loadFromDB_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_loadFromDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)

% --------------------------------------------------------------------
function MENU_versionInfo_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_versionInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
versionInfoGUI();



% --------------------------------------------------------------------
function MENU_openTournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_openTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% futureFunctionalityMsg(handles)

[filename, pathname] = uigetfile('*.mat','Select the tournament configuration', 'tournamentSave\');
if isequal(filename,0) || isequal(pathname,0)
   disp('User selected Cancel')
else
   disp(['User selected ',fullfile(pathname,filename)])
   load(fullfile(pathname,filename))
   close
   beginTournament
end



% --------------------------------------------------------------------
function MENU_openLastSaveTournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_openLastSaveTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option

load(option.fileNameSaveState)
close
beginTournament


% --------------------------------------------------------------------
function MENU_createNewTournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_createNewTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BUT_createTournament_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function MENU_editCurrentTournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_editCurrentTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

disp('Edit Tournament Info')
if option.tmp.bool_createTournament
    disp('- Accorded')
    tournamentInfoGUI
else
    msg = 'Before editing a tournament, you have a create one first !';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end


% --------------------------------------------------------------------
function MENU_printPlayerList_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_printPlayerList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% futureFunctionalityMsg(handles)
global option TABLE
disp('Printing Player list')

h = waitbar(0.50,'Export the pairing in .XLS and .PDF. Please wait ...');

disp('--------------------------------------------------------------------')
disp('Export the pairing in .XLS and .PDF')

path        = pwd;
filenamehtml= [path '/export/List_Players' '.html'];
filename    = [path '/export/List_Players' '.xls'];
filename2   = [path '/export/List_Players' '.pdf'];
T           = TABLE.tablePlayers_forTournament;
column      = TABLE.tablePlayers_forTournament.Properties.VariableNames;
title       = ['List of players'];


disp('- Quit the Application')
quitApplication ();

disp('- Delete files if they exist')
if exist(filename, 'file') == 2
    delete(filename)
end

if exist(filename2, 'file') == 2
    delete(filename2)
end

try
    % Export to XLS
    disp('- Export the Tables in .xls')
    exportTable2CSV( T, filename, column, option, title);

    % Export to PDF
    disp('- Export the Tables in .pdf')
    export_XLS2PDF(filename, filename2, option);
       
catch
    % Export in HTML
    disp('- Export the Tables in .html')
    exportTable2html( T, filenamehtml, column, option, title);
    
    % Open in Internet explorer
    % url = 'http://www.ws-france.fr';
    web(filenamehtml,'-browser')
    
end

% turnOnGUI( handlesFigure, InterfaceObj, oldpointer, option );
close(h)



% --------------------------------------------------------------------
function MENU_beginTournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_beginTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE

% For a valid tournament, there must be at least 2 players
if size(TABLE.tablePlayers_forTournament,1)>1
    % Construct a questdlg with three options
    choice = questdlg('Would you like to shuffle the player seed?', ...
        'Shuffle Player Seed?', ...
        'Yes','No', 'No');
    % Handle response
    switch choice
        case 'Yes'
            disp([choice ' coming right up. Shuffling player seed'])           
            ordering = randperm(size(TABLE.tablePlayers_forTournament,1));
            TABLE.tablePlayers_forTournament = TABLE.tablePlayers_forTournament(ordering, :);        
        case {'No',''}
            disp([choice ' coming right up.'])
        otherwise
            error('option not known')
    end
    close
    beginTournament
    % parpool(2)
    % j = batch('beginTournament', 'Profile', 'local', 'pool', 1);
else
    msg = 'There is not enough players in the tournament. Add some players first (at least 2)';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
    % disp(msg)  
    % msgbox(msg, 'Error','error');
    % set(handles.TXT_error,'String',msg);
end






% --------------------------------------------------------------------
function MENU_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function MENU_help_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function MENU_contactUs_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_contactUs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% futureFunctionalityMsg(handles)
% email = 'caotri.do88@gmail.com';
% url = ['mailto:',email];
% web(url)

% Ask the user its information
[ ~, msg ] = contactUs(  );

handles_i = handles.TXT_error;
prefix = '';
displayErrorMsg( msg, handles_i, prefix )



% --------------------------------------------------------------------
function MENU_wsfrance_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_wsfrance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url = 'http://www.ws-france.fr';
web(url,'-browser')

% --------------------------------------------------------------------
function MENU_wsitalia_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_wsitalia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url = 'http://www.wseleague.com/';
web(url,'-browser')


function EDIT_searchPlayer_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_searchPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_searchPlayer as text
%        str2double(get(hObject,'String')) returns contents of EDIT_searchPlayer as a double

% global TABLE option
% disp(['Select subplayers containing: ' name])
% if isempty(name)~=1
%     % If not empty, select all player containing the string (case sensitive)
% %     data  = handles.TAB_players.Data;
%     data = TABLE.tablePlayers_fromDB(:,option.columnTableDB);
%     data = table2cell(data);
%     Index = strfind_idx( data, name, option.caseInsensitiveOption );
%     Index = unique(Index);
%     set(handles.TAB_players, 'data', data(Index,:), 'ColumnName', option.columnTableDB)
% else
%     % If it is empty, show all players
%     disp('Text edit box is empty. Show all players')
%     data = table2cell(TABLE.tablePlayers_fromDB(:,option.columnTableDB));
%     set(handles.TAB_players, 'data', data, 'ColumnName', option.columnTableDB)
% end

global TABLE

% String in the EDIT_searchPlayer box
name = handles.EDIT_searchPlayer.String;
% name = TABLE.tablePlayers_fromDB;
handlesTAB = handles.TAB_players; 
tablePlayer = TABLE.tablePlayers_fromDB;
selectName(name, handlesTAB, tablePlayer);


function selectName(name, handlesTAB, tablePlayer)
global option
disp(['Select subplayers containing: ' name])
if isempty(name)~=1
    % If not empty, select all player containing the string (case sensitive)
%     data  = handles.TAB_players.Data;
    data = tablePlayer(:,option.columnTableDB);
    data = table2cell(data);
    Index = strfind_idx( data, name, option.caseInsensitiveOption );
    Index = unique(Index);
    set(handlesTAB, 'data', data(Index,:), 'ColumnName', option.columnTableDB)
    warning('selectName : VIZU TO BE PUT IN refreshTABLE')
else
    % If it is empty, show all players
    disp('Text edit box is empty. Show all players')
    data = table2cell(tablePlayer(:,option.columnTableDB));
    set(handlesTAB, 'data', data, 'ColumnName', option.columnTableDB)
    warning('selectName : VIZU TO BE PUT IN refreshTABLE')
end


% --- Executes during object creation, after setting all properties.
function EDIT_searchPlayer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_searchPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EDIT_searchPlayerTournament_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_searchPlayerTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_searchPlayerTournament as text
%        str2double(get(hObject,'String')) returns contents of EDIT_searchPlayerTournament as a double

global TABLE

% String in the EDIT_searchPlayer box
name = handles.EDIT_searchPlayerTournament.String;
% name = TABLE.tablePlayers_fromDB;
handlesTAB = handles.TAB_players_Tournament; 
tablePlayer = TABLE.tablePlayers_forTournament;
selectName(name, handlesTAB, tablePlayer);



% --- Executes during object creation, after setting all properties.
function EDIT_searchPlayerTournament_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_searchPlayerTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function MENU_saveDB_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_saveDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)

% --------------------------------------------------------------------
function MENU_configSQLServer_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_configSQLServer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)


% --------------------------------------------------------------------
function MENU_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
preferencesGUI

% --------------------------------------------------------------------
function MENU_manageDB_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_manageDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
manageDBGUI();

% --------------------------------------------------------------------
function MENU_retrieveSpecificDB_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_retrieveSpecificDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERSONNAL FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function displayLogo(hObject, eventdata, handles) 

global option

axes(handles.PLOT_logo)
matlabImage = imread(option.imageLogo);
% matlabImage = imread('ws_logo.png');
matlabImage = imresize(matlabImage, 1.5);
image(matlabImage)
% axes('position',[0.57,0.15,0.25,0.25]);
axis off
% axis image






% --- Executes on key press with focus on EDIT_searchPlayer and none of its controls.
function EDIT_searchPlayer_KeyPressFcn(hObject,eventdata,handles)
% hObject    handle to EDIT_searchPlayer (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% global option
% 
% eventdata.Character
% 
% if strcmp(eventdata.Key,'backspace')
%     disp('case 1: Delete character')
%     option.searchPlayer = option.searchPlayer(1:end-1);
%     bool = true;
% elseif isempty(eventdata.Character)
%     disp('case 2: other control (CTRL, ALT, etc.)')
%     bool = false;
%     % return
% else
%     disp('case 3: Add characters')
%     option.searchPlayer = [option.searchPlayer eventdata.Character];
%     bool = true;
% end
% 
% if bool
%     selectName(option.searchPlayer, handles)
% end





% --- Executes on button press in BUT_createTournament.
function BUT_createTournament_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_createTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

if option.tmp.createTournamentBool
    option.tmp.createTournamentBool = true;
    % Construct a questdlg with three options
    choice = questdlg('Create a new Tournament will delete all players from the current tournament?', ...
        'Warning',...
        'Continue', ...
        'Cancel', 'Cancel');
    % Handle response
    switch choice
        case 'Continue'
            disp([choice ' coming right up.'])
            option.tournamentInfo = [];
            tournamentInfoGUI
        case {'Cancel',''}
            disp([choice ': choice cancelled'])
        otherwise
            error([choice ': Case not known.'])
    end
else
    option.tmp.createTournamentBool = true;
    option.tournamentInfo = [];
    tournamentInfoGUI   
end




% mode = 'on';
% showHandlesTournament(handles, mode);




% --------------------------------------------------------------------
function MENU_update_dbCSV_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_update_dbCSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Updating the Database of player from the server')

url = 'http://www.wseleague.com/download/fileforsw.csv'; % 'http://heritage.stsci.edu/2007/14/images/p0714aa.jpg';
disp(['- START: Retrieve the file from the server: ' url])
filename = 'fileforsw.csv';
outfilename = websave(filename,url);
disp(['- END: Retrieve the file from the server done: ' url])

disp('- START: Move the file to the subfolder import/')
movefile(outfilename, '../data/playerDB/fileforsw.csv','f')
disp('- END: Move the file to the subfolder import/ done')

disp('- Generate Tables from local DB: tablePlayers_fromDB and tablePlayers_forTournament')
loadDefaultPlayer(hObject, eventdata, handles)


% --- Executes on button press in BUT_addPlayerBarcode.
function BUT_addPlayerBarcode_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_addPlayerBarcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Please download and build the core and javase parts of zxing
% from here - http://code.google.com/p/zxing/

% futureFunctionalityMsg(handles)
barcodeScannerGUI



% --- Executes during object creation, after setting all properties.
function POP_sortBy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_sortBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');  
    
end

% --- Executes during object creation, after setting all properties.
function POP_sortByTournament_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_sortByTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function POP_sortOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_sortOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function POP_sortOrderTournament_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_sortOrderTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in POP_sortOrder.
function POP_sortOrder_Callback(hObject, eventdata, handles)
% hObject    handle to POP_sortOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_sortOrder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_sortOrder

global option
contents            = cellstr(get(hObject,'String'));
tmp                 = contents{get(hObject,'Value')};
option.sortOrderDB  = assignAscendingDescending(tmp);
type                = 'DB';
refreshTables(hObject, eventdata, handles, type)


function sortOrder = assignAscendingDescending(tmp)
switch tmp
    case 'A - z'
        sortOrder = 'ascend';
    case 'Z - a'
        sortOrder = 'descend';
    otherwise
        disp('Case not known')
end

% --- Executes on selection change in POP_sortOrderTournament.
function POP_sortOrderTournament_Callback(hObject, eventdata, handles)
% hObject    handle to POP_sortOrderTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_sortOrderTournament contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_sortOrderTournament

global option
contents            = cellstr(get(hObject,'String'));
tmp                 = contents{get(hObject,'Value')};
option.sortOrderTournament  = assignAscendingDescending(tmp);
type                = 'tournament';
refreshTables(hObject, eventdata, handles, type)




% --- Executes on selection change in POP_sortBy.
function POP_sortBy_Callback(hObject, eventdata, handles)
% hObject    handle to POP_sortBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_sortBy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_sortBy

handleTable = handles.TAB_players;
handleSortBy = handles.POP_sortBy;
type = 'DB';

sortBy(handleTable, handleSortBy, handles, type);


% --- Executes on selection change in POP_sortByTournament.
function POP_sortByTournament_Callback(hObject, eventdata, handles)
% hObject    handle to POP_sortByTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_sortByTournament contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_sortByTournament

handleTable = handles.TAB_players_Tournament ;
handleSortBy = handles.POP_sortByTournament;
type = 'tournament';
sortBy(handleTable, handleSortBy, handles, type);



function data = sortBy(handleTable, handleSortBy, handles, type)

global option
% get selection of handles.POP_sortBy menu or handles.POP_sortByTournament
contents = get(handleSortBy,'String'); 
value    = contents{get(handleSortBy,'Value')};
switch type
    case 'DB'              
        option.column2sortDB = value;
    case 'tournament'
        option.column2sortTournament = value;
    otherwise
        disp('case not known')
end

data = handleTable.Data;
refreshTables(handleTable, handleSortBy, handles, type);




    




% if isfield(option,'column2sortDB') == 0
%     bool = true;
% elseif strcmp(option.column2sortDB,'Sort By') == 0
%     bool = true;
% else
%     bool = false;
% end
% 
% if bool
%     data2 = sortrows(TABLE.tablePlayers_fromDB(:,option.columnTableDB), option.column2sortDB, option.sortOrderDB);
% else
%     disp('This is SORT BY')
%     data2 = TABLE.tablePlayers_fromDB(:,option.columnTableDB);
% end
% data2 = table2cell(data2);
% set(handles.TAB_players, 'data', data2, 'ColumnName', option.columnTableDB)





% --- Executes on selection change in POP_selectDB.
function POP_selectDB_Callback(hObject, eventdata, handles)
% hObject    handle to POP_selectDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_selectDB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_selectDB

global TABLE option

contents = cellstr(get(hObject,'String'));
db_tmp_Name = contents{get(hObject,'Value')};

index = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), db_tmp_Name, option.caseInsensitiveOption);
TABLE.tablePlayers_fromDB = TABLE.MEGA_tablePlayers_fromDB{index,2};
refreshTables(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function POP_selectDB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_selectDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in BUT_saveAsLocalDB.
function BUT_saveAsLocalDB_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_saveAsLocalDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

if isempty(TABLE.tablePlayers_forTournament) == 1
    msg = 'Error : Put players in the tournament list first !!';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
    % disp(msg)
    % msgbox(msg,'Error', 'error')
    % set(handles.TXT_error,'String',msg);
else
    
    prompt = {'Enter name to save the Database'};
    dlg_title = 'Name of the database';
    date = option.tournamentInfo.dateSerial;
    formatOut = 'yyyymmdd';
    DateString = datestr(date,formatOut);
    defaultans = {[DateString '_' option.tournamentInfo.name]};
    filename = inputdlg(prompt,dlg_title,[1 50],defaultans);

    filename = strrep(filename,' ','');
    filename = strrep(filename,'/','');

    if isempty(filename) ==0
        try
            writetable(TABLE.tablePlayers_forTournament,['../data/playerDB/' filename{1} '.csv'],'Delimiter',';')
            BUT_refreshLocalDB_Callback(hObject, eventdata, handles)
        catch
            msg = 'This is not a valid name. Do it again !!!';
            handles_i = handles.TXT_error;
            prefix = '';
            displayErrorMsg( msg, handles_i, prefix )
            % disp(msg)
            % msgbox(msg,'Error','error')
            % set(handles.TXT_error,'String',msg);
        end
    end
end
    
% --------------------------------------------------------------------
function MENU_update_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

futureFunctionalityMsg(handles)
% See in the future \externalLibs\update_check from FileExchange
% We can for example check a version of a server of WS Italia
% Then, dl the program and then call the function

% --- Executes on button press in BUT_refreshLocalDB.
function BUT_refreshLocalDB_Callback(hObject, eventdata, handles, defaultDB_name)
% hObject    handle to BUT_refreshLocalDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

if nargin < 4
    defaultDB_name = option.default_DBOnline;
end
BUT_refreshLocalDB(hObject, eventdata, handles, defaultDB_name)
% 
% disp('-- Refreshing the local Databases')
% files = listDBPlayers( );
% 
% disp(['-- ' num2str(size(files,1)) ' file(s) were found locally: '])
% disp(files)
% files = ['Select Database'; files];
% set(handles.POP_selectDB,'String',files)
% 
% loadDefaultPlayer(hObject, eventdata, handles, defaultDB_name)


% --------------------------------------------------------------------
function MENU_mapOfPlayers_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_mapOfPlayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('--------------------------------------------------------------------')
disp('Doing some statistics')

global TABLE option


if option.tmp.bool_createTournament
    disp('- Accorded')
    % Retrieve localizations
    path = pwd;
    DB_Town_filename = [path '/import/Localization.xls'];
    [~,~,data] = xlsread(DB_Town_filename);
    column_tmp = data(1,:);
    TABLE.LocalizationReference = array2table(data(2:end,:), 'VariableNames', column_tmp);
    
    % Define the database. Ask the user
    % Construct a questdlg with three options
    choice = questdlg('Do the map on which database?', ...
        'Question?', ...
        'Player Database', ...
        'Database of the tournament','Player Database');
    % Handle response
    switch choice
        case 'Player Database'
            disp([choice ' coming right up.'])
            subtable = TABLE.tablePlayers_fromDB;
        case 'Database of the tournament'
            disp([choice ' coming right up.'])
            subtable = TABLE.tablePlayers_forTournament;
        otherwise
            disp('Case not known')
    end
else
    msg = 'Before editing a tournament, you have a create one first !';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end


% Look for the data in the reference
% bool_country = ismember(TABLE.LocalizationReference.country, TABLE.tablePlayers_fromDB.country);
bool_country = ismember(TABLE.LocalizationReference.country, subtable.country);

list_coordinate = TABLE.LocalizationReference(bool_country,:);
lat = cell2mat(list_coordinate.latitude);
lon = cell2mat(list_coordinate.longitude);
country_list = TABLE.LocalizationReference.country(bool_country,:);


bool_internetConnection = haveInet();

if bool_internetConnection
    disp('- Internet connection was detected. Starting to do statistics ...')
    disp('- Plot the database of players by countries')
    % Plot the data
    figure(1)
    clf
    % Determine the size of each symbol
    nb_country = length(lon);
    MAT_nbplayersCountry = zeros(length(nb_country),1) + inf;
    for i =1:length(lon)
        country_i = country_list{i};
        % id = find(strcmp(TABLE.tablePlayers_fromDB.country, country_i)==1);
        id = find(strcmp(subtable.country, country_i)==1);
        MAT_nbplayersCountry(i) = length(id);
    end
    mini = min(MAT_nbplayersCountry);
    maxi = max(MAT_nbplayersCountry);
    mini_size = 0;
    maxi_size = 60;
    for i = 1:length(lon)
        hold on
        country_i = country_list{i};
        % id = find(strcmp(TABLE.tablePlayers_fromDB.country, country_i)==1);
        id = find(strcmp(subtable.country, country_i)==1);
        plot(lon(i),lat(i),'.r','MarkerSize',length(id)*maxi_size/100)
    end
    disp('- Retrieve map from Google database')
    plot_google_map
    xlabel('longitude')
    ylabel('latitude')
    title('Country origin of the players')

    % Convert to categorical
    disp('- Make a summary of the data in the database')
    try
        % tmp         = TABLE.tablePlayers_fromDB;
        % tmp.country = categorical(TABLE.tablePlayers_fromDB.country);
        % tmp.town    = categorical(TABLE.tablePlayers_fromDB.town);
        % tmp.serie   = categorical(TABLE.tablePlayers_fromDB.serie);
        tmp         = subtable;
        tmp.country = categorical(tmp.country);
        tmp.town    = categorical(tmp.town);
        tmp.serie   = categorical(tmp.serie);
        summary(tmp)
    catch
        warning ('-- There is some errors in the loading. Has to be checked in the future versions.')
    end
else
    msg = 'No internet connection detected. Check it !!';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end
    
    
% statarray = grpstats(TABLE.tablePlayers_fromDB,'age')

% --------------------------------------------------------------------
function MENU_quit_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BushiSoftGUI_CloseRequestFcn(hObject, eventdata, handles)


% --- Executes when user attempts to close BushiSoftGUI.
function BushiSoftGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to BushiSoftGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% global timer
answer = dlboxQuit( );

if answer
    disp('Going to close the application')
    try
        % stop(timer.b)
    catch
        warning('could not stop the timer timer.b')
    end
    delete(hObject);
    % close
else
    disp('Application is not closed')
end


% --------------------------------------------------------------------
function MENU_license_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_license (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = '../../LICENSE.txt';
winopen(filename)


% --------------------------------------------------------------------
function MENU_onlineHelp_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_onlineHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url = 'http://www.ws-france.fr';
web(url,'-browser')


% --- Executes on button press in BUT_editPlayerAdditionnalInformation.
function BUT_editPlayerAdditionnalInformation_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_editPlayerAdditionnalInformation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

UITable = 'TAB_players_Tournament';
[ data, rows] = getCellSelect( UITable );

% If the selection is not empty, transfer player from
% TABLE.tablePlayers_fromDB to TABLE.tablePlayers_forTournament
if isempty(data)~=1
    list_data = data(rows,1);
    % Loop if multiple players are selected
    for i = 1:length(rows)
        % Rely on WSCode that is unique for players
        WSCode_i = list_data{i,1};
        Index = strfind_idx( TABLE.tablePlayers_forTournament.WSCode, WSCode_i, option.caseInsensitiveOption );
        
        % Look at existing answer
        existing_answer = TABLE.tablePlayers_forTournament(:,option.additionnalTournamentVariable);
        existing_answer = table2cell(existing_answer)';
        
        namePlayer = [TABLE.tablePlayers_forTournament.name{Index} ', '  TABLE.tablePlayers_forTournament.familyName{Index}] ;
        answer = askAdditionnalInfo(option, existing_answer, namePlayer);
        if isempty(answer)==0
            variableAll =  TABLE.tablePlayers_forTournament.Properties.VariableNames;
            for j = 1:size(option.additionnalTournamentVariable,2)
                variable_j = option.additionnalTournamentVariable{j};
                idx = strfind_idx(variableAll', variable_j);
                TABLE.tablePlayers_forTournament{Index,idx} = {answer{j}};
            end
            refreshTables(hObject, eventdata, handles)         
        else
            disp('- Edit was cancelled')
        end
    end
else
    % If no player in the DB, it is an error
    msg = 'Selection in cancelled !!';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end


function answer = askAdditionnalInfo(option, existing_answer, namePlayer)

% Ask for the new player
prompt      = option.additionnalTournamentVariable;
dlg_title   = ['Additionnal information: ' namePlayer];
N           = 30;
num_lines   = 1;
defaultans  = existing_answer; % option.additionnalTournamentVariable;
answer      = inputdlg(prompt,dlg_title, [num_lines, length(dlg_title)+N], defaultans);


% --------------------------------------------------------------------
function MENU_addNewPlayerOnlineDB_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_addNewPlayerOnlineDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url = 'http://www.wseleague.com/register.php';
web(url,'-browser')


% --------------------------------------------------------------------
function MENU_statiticsWindow_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_statiticsWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

if option.tmp.bool_createTournament
    disp('- Accorded')
    statisticsGUI
else
    msg = 'Before editing a tournament, you have a create one first !';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end



