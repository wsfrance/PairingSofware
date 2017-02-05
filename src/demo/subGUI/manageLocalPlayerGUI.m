function varargout = manageLocalPlayerGUI(varargin)
% MANAGELOCALPLAYERGUI MATLAB code for manageLocalPlayerGUI.fig
%      MANAGELOCALPLAYERGUI, by itself, creates a new MANAGELOCALPLAYERGUI or raises the existing
%      singleton*.
%
%      H = MANAGELOCALPLAYERGUI returns the handle to a new MANAGELOCALPLAYERGUI or the handle to
%      the existing singleton*.
%
%      MANAGELOCALPLAYERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANAGELOCALPLAYERGUI.M with the given input arguments.
%
%      MANAGELOCALPLAYERGUI('Property','Value',...) creates a new MANAGELOCALPLAYERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manageLocalPlayerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manageLocalPlayerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manageLocalPlayerGUI

% Last Modified by GUIDE v2.5 05-Feb-2017 13:17:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manageLocalPlayerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @manageLocalPlayerGUI_OutputFcn, ...
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


% --- Executes just before manageLocalPlayerGUI is made visible.
function manageLocalPlayerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manageLocalPlayerGUI (see VARARGIN)

% Choose default command line output for manageLocalPlayerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manageLocalPlayerGUI wait for user response (see UIRESUME)
% uiwait(handles.manageLocalPlayerGUI);
updatelistLocalPlayer(hObject, eventdata, handles) 

% Set title
set(handles.manageLocalPlayerGUI, 'Name', 'Manage Local Databases (by malganis35)');



function updatelistLocalPlayer(hObject, eventdata, handles) 

global TABLE option
% Set list

idTable = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), option.default_DBLocal);
data = TABLE.MEGA_tablePlayers_fromDB{idTable,2};

firstnames  = table2cell(data(:,'name'));
lastnames   = table2cell(data(:,'familyName'));
wscode      = table2cell(data(:,'WSCode'));
names       = strcat(lastnames, {', '}, firstnames, {' ('}, wscode , ')');
% names       = sort(names); % Sort name by alphabetical order
set(handles.LIST_playerLocalDB, 'String', names)




% --- Outputs from this function are returned to the command line.
function varargout = manageLocalPlayerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in LIST_playerLocalDB.
function LIST_playerLocalDB_Callback(hObject, eventdata, handles)
% hObject    handle to LIST_playerLocalDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LIST_playerLocalDB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LIST_playerLocalDB


% --- Executes during object creation, after setting all properties.
function LIST_playerLocalDB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LIST_playerLocalDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_deletePlayer.
function BUT_deletePlayer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_deletePlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TABLE MATRICE option

idTable = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), option.default_DBLocal);
data = TABLE.MEGA_tablePlayers_fromDB{idTable,2};
idx = handles.LIST_playerLocalDB.Value;

if isempty(idx) == 0
    data = data(idx,:);
    deletePlayer(TABLE, MATRICE, option, data, idx);
    defaultDB_name = option.default_DBLocal;
    % To avoid error if last selected, diminue value by 1
    if idx == size(TABLE.MEGA_tablePlayers_fromDB{idTable,2},1)
        set(handles.LIST_playerLocalDB, 'Value', idx-1);
    end
    updateAllGUI(hObject, eventdata, handles, defaultDB_name)
else
    msg = 'Please select a player';
    handles_i = handles.TXT_error;
    prefix = '- ';
    displayErrorMsg( msg, handles_i, prefix )
end

% --- Executes on button press in BUT_newPlayer.
function BUT_newPlayer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_newPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option
addNewPlayer(TABLE, MATRICE, option)
defaultDB_name = option.default_DBLocal;
% updateAllGUI
updateAllGUI(hObject, eventdata, handles, defaultDB_name)


    
% --- Executes on button press in BUT_editPlayer.
function BUT_editPlayer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_editPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option

idTable = strfind_idx(TABLE.MEGA_tablePlayers_fromDB(:,1), option.default_DBLocal);
data = TABLE.MEGA_tablePlayers_fromDB{idTable,2};

idx = handles.LIST_playerLocalDB.Value;
if isempty(idx) == 0
    data = data(idx,:);
    editExistingPlayer(TABLE, MATRICE, option, data, idx);
    defaultDB_name = option.default_DBLocal;
    updateAllGUI(hObject, eventdata, handles, defaultDB_name)
else
    msg = 'Please select a player';
    handles_i = handles.TXT_error;
    prefix = '- ';
    displayErrorMsg( msg, handles_i, prefix )
end







function updateAllGUI(hObject, eventdata, handles, defaultDB_name)
% Look for the GUI
h = findobj('Tag','BushiSoftGUI');
handles = guidata(h);
% Refresh the databases
BUT_refreshLocalDB(handles,eventdata,handles, defaultDB_name);

h = findobj('Tag','manageLocalPlayerGUI');
handles = guidata(h);
updatelistLocalPlayer(hObject, eventdata, handles)