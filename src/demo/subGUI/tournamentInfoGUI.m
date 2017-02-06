function varargout = tournamentInfoGUI(varargin)
% TOURNAMENTINFOGUI MATLAB code for tournamentInfoGUI.fig
%      TOURNAMENTINFOGUI, by itself, creates a new TOURNAMENTINFOGUI or raises the existing
%      singleton*.
%
%      H = TOURNAMENTINFOGUI returns the handle to a new TOURNAMENTINFOGUI or the handle to
%      the existing singleton*.
%
%      TOURNAMENTINFOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOURNAMENTINFOGUI.M with the given input arguments.
%
%      TOURNAMENTINFOGUI('Property','Value',...) creates a new TOURNAMENTINFOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tournamentInfoGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tournamentInfoGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tournamentInfoGUI

% Last Modified by GUIDE v2.5 02-Feb-2017 20:20:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tournamentInfoGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @tournamentInfoGUI_OutputFcn, ...
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


% --- Executes just before tournamentInfoGUI is made visible.
function tournamentInfoGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tournamentInfoGUI (see VARARGIN)

% Choose default command line output for tournamentInfoGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tournamentInfoGUI wait for user response (see UIRESUME)
% uiwait(handles.tournamentInfoGUI);

global option

% load csv
path = pwd;

% from CSV
default_Locations           = [path '/import/Locations.csv'];
option.list.locations       = csvimport(default_Locations,'delimiter',';');
default_pairingMethod       = [path '/import/PairingMethod.csv'];
option.list.pairingMethod   = csvimport(default_pairingMethod,'delimiter',';');
default_tournamentType      = [path '/import/TournamentType.csv'];
option.list.tournamentType  = csvimport(default_tournamentType,'delimiter',';');

% Transform to table
data = option.list.locations;
column_tmp = data(1,:);
data = array2table(data(2:end,:), 'VariableNames', column_tmp);
data.locname = strrep(data.locname,'"','');
option.list.locations = data;

% Set in GUI
data_location = ['Select'; option.list.locations.locname];
set(handles.POP_location, 'String', data_location);
set(handles.POP_pairingMethod, 'String', option.list.pairingMethod)
set(handles.POP_tournamentType, 'String', option.list.tournamentType)

set(handles.tournamentInfoGUI, 'Name', 'Tournament Information (by malganis35)');

if isfield(option.tournamentInfo, 'date')
    disp('Editing Tournament Information')
    displayTournamentInfo(hObject, eventdata, handles)
else
    disp('Creating a new tournament')
    option.tmp.bool_createTournament = true;
end


function displayTournamentInfo(hObject, eventdata, handles)
global option
set(handles.BUT_date, 'String', option.tournamentInfo.date)
set(handles.EDIT_tournamentName, 'String', option.tournamentInfo.name)
set(handles.EDIT_tournamentDescription, 'String', option.tournamentInfo.description)
id = strfind_idx(option.list.locations.locname, option.tournamentInfo.location) + 1;
set(handles.POP_location, 'Value', id)
id = strfind_idx(option.list.pairingMethod, option.tournamentInfo.pairingMethod);
set(handles.POP_pairingMethod, 'Value', id)
id = strfind_idx(option.list.tournamentType, option.tournamentInfo.tournamentType);
set(handles.POP_tournamentType, 'Value', id)

displayMsg(hObject, eventdata, handles)


% --- Outputs from this function are returned to the command line.
function varargout = tournamentInfoGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function EDIT_tournamentName_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_tournamentName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_tournamentName as text
%        str2double(get(hObject,'String')) returns contents of EDIT_tournamentName as a double

global option

option.tournamentInfo.name = get(hObject,'String');



% --- Executes during object creation, after setting all properties.
function EDIT_tournamentName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_tournamentName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EDIT_tournamentDescription_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_tournamentDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_tournamentDescription as text
%        str2double(get(hObject,'String')) returns contents of EDIT_tournamentDescription as a double

global option

option.tournamentInfo.description = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function EDIT_tournamentDescription_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_tournamentDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BUT_date.
function BUT_date_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BUT_date contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BUT_date

global option
option.tournamentInfo.dateSerial = uigetdate;
formatOut = 'dd/mm/yyyy';
option.tournamentInfo.date = datestr(option.tournamentInfo.dateSerial,formatOut);
set(handles.BUT_date, 'String', option.tournamentInfo.date)


% --- Executes during object creation, after setting all properties.
function BUT_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BUT_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in POP_pairingMethod.
function POP_pairingMethod_Callback(hObject, eventdata, handles)
% hObject    handle to POP_pairingMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_pairingMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_pairingMethod


global option

contents = cellstr(get(hObject,'String'));
option.tournamentInfo.pairingMethod =  contents{get(hObject,'Value')};
displayMsg(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function POP_pairingMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_pairingMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in POP_tournamentType.
function POP_tournamentType_Callback(hObject, eventdata, handles)
% hObject    handle to POP_tournamentType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_tournamentType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_tournamentType

global option

contents =  cellstr(get(hObject,'String'));
option.tournamentInfo.tournamentType = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function POP_tournamentType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_tournamentType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in POP_location.
function POP_location_Callback(hObject, eventdata, handles)
% hObject    handle to POP_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_location contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_location

global option

contents= cellstr(get(hObject,'String'));
option.tournamentInfo.location = contents{get(hObject,'Value')};
id = strfind_idx(option.list.locations.locname, option.tournamentInfo.location);
option.tournamentInfo.locationInfo = option.list.locations(id,:);

% --- Executes during object creation, after setting all properties.
function POP_location_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_setDefault.
function BUT_setDefault_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_setDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

option.tournamentInfo.dateSerial = datetime('today');
formatOut = 'dd/mm/yyyy';
option.tournamentInfo.date = datestr(option.tournamentInfo.dateSerial,formatOut);
option.tournamentInfo.name = ['Tournament of ' option.tournamentInfo.date];
option.tournamentInfo.description = 'No description';
option.tournamentInfo.tournamentType = 'Local';
option.tournamentInfo.pairingMethod = 'Swiss Round';
option.tournamentInfo.location = 'Other';

id = strfind_idx(option.list.locations.locname, option.tournamentInfo.location);
option.tournamentInfo.locationInfo = option.list.locations(id,:);

displayTournamentInfo(hObject, eventdata, handles);





function msg = setMessageTournamentType(hObject, eventdata, handles)

global option

switch option.tournamentInfo.pairingMethod
    case 'Swiss Round'
        msg = 'All players compete in each round. Pairings are done randomly determined each round based on match points with players of equal match points playing against each other. Optional cut to top-8 playoff may be performed at the end of the tournament.';
    case 'Round Robin'
        msg = 'TO BE DONE';
    case 'Single Elimination'
        msg = 'Random pairings. Losing or drawing players are eliminated after each round.';
    case 'Double Elimination'
        msg = 'Pairings are done randomly determined each round based on match points with players of equal match points playing against each other. Players are eliminated from the tournament after losing or drawing 2 matches.';
    otherwise
        disp('option.tournamentInfo.tournamentType not known')
        msg = 'Text information about the Pairing Method.';
end


function displayMsg(hObject, eventdata, handles)

msg = setMessageTournamentType(hObject, eventdata, handles);
% Wrap text, also returning a new position for ht
[outstring,newpos] = textwrap(handles.EDIT_pairingMethod,{msg});
set(handles.EDIT_pairingMethod,'String',outstring,'Position',newpos)



% --- Executes on button press in BUT_cancel.
function BUT_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option
% Delete all informations
option.tournamentInfo = [];
close

% --- Executes on button press in BUT_save.
function BUT_save_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

close

% You need a method to let GUI1 find the handle of GUI2. E.g. the 'Tag' of 
% the FIGURE might be helpful. Then the callback of the GUI1:pushbutton1 
% searches this tag at first:
GUI1H = findobj(allchild(0), 'Tag', 'BushiSoftGUI');
% Now you can get the handles STRUCT of GUI1:
GUI1_handles = guidata(GUI1H);
set(GUI1_handles.EDIT_tournamentName,'String', option.tournamentInfo.name)
set(GUI1_handles.TEXT_tournamentInformation, 'String', option.tournamentInfo.description)
% Assuming, that you find the handle of the edittext1 there:
% GUI2_handles = guidata(ObjH);  % Handles of GUI1
% set(GUI2_handles.edittext1, ...
%    'String', get(GUI2_handles.edittext1));

mode = 'on';
showHandlesTournament(GUI1_handles, mode);

disp('- Create Tournament database')
output = create_tablePlayersTournament(TABLE, option);
TABLE.tablePlayers_forTournament = output;
