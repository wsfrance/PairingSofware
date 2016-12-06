function varargout = column2displayGUI(varargin)
% COLUMN2DISPLAYGUI MATLAB code for column2displayGUI.fig
%      COLUMN2DISPLAYGUI, by itself, creates a new COLUMN2DISPLAYGUI or raises the existing
%      singleton*.
%
%      H = COLUMN2DISPLAYGUI returns the handle to a new COLUMN2DISPLAYGUI or the handle to
%      the existing singleton*.
%
%      COLUMN2DISPLAYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLUMN2DISPLAYGUI.M with the given input arguments.
%
%      COLUMN2DISPLAYGUI('Property','Value',...) creates a new COLUMN2DISPLAYGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before column2displayGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to column2displayGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help column2displayGUI

% Last Modified by GUIDE v2.5 05-Dec-2016 21:24:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @column2displayGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @column2displayGUI_OutputFcn, ...
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


% --- Executes just before column2displayGUI is made visible.
function column2displayGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to column2displayGUI (see VARARGIN)

% Choose default command line output for column2displayGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes column2displayGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = column2displayGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global tablePlayers_forTournament columnTable option

columnTable = tablePlayers_forTournament.Properties.VariableNames;

set(handles.TAB_columns, 'data', option.column2displayStanding, 'RowName', columnTable', 'ColumnName', 'Check', 'ColumnEditable', [true])
% set(handles.TAB_columns, 'CellEditCallback', @check_checked);


% function check_checked(src, eventdata)
%   cur_data = get(src, 'Data');
%   where_changed = eventdata.Indices;
%   row_changed = where_changed(1);
%   id_affected = cur_data{row_changed, 1};
%   dist_affected = cur_data(row_changed, 2);
%   ... now do something with the information ...
