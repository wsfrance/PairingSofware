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

disp('Add paths')
[ pathstr ] = addPath_bushisoft( );

global tablePlayers_fromDB tablePlayers_forTournament columnTable 
% User Define
column = {'name', 'familyName', 'pseudo'};
columnTable = ['WSCode', column];

% Set title
set(handles.figure1, 'Name', 'New Bushiroad Tournament Software (by malganis35)');

% Create Data
disp('Generate Tables: tablePlayers_fromDB and tablePlayers_forTournament')
[ tablePlayers_fromDB, tablePlayers_forTournament ] = generateTable();
tablePlayers_forTournament(:,:) = [];

% Remove spaces at the begining and at the end
% tablePlayers_fromDB_tmp = table2cell(tablePlayers_fromDB);
% tablePlayers_fromDB_tmp = strtrim(tablePlayers_fromDB_tmp);
% tablePlayers_fromDB = tablePlayers_fromDB_tmp;


% Capital Letters
disp(['Set Capital Letters to selected columns : ' strjoin(column,', ')])
[ tablePlayers_fromDB ] = Capital_FirstLetter( tablePlayers_fromDB, column );


% Initialize functions to Tables
disp('Initialize functions (@cellSelect) to Tables')
set(handles.TAB_players, 'CellSelectionCallback',@cellSelect); 
% set(handles.TAB_players,'CellSelectionCallback',@MouseClickHandler); % for single and double click
set(handles.TAB_players_Tournament, 'CellSelectionCallback',@cellSelect);


% Logo
disp('Display Logo on the Software')
axes(handles.PLOT_logo)
matlabImage = imread('bushiroadLogo.jpg');
% matlabImage = imread('ws_logo.png');
matlabImage = imresize(matlabImage, 1.5);
image(matlabImage)
% axes('position',[0.57,0.15,0.25,0.25]);
axis off
% axis image


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

global tablePlayers_fromDB columnTable

% Select Data to vizualize

data = table2cell(tablePlayers_fromDB(:,columnTable));
set(handles.TAB_players, 'data', data, 'ColumnName', columnTable)

sortBy_option = ['Sort By'; columnTable'];
set(handles.POP_sortBy,'String', sortBy_option)  ;




% --- Executes on selection change in POP_sortBy.
function POP_sortBy_Callback(hObject, eventdata, handles)
% hObject    handle to POP_sortBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_sortBy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_sortBy

global columnTable


data = handles.TAB_players.Data;

contents = get(handles.POP_sortBy,'String'); 
value = contents{get(handles.POP_sortBy,'Value')};
Index = strfind_idx( columnTable',value );

if Index>0
    data = sortrows(data,Index);
end

% switch value
%     case 'Sort By'
%         % do nothing
%     case 'WSCode'
%         data = sortrows(data,1);
%     case 'name'
%         data = sortrows(data,2);
%     case 'familyName'
%         data = sortrows(data,3);
%     otherwise
%         error('case value not known')
% end

% column2check = {'WSCode', 'name', 'familyName'};
set(handles.TAB_players, 'data', data, 'ColumnName', columnTable)




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

global tablePlayers_forTournament tablePlayers_fromDB columnTable

UITable = 'TAB_players';
[ data, rows] = getCellSelect( UITable );
if isempty(data)~=1
    list_data = data(rows,1);
    for i = 1:length(rows)
        WSCode_i = list_data(i,1);
        [ Index ] = strfind_idx( tablePlayers_fromDB.WSCode, WSCode_i );

        selected_data = tablePlayers_fromDB(Index,:);
        % % create mask containing rows to keep
        % mask = (1:size(data,1))';
        % mask(rows) = [];
        % % delete selected rows and re-write data
        % data = data(mask,:);

        tablePlayers_fromDB (Index,:) = [];

        tablePlayers_forTournament = [tablePlayers_forTournament; selected_data];

        data = table2cell(tablePlayers_fromDB(:,columnTable));
        set(handles.TAB_players, 'data', data, 'ColumnName', columnTable)
        data2 = table2cell(tablePlayers_forTournament(:,columnTable));
        set(handles.TAB_players_Tournament, 'data', data2, 'ColumnName', columnTable)
    end
else
    disp('There is no player in the DB')
end
    
    
% --- Executes on button press in BUT_removePlayer.
function BUT_removePlayer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_removePlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tablePlayers_forTournament tablePlayers_fromDB columnTable

UITable = 'TAB_players_Tournament';
[ data, rows ] = getCellSelect( UITable );
if isempty(data)~=1
    list_data = data(rows,1);
    for i = 1:length(rows)
        WSCode_i = list_data(i,1);
        [ Index ] = strfind_idx( tablePlayers_forTournament.WSCode, WSCode_i );

        selected_data = tablePlayers_forTournament(Index,:);
        % % create mask containing rows to keep
        % mask = (1:size(data,1))';
        % mask(rows) = [];
        % % delete selected rows and re-write data
        % data = data(mask,:);
        tablePlayers_forTournament (Index,:) = [];

        tablePlayers_fromDB = [tablePlayers_fromDB; selected_data];

        data = table2cell(tablePlayers_forTournament(:,columnTable));
        set(handles.TAB_players_Tournament, 'data', data, 'ColumnName', columnTable)
        data2 = table2cell(tablePlayers_fromDB(:,columnTable));
        set(handles.TAB_players, 'data', data2, 'ColumnName', columnTable)
    end
else
    disp('There is no player in the tournament')
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MENU EDITOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
global tablePlayers_fromDB tablePlayers_forTournament columnTable

if size(tablePlayers_forTournament,1)>1
    close
    beginTournament
else
    disp('Not enough players in the tournament')  
    msgbox('There is not enough players in the tournament. Add some players first (at least 2)', 'Error','error');
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
disp('Select subplayers')

global columnTable tablePlayers_fromDB

name = handles.EDIT_searchPlayer.String;
if isempty(name)~=1
    data = handles.TAB_players.Data;
    [ Index ] = strfind_idx( data, name );
    Index = unique(Index);
    set(handles.TAB_players, 'data', data(Index,:), 'ColumnName', columnTable)
else
    data = table2cell(tablePlayers_fromDB(:,columnTable));
    set(handles.TAB_players, 'data', data, 'ColumnName', columnTable)
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
