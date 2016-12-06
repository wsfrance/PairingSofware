function varargout = standingGUI(varargin)
% STANDINGGUI MATLAB code for standingGUI.fig
%      STANDINGGUI, by itself, creates a new STANDINGGUI or raises the existing
%      singleton*.
%
%      H = STANDINGGUI returns the handle to a new STANDINGGUI or the handle to
%      the existing singleton*.
%
%      STANDINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STANDINGGUI.M with the given input arguments.
%
%      STANDINGGUI('Property','Value',...) creates a new STANDINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before standingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to standingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help standingGUI

% Last Modified by GUIDE v2.5 06-Dec-2016 11:16:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @standingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @standingGUI_OutputFcn, ...
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


% --- Executes just before standingGUI is made visible.
function standingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to standingGUI (see VARARGIN)

% Choose default command line output for standingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes standingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global tablePlayers_forTournament

subtable = tablePlayers_forTournament;
% Delete historyPoints that is not of size 1 x 1
subtable.historyPoints = [];
subtable.playerId = [];

varnames = subtable.Properties.VariableNames;
others = ~strcmp('Ranking',varnames);
varnames = ['Ranking' varnames(others) ];
subtable = subtable(:,varnames);


columnTable = subtable.Properties.VariableNames;
data = table2cell(subtable(:,columnTable));
set(handles.TAB_standing, 'data', data, 'ColumnName', columnTable)

% Maybe to put in code
% source : http://undocumentedmatlab.com/blog/uitable-cell-colors/
% Re-size columns width
% autoResizeTable( handles.TAB_standing )


% --- Outputs from this function are returned to the command line.
function varargout = standingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BUT_columnSelection.
function BUT_columnSelection_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_columnSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
column2displayGUI


% --------------------------------------------------------------------
function MENU_print_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printpreview


