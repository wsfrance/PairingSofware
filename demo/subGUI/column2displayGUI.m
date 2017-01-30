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

% Last Modified by GUIDE v2.5 30-Jan-2017 17:42:32

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
% uiwait(handles.GUI_column2display);


% --- Outputs from this function are returned to the command line.
function varargout = column2displayGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global option

set(handles.TAB_columns, 'data', option.Bool_column2displayStanding, 'RowName', option.column2displayStandingALL', 'ColumnName', 'Check', 'ColumnEditable', [true])
% set(handles.TAB_columns, 'CellEditCallback', @check_checked);


% function check_checked(src, eventdata)
%   cur_data = get(src, 'Data');
%   where_changed = eventdata.Indices;
%   row_changed = where_changed(1);
%   id_affected = cur_data{row_changed, 1};
%   dist_affected = cur_data(row_changed, 2);
%   ... now do something with the information ...


% --- Executes when entered data in editable cell(s) in TAB_columns.
function TAB_columns_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to TAB_columns (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global option

option.Bool_column2displayStanding = handles.TAB_columns.Data;
% option.column2displayStanding = option.column2displayStandingALL(option.Bool_column2displayStanding);
% standingGUI
apply2Standing(hObject, eventdata, handles)

% --- Executes on button press in BUT_all.
function BUT_all_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

columnTable = TABLE.tablePlayers_forTournament.Properties.VariableNames;
option.Bool_column2displayStanding = true(size(columnTable,2),1);
apply2Standing(hObject, eventdata, handles)

% --- Executes on button press in BUT_none.
function BUT_none_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_none (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

columnTable = TABLE.tablePlayers_forTournament.Properties.VariableNames;
option.Bool_column2displayStanding = false(size(columnTable,2),1);
apply2Standing(hObject, eventdata, handles)

% --- Executes on button press in BUT_bushiroadRecommended.
function BUT_bushiroadRecommended_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_bushiroadRecommended (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TABLE option

columnTable = TABLE.tablePlayers_forTournament.Properties.VariableNames;
columns = {'WSCode', 'name', 'familyName', 'pseudo', 'Ranking', 'Points', 'Opp_MW'};
id = ismember(columnTable, columns);
option.Bool_column2displayStanding = id';
apply2Standing(hObject, eventdata, handles)

% --- Executes on button press in BUT_uscfRecommended.
function BUT_uscfRecommended_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_uscfRecommended (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TABLE option

columnTable = TABLE.tablePlayers_forTournament.Properties.VariableNames;
columns = {'WSCode', 'name', 'familyName', 'pseudo', 'Ranking', 'Points', 'Modified_Median', 'Solkoff', 'Cumulative_Score', 'first_Loss'};
id = ismember(columnTable, columns);
option.Bool_column2displayStanding = id';
apply2Standing(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERSONNAL FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function apply2Standing(hObject, eventdata, handles)

global option 

option.column2displayStanding = option.column2displayStandingALL(option.Bool_column2displayStanding);
set(handles.TAB_columns,'Data', option.Bool_column2displayStanding)
standingGUI 
