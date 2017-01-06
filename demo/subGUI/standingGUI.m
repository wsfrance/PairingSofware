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

% Last Modified by GUIDE v2.5 16-Dec-2016 22:50:16

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

global TABLE option

subtable = TABLE.tablePlayers_forTournament;

% columnTable = subtable.Properties.VariableNames;
columnTable = option.column2displayStanding;
id = strfind_idx(columnTable','historyPoint');
columnTable(id)=[];
id = strfind_idx(columnTable','playerId');
columnTable(id)=[];
% Delete historyPoints that is not of size 1 x 1
% subtable.historyPoints = [];
% subtable.playerId = [];

% varnames = subtable.Properties.VariableNames;
% others = ~strcmp('Ranking',varnames);
% varnames = ['Ranking' varnames(others) ];
% subtable = subtable(:,varnames);
varnames = columnTable;
others = ~strcmp('Ranking',varnames);
varnames = ['Ranking' varnames(others) ];
option.column2displayStanding = varnames;

data = table2cell(subtable(:,option.column2displayStanding));
set(handles.TAB_standing, 'data', data, 'ColumnName', option.column2displayStanding)

% Maybe to put in code
% source : http://undocumentedmatlab.com/blog/uitable-cell-colors/
% Re-size columns width
% autoResizeTable( handles.TAB_standing )

string = cell(option.no_round+1,1);
string(1,1) = {'Select Round'};
for i = 1:option.no_round
    string(i+1,1) = {['Round ' num2str(i)]};   
end
% string = {'Select Round'; 'Round 1'; 'Round 2'};
set(handles.POP_selectRound,'String', string)
set(handles.POP_selectRound,'Value', option.no_round+1)



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


% --- Executes on key press with focus on TAB_standing and none of its controls.
function TAB_standing_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to TAB_standing (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in BUT_export.
function BUT_export_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

[ InterfaceObj, oldpointer ] = turnOffGUI( handles );
% Export to XLS
path = pwd;
filename = [path '/export/Standings_Round_' num2str(option.no_round) '.xls'];
filename2 = [path '/export/Standings_Round_' num2str(option.no_round) '.pdf'];
T = TABLE.tablePlayers_forTournament;
exportTable2CSV( T, filename, option.column2displayStanding )

export_XLS2PDF(filename, filename2, option)
turnOnGUI( handles, InterfaceObj, oldpointer )


% T = TABLE.tablePlayers_forTournament;
% 
% T_reordered = T(:,option.column2displayStanding);
% 
% if exist(filename, 'file') == 2
%     disp('File already exists. Deleting it')
%     delete(filename);
% end
% writetable(T_reordered,filename)
% disp(['Save into the file :' filename])


% --- Executes on selection change in POP_selectRound.
function POP_selectRound_Callback(hObject, eventdata, handles)
% hObject    handle to POP_selectRound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_selectRound contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_selectRound

global MATRICE option

disp('Selecting Specific Round')
round_selected = handles.POP_selectRound.Value-1;
id = find(cell2mat(MATRICE.HistoryTABLE(:,1))==round_selected);

if isempty(id) == 0
    subtable = MATRICE.HistoryTABLE{id,2};
    data = table2cell(subtable(:,option.column2displayStanding));
    set(handles.TAB_standing, 'data', data, 'ColumnName', option.column2displayStanding)
else
    msg = 'Round not available';
    disp(msg)
    msgbox(msg,'Error','error')
end

