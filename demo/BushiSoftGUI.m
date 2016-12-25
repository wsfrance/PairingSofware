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

% Last Modified by GUIDE v2.5 16-Dec-2016 22:30:39

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
% uiwait(handles.figure1);

%--------------------------------------------------------------------------
% User Personal Code

% Clean up console
clc
disp('Cleaning up console')

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
option.no_maxRound      = 3;
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
option.caseInsensitiveOption = true;

% Visibility off for tournament
disp('- Visibility off for tournament elements of GUI')
mode = 'off';
showHandlesTournament(handles, mode);


% Add path, subfunctions, etc.
disp('- Add paths : subfunctions, externalLibs, etc.')
addPath_bushisoft( option.verbose );

% Set title
set(handles.figure1, 'Name', 'New Bushiroad Tournament Software (by malganis35)');

% Create Data
disp('- Generate Tables from local DB: tablePlayers_fromDB and tablePlayers_forTournament')
loadDefaultPlayer(hObject, eventdata, handles)

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




% --- Outputs from this function are returned to the command line.
function varargout = BushiSoftGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BUT_refreshDBPlayers.
function BUT_refreshDBPlayers_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_refreshDBPlayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Construct a questdlg with three options
choice = questdlg('Refresh the Database will delete all players from the tournament?', ...
	'Warning',...
    'Continue', ...
	'Cancel', 'Cancel');
% Handle response
switch choice
    case 'Continue'
        disp([choice ' coming right up.'])
        loadDefaultPlayer(hObject, eventdata, handles);
    case {'Cancel',''}
        disp([choice ': choice cancelled'])
    otherwise
        error([choice ': Case not known.'])
end






% --- Executes on selection change in POP_sortBy.
function POP_sortBy_Callback(hObject, eventdata, handles)
% hObject    handle to POP_sortBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_sortBy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_sortBy

% global option
% 
% data = handles.TAB_players.Data;
% 
% % get selection of handles.POP_sortBy menu
% contents = get(handles.POP_sortBy,'String'); 
% value    = contents{get(handles.POP_sortBy,'Value')};
% Index    = strfind_idx( option.columnTableDB',value );
% 
% % Sort by rows if there is a valid selection (=0 is the Sort by option = not valid)
% if Index>0
%     data = sortrows(data,Index);
% end
% set(handles.TAB_players, 'data', data, 'ColumnName', option.columnTableDB)

handleTable = handles.TAB_players;
handleSortBy = handles.POP_sortBy;
sortBy(handleTable, handleSortBy, handles);

function data = sortBy(handleTable, handleSortBy, handles)
global option

data = handleTable.Data;

% get selection of handles.POP_sortBy menu
contents = get(handleSortBy,'String'); 
value    = contents{get(handleSortBy,'Value')};
Index    = strfind_idx( option.columnTableDB',value,option.caseInsensitiveOption );

% Sort by rows if there is a valid selection (=0 is the Sort by option = not valid)
if Index>0
    data = sortrows(data,Index);
end
set(handleTable, 'data', data, 'ColumnName', option.columnTableDB)





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




% --- Executes on selection change in POP_sortByTournament.
function POP_sortByTournament_Callback(hObject, eventdata, handles)
% hObject    handle to POP_sortByTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_sortByTournament contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_sortByTournament

handleTable = handles.TAB_players_Tournament ;
handleSortBy = handles.POP_sortByTournament;
sortBy(handleTable, handleSortBy, handles);


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
    for i = 1:length(rows)
        % Rely on WSCode that is unique for players
        WSCode_i = list_data(i,1);
        Index = strfind_idx( TABLE.tablePlayers_fromDB.WSCode, WSCode_i, option.caseInsensitiveOption );
        selected_data = TABLE.tablePlayers_fromDB(Index,:);
        % delete selected players from tablePlayers_fromDB
        TABLE.tablePlayers_fromDB (Index,:) = []; 
        % add selected players to tablePlayers_forTournament
        TABLE.tablePlayers_forTournament = [TABLE.tablePlayers_forTournament; selected_data];
        
        % display the data
        data = table2cell(TABLE.tablePlayers_fromDB(:,option.columnTableDB));
        set(handles.TAB_players, 'data', data, 'ColumnName', option.columnTableDB)
        data2 = table2cell(TABLE.tablePlayers_forTournament(:,option.columnTableDB));
        set(handles.TAB_players_Tournament, 'data', data2, 'ColumnName', option.columnTableDB)
    end
else
    % If no player in the DB, it is an error
    msg = 'There is no player in the DB !!';
    disp(msg)
    msgbox(msg,'Error','error')
end
    
    
% --- Executes on button press in BUT_removePlayer.
function BUT_removePlayer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_removePlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

UITable = 'TAB_players_Tournament';
[ data, rows ] = getCellSelect( UITable );
if isempty(data)~=1
    list_data = data(rows,1);
    for i = 1:length(rows)
        WSCode_i = list_data(i,1);
        Index = strfind_idx( TABLE.tablePlayers_forTournament.WSCode, WSCode_i, option.caseInsensitiveOption );
        selected_data = TABLE.tablePlayers_forTournament(Index,:);
        % delete selected players
        TABLE.tablePlayers_forTournament (Index,:) = [];
        % add selected players
        TABLE.tablePlayers_fromDB = [TABLE.tablePlayers_fromDB; selected_data];
        
        % display the data
        data = table2cell(TABLE.tablePlayers_forTournament(:,option.columnTableDB));
        set(handles.TAB_players_Tournament, 'data', data, 'ColumnName', option.columnTableDB)
        data2 = table2cell(TABLE.tablePlayers_fromDB(:,option.columnTableDB));
        set(handles.TAB_players, 'data', data2, 'ColumnName', option.columnTableDB)
    end
else
    % If no player in the tournament list, it is an error
    msg = 'There is no player in the tournament';
    disp(msg)
    msgbox(msg,'Error','error')
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


% --------------------------------------------------------------------
function MENU_editPlayerInfo_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_editPlayerInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_loadFromDB_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_loadFromDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_versionInfo_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_versionInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_quit_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% --------------------------------------------------------------------
function MENU_openTournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_openTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_createNewTournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_createNewTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_printPlayerList_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_printPlayerList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
    disp(msg)  
    msgbox(msg, 'Error','error');
end






% --------------------------------------------------------------------
function MENU_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('doing some statistics')

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

% Plot the data
figure(1)
clf
for i = 1:length(lon)
    hold on
    country_i = country_list{i};
    id = find(strcmp(TABLE.tablePlayers_fromDB.country, country_i)==1);
    plot(lon(i),lat(i),'.r','MarkerSize',20*length(id))
end
plot_google_map
xlabel('longitude')
ylabel('latitude')
title('Country origin of the players')

% Convert to categorical
try
    tmp         = TABLE.tablePlayers_fromDB;
    tmp.country = categorical(TABLE.tablePlayers_fromDB.country);
    tmp.town    = categorical(TABLE.tablePlayers_fromDB.town);
    tmp.serie   = categorical(TABLE.tablePlayers_fromDB.serie);
    summary(tmp)
catch
    warning ('there is some error in the loading')
end

% statarray = grpstats(TABLE.tablePlayers_fromDB,'age')

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
email = 'caotri.do88@gmail.com';
url = ['mailto:',email];
web(url)


% --------------------------------------------------------------------
function MENU_wsfrance_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_wsfrance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url = 'http://www.ws-france.fr';
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
else
    % If it is empty, show all players
    disp('Text edit box is empty. Show all players')
    data = table2cell(tablePlayer(:,option.columnTableDB));
    set(handlesTAB, 'data', data, 'ColumnName', option.columnTableDB)
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


% --------------------------------------------------------------------
function MENU_configSQLServer_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_configSQLServer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_postFacebook_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_postFacebook (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

thingSpeakURL = 'https://www.facebook.com/dialog/feed?';
thingSpeakWriteURL = thingSpeakURL;
writeApiKey = '145634995501895';
fieldName = 'field1';
fieldValue = 42;
response = webwrite(thingSpeakWriteURL,'api_key',writeApiKey,fieldName,fieldValue)



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

path = pwd;

% From excel file
% default_DB_filename = [path '/import/Database_Players.xls'];
% [~,~,data] = xlsread(default_DB_filename);

% from CSV
default_DB_filename = [path '/import/fileforsw.csv'];
data = csvimport(default_DB_filename,'delimiter',';');

% option.columnTableDB = data(1,:);
column_tmp = data(1,:);
TABLE.tablePlayers_fromDB = array2table(data(2:end,:), 'VariableNames', column_tmp);

TABLE.tablePlayers_forTournament = TABLE.tablePlayers_fromDB(1,:);
TABLE.tablePlayers_forTournament(:,:) = [];

% Delete ""
disp('- Delete false characters (like ", etc.)')
TABLE.tablePlayers_fromDB.name = strrep(TABLE.tablePlayers_fromDB.name,'"','');
TABLE.tablePlayers_fromDB.familyName = strrep(TABLE.tablePlayers_fromDB.familyName,'"','');
TABLE.tablePlayers_fromDB.pseudo = strrep(TABLE.tablePlayers_fromDB.pseudo,'"','');

% Capital Letters
disp(['- Set Capital Letters to selected columns : ' strjoin(option.columnCapitalLetters,', ')])
[ TABLE.tablePlayers_fromDB ] = Capital_FirstLetter( TABLE.tablePlayers_fromDB, option.columnCapitalLetters );

% Select Data to vizualize
data = table2cell(TABLE.tablePlayers_fromDB(:,option.columnTableDB));
set(handles.TAB_players, 'data', data, 'ColumnName', option.columnTableDB)
data = table2cell(TABLE.tablePlayers_forTournament(:,option.columnTableDB));
set(handles.TAB_players_Tournament, 'data', data, 'ColumnName', option.columnTableDB)

% List of sortBy possibilities and display it into handles.POP_sortBy
sortBy_option = ['Sort By'; option.columnTableDB'];
set(handles.POP_sortBy,'String', sortBy_option)  ;


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

mode = 'on';
showHandlesTournament(handles, mode);

function showHandlesTournament(handles, mode)
set(handles.BUT_addPlayer, 'Visible', mode)
set(handles.BUT_removePlayer, 'Visible', mode)
set(handles.TEXT_playerForTournament, 'Visible', mode)
set(handles.TAB_players_Tournament, 'Visible', mode)
set(handles.POP_sortByTournament, 'Visible', mode)
set(handles.TEXT_search, 'Visible', mode)
set(handles.EDIT_searchPlayerTournament, 'Visible', mode)
set(handles.BUT_beginTournament, 'Visible', mode)
set(handles.TEXT_tournamentName, 'Visible', mode)
set(handles.EDIT_tournamentName, 'Visible', mode)
set(handles.TEXT_tournamentInformation, 'Visible', mode)


% --------------------------------------------------------------------
function update_dbCSV_Callback(hObject, eventdata, handles)
% hObject    handle to update_dbCSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Updating the Database of player from the server')

url = 'http://www.wseleague.com/download/fileforsw.csv'; % 'http://heritage.stsci.edu/2007/14/images/p0714aa.jpg';
disp(['- START: Retrieve the file from the server: ' url])
filename = 'fileforsw.csv';
outfilename = websave(filename,url);
disp(['- END: Retrieve the file from the server done: ' url])

disp('- START: Move the file to the subfolder import/')
movefile(outfilename, 'import/fileforsw.csv','f')
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
barcodeScannerGUI
