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

% Last Modified by GUIDE v2.5 02-Feb-2017 21:11:25

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
disp('Bushiroad Pairing Software')
disp('Author: malganis35')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

disp('Opening of the software')

disp('- Change automatically the directory')
currentpath = fileparts(mfilename('fullpath'));
cd(currentpath)

global TABLE option

% User Define
column                  = {'name', 'familyName', 'pseudo'};
option.columnTableDB    = ['WSCode', column];
option.verbose          = 1;
option.boolean_Round    = 1;
option.winningPoint     = 3;
option.losePoint        = 0;
option.tiePoint         = 0.5;
option.no_maxRound      = 6;
option.no_round         = 0;
option.columnTablePairing = {'Flt', 'Round', 'Table', 'Player1', 'Points_P1', 'Player2', 'Points_P2', 'Result'};
option.bool_Tournamentstarted = 0;
% option.column2ranking = {'Points', 'Modified_Median', 'Cumulative_Score', 'Solkoff'};
% option.column2ranking = {'Points', 'Opp_MW'};
% option.column2sort = {'Points', 'Modified_Median', 'Solkoff', 'Cumulative_Score', 'first_Loss'};
% option.sortType = {'descend', 'descend', 'descend', 'descend', 'descend'};
option.column2sort = {'Points', 'Opp_MW'};
option.sortType = {'descend', 'descend'};
option.swissRoundType = 'Monrad';
option.caseInsensitiveOption = true;
option.searchPlayer = [];
option.imageLogo = 'wsi_logo.jpg';
option.columnCapitalLetters = {'name', 'familyName', 'pseudo'};
option.turnOnOffGUI = true;
option.tmp.createTournamentBool = false;
option.sortOrderDB = 'ascend';
option.sortOrderTournament = 'ascend';
option.column2sortDB = 'Sort By';
option.column2sortTournament = 'Sort By';
option.tmp.bool_createTournament = false;

% Add path, subfunctions, etc.
disp('- Add paths : subfunctions, externalLibs, etc.')
addPath_bushisoft( option.verbose );

    
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
    set(handles.BushiSoftGUI, 'Name', 'New Bushiroad Tournament Software (by malganis35)');

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

% If the selection is not empty, transfer player from
% TABLE.tablePlayers_fromDB to TABLE.tablePlayers_forTournament
if isempty(data)~=1
    list_data = data(rows,1);
    % Loop if multiple players are selected
    bool_msg = false;
    for i = 1:length(rows)
        % Rely on WSCode that is unique for players
        WSCode_i = list_data{i,1};
        Index = strfind_idx( TABLE.tablePlayers_fromDB.WSCode, WSCode_i, option.caseInsensitiveOption );
        selected_data = TABLE.tablePlayers_fromDB(Index,:);
        % delete selected players from tablePlayers_fromDB
        % TABLE.tablePlayers_fromDB (Index,:) = []; 
        % check if player is already added
        Index2 = strfind_idx( TABLE.tablePlayers_forTournament.WSCode, WSCode_i, option.caseInsensitiveOption );
        if isempty(Index2)==1       
            % add selected players to tablePlayers_forTournament
            TABLE.tablePlayers_forTournament = [TABLE.tablePlayers_forTournament; selected_data];

            % display the data
            refreshTables(hObject, eventdata, handles)
            refreshTables(hObject, eventdata, handles)
            
        else
            bool_msg = true;
            % msg = 'Player is already in the tournament';
            % handles_i = handles.TXT_error;
            % prefix = '';
            % displayErrorMsg( msg, handles_i, prefix )            
            % disp(msg)
            % set(handles.TXT_error,'String',msg);
            
        end
    end
    if bool_msg
%          msgbox(msg,'Error','error')
        msg = 'Selected Player(s) are already in the tournament';
        handles_i = handles.TXT_error;
        prefix = '';
        displayErrorMsg( msg, handles_i, prefix )
    end
else
    % If no player in the DB, it is an error
    msg = 'There is no player in the DB !!';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
    % disp(msg)
    % msgbox(msg,'Error','error')
    % set(handles.TXT_error,'String',msg);
end
    
    
% --- Executes on button press in BUT_removePlayer.
function BUT_removePlayer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_removePlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE

UITable = 'TAB_players_Tournament';
[ data, rows ] = getCellSelect( UITable );
if isempty(data)~=1
%     list_data = data(rows,1);
%     for i = 1:length(rows)
%         WSCode_i = list_data(i,1);
%         Index = strfind_idx( TABLE.tablePlayers_forTournament.WSCode, WSCode_i, option.caseInsensitiveOption );
%         selected_data = TABLE.tablePlayers_forTournament(Index,:);
%         % delete selected players
%         TABLE.tablePlayers_forTournament (Index,:) = [];
%         % add selected players
%         % TABLE.tablePlayers_fromDB = [TABLE.tablePlayers_fromDB; selected_data];        
%     end
    % display the data
    TABLE.tablePlayers_forTournament (rows,:) = [];
    refreshTables(hObject, eventdata, handles)
else
    % If no player in the tournament list, it is an error
    msg = 'There is no player in the tournament';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
    % disp(msg)
    % msgbox(msg,'Error','error')
    % set(handles.TXT_error,'String',msg);
end





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
futureFunctionalityMsg(handles)

% --------------------------------------------------------------------
function MENU_editPlayerInfo_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_editPlayerInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)

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
futureFunctionalityMsg(handles)

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

futureFunctionalityMsg(handles)

% disp('Printing Player list')

% global TABLE option


% handlesFigure = handles.BushiSoftGUI;
% [ InterfaceObj, oldpointer ] = turnOffGUI( handlesFigure, option );

% disp('- Quit the Application')
% quitApplication ();
% 
% % Export to XLS
% path = pwd;
% filename = [path '/export/PlayerList.xls'];
% filename2 = [path '/export/PlayerList.pdf'];
% T = TABLE.tablePlayers_forTournament;
% column = option.columnTableDB;
% 
% disp('- Delete files if they exist')
% delete(filename, filename2)
% 
% 
% exportTable2CSV( T, filename, column, option)
% 
% export_XLS2PDF(filename, filename2, option)

% turnOnGUI( handlesFigure, InterfaceObj, oldpointer, option );



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
function MENU_postFacebook_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_postFacebook (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

futureFunctionalityMsg(handles)
% url = 'http://www.mathworks.com';
% web(url,'-browser')
% 
% 
% thingSpeakURL = 'https://www.facebook.com/dialog/feed?';
% thingSpeakWriteURL = thingSpeakURL;
% writeApiKey = '1870359846540179';
% fieldName = 'field1';
% fieldValue = 42;
% response = webwrite(thingSpeakWriteURL,'api_key',writeApiKey,fieldName,fieldValue)
% 
% % test for matlab online
% thingSpeakURL = 'http://api.thingspeak.com/';
% thingSpeakWriteURL = [thingSpeakURL 'update'];
% writeApiKey = '19M8YL1FP1ADB3Q4'; % 'Your Write API Key';
% data = 42;
% data = num2str(data);
% data = ['api_key=',writeApiKey,'&field1=',data];
% response = webwrite(thingSpeakWriteURL,data)



% --------------------------------------------------------------------
function MENU_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)

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

function loadDefaultPlayer(hObject, eventdata, handles)

global TABLE option

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
defaultDB_name = 'fileforsw.csv';
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


function importDB(hObject, eventdata, handles, default_path, files) 

global TABLE option

for i = 1:size(files,1)
    file_i = [default_path files{i}];
    data = csvimport(file_i,'delimiter',';');
    disp(['--- Importing: ' file_i])

    column_tmp = data(1,:);
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
    id = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), 'fileforsw.csv');
    TABLE.tablePlayers_forTournament = TABLE.MEGA_tablePlayers_fromDB{id,2}(1,:);
    TABLE.tablePlayers_forTournament(:,:) = [];
end

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

futureFunctionalityMsg(handles)
% barcodeScannerGUI



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
            column2display  = option.columnTableDB              ;
            sortOrder       = option.sortOrderTournament        ;
            displayOrderTable(option,column2sort, table_tmp, handle_display, column2display, sortOrder)

            % data = table2cell(TABLE.tablePlayers_forTournament(:,option.columnTableDB));
            % set(handles.TAB_players_Tournament, 'data', data, 'ColumnName', option.columnTableDB)
        otherwise
            disp('case not known')
    end
end
    
function displayOrderTable(option, column2sort, table_tmp, handle_display, column2display, sortOrder)

if isfield(option,'column2sortDB') == 0
    bool = true;
elseif strcmp(column2sort,'Sort By') == 0
    bool = true;
else
    bool = false;
end

if bool
    data2 = sortrows(table_tmp(:,column2display), column2sort, sortOrder);
else
    disp('This is SORT BY')
    data2 = table_tmp(:,column2display);
end
data2 = table2cell(data2);
set(handle_display, 'data', data2, 'ColumnName', column2display)



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
function BUT_refreshLocalDB_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_refreshLocalDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('-- Refreshing the local Databases')
files = listDBPlayers( );

disp(['-- ' num2str(size(files,1)) ' file(s) were found locally: '])
disp(files)
files = ['Select Database'; files];
set(handles.POP_selectDB,'String',files)

loadDefaultPlayer(hObject, eventdata, handles)


% --------------------------------------------------------------------
function MENU_mapOfPlayers_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_mapOfPlayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('--------------------------------------------------------------------')
disp('Doing some statistics')

global TABLE
path = pwd;
DB_Town_filename = [path '/import/Localization.xls'];
[~,~,data] = xlsread(DB_Town_filename);
column_tmp = data(1,:);
TABLE.LocalizationReference = array2table(data(2:end,:), 'VariableNames', column_tmp);

% Look for the data in the reference
bool_country = ismember(TABLE.LocalizationReference.country, TABLE.tablePlayers_fromDB.country);

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
        id = find(strcmp(TABLE.tablePlayers_fromDB.country, country_i)==1);
        MAT_nbplayersCountry(i) = length(id);
    end
    mini = min(MAT_nbplayersCountry);
    maxi = max(MAT_nbplayersCountry);
    mini_size = 0;
    maxi_size = 60;
    for i = 1:length(lon)
        hold on
        country_i = country_list{i};
        id = find(strcmp(TABLE.tablePlayers_fromDB.country, country_i)==1);
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
        tmp         = TABLE.tablePlayers_fromDB;
        tmp.country = categorical(TABLE.tablePlayers_fromDB.country);
        tmp.town    = categorical(TABLE.tablePlayers_fromDB.town);
        tmp.serie   = categorical(TABLE.tablePlayers_fromDB.serie);
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

answer = dlboxQuit( );

if answer
    disp('Going to close the application')
    delete(hObject);
    close
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



