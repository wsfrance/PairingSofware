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

% Last Modified by GUIDE v2.5 04-Dec-2016 18:47:15

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

% Create Data
[ tablePlayers_fromDB, tablePlayers_forTournament ] = generateTable();

% Select Data to vizualize
column2check = {'WSCode', 'name', 'familyName'};
data = table2cell(tablePlayers_fromDB(:,column2check));
set(handles.TAB_players, 'data', data, 'ColumnName', column2check)





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
