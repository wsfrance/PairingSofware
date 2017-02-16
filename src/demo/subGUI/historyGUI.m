function varargout = historyGUI(varargin)
% HISTORYGUI MATLAB code for historyGUI.fig
%      HISTORYGUI, by itself, creates a new HISTORYGUI or raises the existing
%      singleton*.
%
%      H = HISTORYGUI returns the handle to a new HISTORYGUI or the handle to
%      the existing singleton*.
%
%      HISTORYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HISTORYGUI.M with the given input arguments.
%
%      HISTORYGUI('Property','Value',...) creates a new HISTORYGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before historyGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to historyGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help historyGUI

% Last Modified by GUIDE v2.5 16-Feb-2017 16:37:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @historyGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @historyGUI_OutputFcn, ...
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


% --- Executes just before historyGUI is made visible.
function historyGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to historyGUI (see VARARGIN)

% Choose default command line output for historyGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes historyGUI wait for user response (see UIRESUME)
% uiwait(handles.historyGUI);


global TABLE option

try
    subtable = TABLE.HistoryTABLE.standing{1};
catch
    subtable = TABLE.tablePlayers_forTournament;
end
firstnames  = table2cell(subtable(:,'name'));
lastnames   = table2cell(subtable(:,'familyName'));
names       = strcat(lastnames, {', '}, firstnames, {' ('}, num2str(option.no_round), ')');
[names, idx_sorted] = sort(names); % Sort name by alphabetical order
lastnames   = lastnames(idx_sorted);
firstnames  = firstnames(idx_sorted);
subtable = subtable(idx_sorted, :);

player = subtable(option.tmp.id_selectedPlayer,:);
wsCode = player.WSCode;
id1 = strfind_idx(TABLE.historyMatch.WSCode1, wsCode);
id2 = strfind_idx(TABLE.historyMatch.WSCode2, wsCode);
id = [id1; id2];

subtable2display = TABLE.historyMatch(id,:);
set(handles.TAB_history, 'Data', table2cell(subtable2display), 'ColumnName', subtable2display.Properties.VariableNames)

set(handles.TXT_playerName, 'String', strcat(lastnames(option.tmp.id_selectedPlayer,1), {', '}, firstnames(option.tmp.id_selectedPlayer,1), {' ('}, wsCode, ')'))

set(handles.historyGUI, 'Name', 'Player History (by malganis35)');

% --- Outputs from this function are returned to the command line.
function varargout = historyGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
