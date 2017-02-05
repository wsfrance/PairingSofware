function varargout = manageDBGUI(varargin)
% MANAGEDBGUI MATLAB code for manageDBGUI.fig
%      MANAGEDBGUI, by itself, creates a new MANAGEDBGUI or raises the existing
%      singleton*.
%
%      H = MANAGEDBGUI returns the handle to a new MANAGEDBGUI or the handle to
%      the existing singleton*.
%
%      MANAGEDBGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANAGEDBGUI.M with the given input arguments.
%
%      MANAGEDBGUI('Property','Value',...) creates a new MANAGEDBGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manageDBGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manageDBGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manageDBGUI

% Last Modified by GUIDE v2.5 05-Feb-2017 13:15:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manageDBGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @manageDBGUI_OutputFcn, ...
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


% --- Executes just before manageDBGUI is made visible.
function manageDBGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manageDBGUI (see VARARGIN)

% Choose default command line output for manageDBGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manageDBGUI wait for user response (see UIRESUME)
% uiwait(handles.manageDBGUI);
updatelistDB(hObject, eventdata, handles) 

% Set title
set(handles.manageDBGUI, 'Name', 'Manage Local Databases (by malganis35)');



function updatelistDB(hObject, eventdata, handles) 

files = listDBPlayers( );
set(handles.LIST_DB, 'String', files)

% --- Outputs from this function are returned to the command line.
function varargout = manageDBGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in LIST_DB.
function LIST_DB_Callback(hObject, eventdata, handles)
% hObject    handle to LIST_DB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LIST_DB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LIST_DB


% --- Executes during object creation, after setting all properties.
function LIST_DB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LIST_DB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_deleteDB.
function BUT_deleteDB_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_deleteDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

contents = cellstr(get(handles.LIST_DB,'String'));
selected_DB = contents{get(handles.LIST_DB,'Value')};

% option.default_DBOnline = 'fileforsw.csv';
% option.default_DBLocal = 'NewPlayers_local.csv';
if strcmp(selected_DB, option.default_DBOnline) == 0 && strcmp(selected_DB, option.default_DBLocal) == 0
    dirName = '../data/playerDB';
    filename = [dirName '/' selected_DB];
    try
        delete(filename);
        msg = ['SUCCESS : Delete' selected_DB];
    catch
        msg = ['FAIL : Delete' selected_DB];
    end
else
    msg = ['cannot delete ' option.default_DBOnline ' or ' option.default_DBLocal '. This is the default DB'];
end
disp(msg)
msgbox(msg, 'Error', 'error')
updatelistDB(hObject, eventdata, handles) 

% Update main GUI
disp('- Update main GUI')
handleListDB = findobj('Tag', 'POP_selectDB');
files        = listDBPlayers( );
disp(['-- ' num2str(size(files,1)) ' file(s) were found locally: '])
disp(files)
files = ['Select Database'; files];
set(handleListDB,'String',files, 'Value', size(files,1))
