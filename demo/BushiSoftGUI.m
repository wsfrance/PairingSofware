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

% Last Modified by GUIDE v2.5 05-Dec-2016 17:30:49

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

global TABLE option 

% User Define
column                  = {'name', 'familyName', 'pseudo'};
option.columnTableDB    = ['WSCode', column];
option.verbose          = 1;
option.boolean_Round    = 1;
option.winningPoint     = 1;
option.losePoint        = 0;
option.tiePoint         = 0.5;
option.no_maxRound      = 3;
option.no_round         = 0;
option.columnTablePairing = {'Flt', 'Round', 'Table', 'Player1', 'Points_P1', 'Player2', 'Points_P2', 'Result'};


% Add path, subfunctions, etc.
disp('Add paths : subfunctions, externalLibs, etc.')
addPath_bushisoft( option.verbose );

% Set title
set(handles.figure1, 'Name', 'New Bushiroad Tournament Software (by malganis35)');

% Create Data
disp('Generate Tables: tablePlayers_fromDB and tablePlayers_forTournament')
[ TABLE.tablePlayers_fromDB, TABLE.tablePlayers_forTournament ] = generateTable();
TABLE.tablePlayers_forTournament(:,:) = [];

% Remove spaces at the begining and at the end
% tablePlayers_fromDB_tmp = table2cell(tablePlayers_fromDB);
% tablePlayers_fromDB_tmp = strtrim(tablePlayers_fromDB_tmp);
% tablePlayers_fromDB = tablePlayers_fromDB_tmp;

% Capital Letters
disp(['Set Capital Letters to selected columns : ' strjoin(column,', ')])
[ TABLE.tablePlayers_fromDB ] = Capital_FirstLetter( TABLE.tablePlayers_fromDB, column );

% Initialize functions to Tables
disp('Initialize functions (@cellSelect) to Tables')
set(handles.TAB_players, 'CellSelectionCallback',@cellSelect); 
% set(handles.TAB_players,'CellSelectionCallback',@MouseClickHandler); % for single and double click
set(handles.TAB_players_Tournament, 'CellSelectionCallback',@cellSelect);

% Logo
displayLogo(hObject, eventdata, handles) 



% --- Outputs from this function are returned to the command line.
function varargout = BushiSoftGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BUT_refresh.
function BUT_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

% Select Data to vizualize
data = table2cell(TABLE.tablePlayers_fromDB(:,option.columnTableDB));
set(handles.TAB_players, 'data', data, 'ColumnName', option.columnTableDB)
% List of sortBy possibilities and display it into handles.POP_sortBy
sortBy_option = ['Sort By'; option.columnTableDB'];
set(handles.POP_sortBy,'String', sortBy_option)  ;




% --- Executes on selection change in POP_sortBy.
function POP_sortBy_Callback(hObject, eventdata, handles)
% hObject    handle to POP_sortBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_sortBy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_sortBy

global option

data = handles.TAB_players.Data;

% get selection of handles.POP_sortBy menu
contents = get(handles.POP_sortBy,'String'); 
value    = contents{get(handles.POP_sortBy,'Value')};
Index    = strfind_idx( option.columnTableDB',value );

% Sort by rows if there is a valid selection (=0 is the Sort by option = not valid)
if Index>0
    data = sortrows(data,Index);
end
set(handles.TAB_players, 'data', data, 'ColumnName', option.columnTableDB)




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
        Index = strfind_idx( TABLE.tablePlayers_fromDB.WSCode, WSCode_i );
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
        Index = strfind_idx( TABLE.tablePlayers_forTournament.WSCode, WSCode_i );
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





function TXT_tournamentName_Callback(hObject, eventdata, handles)
% hObject    handle to TXT_tournamentName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXT_tournamentName as text
%        str2double(get(hObject,'String')) returns contents of TXT_tournamentName as a double


% --- Executes during object creation, after setting all properties.
function TXT_tournamentName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TXT_tournamentName (see GCBO)
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


global option TABLE

% String in the EDIT_searchPlayer box
name = handles.EDIT_searchPlayer.String;

disp(['Select subplayers containing: ' name])
if isempty(name)~=1
    % If not empty, select all player containing the string (case sensitive)
    data  = handles.TAB_players.Data;
    Index = strfind_idx( data, name );
    Index = unique(Index);
    set(handles.TAB_players, 'data', data(Index,:), 'ColumnName', option.columnTableDB)
else
    % If it is empty, show all players
    disp('Text edit box is empty. Show all players')
    data = table2cell(TABLE.tablePlayers_fromDB(:,option.columnTableDB));
    set(handles.TAB_players, 'data', data, 'ColumnName', option.columnTableDB)
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
disp('Display Logo on the Software')
axes(handles.PLOT_logo)
matlabImage = imread('bushiroadLogo.jpg');
% matlabImage = imread('ws_logo.png');
matlabImage = imresize(matlabImage, 1.5);
image(matlabImage)
% axes('position',[0.57,0.15,0.25,0.25]);
axis off
% axis image