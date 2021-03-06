function varargout = preferencesGUI(varargin)
% PREFERENCESGUI MATLAB code for preferencesGUI.fig
%      PREFERENCESGUI, by itself, creates a new PREFERENCESGUI or raises the existing
%      singleton*.
%
%      H = PREFERENCESGUI returns the handle to a new PREFERENCESGUI or the handle to
%      the existing singleton*.
%
%      PREFERENCESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREFERENCESGUI.M with the given input arguments.
%
%      PREFERENCESGUI('Property','Value',...) creates a new PREFERENCESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before preferencesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to preferencesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help preferencesGUI

% Last Modified by GUIDE v2.5 08-Feb-2017 13:18:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @preferencesGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @preferencesGUI_OutputFcn, ...
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


% --- Executes just before preferencesGUI is made visible.
function preferencesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to preferencesGUI (see VARARGIN)

% Choose default command line output for preferencesGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes preferencesGUI wait for user response (see UIRESUME)
% uiwait(handles.preferencesGUI);

global option

disp('- Set handles')
set(handles.EDIT_csvFileDelimiter, 'String', option.delimiter)
set(handles.LIST_tieBreaker, 'String', option.column2sort')
set(handles.LIST_additionnalPlayerInfo, 'String', option.additionnalTournamentVariable')

set(handles.POP_VariablesFor_swissRoundType, 'String', option.column2sort')
contents = cellstr(get(handles.POP_VariablesFor_swissRoundType,'String'));
idx = strfind_idx(contents, option.swissRoundGroup);
set(handles.POP_VariablesFor_swissRoundType, 'Value', idx)

contents = cellstr(get(handles.POP_swissRoundType,'String'));
idx = strfind_idx(contents, option.swissRoundType);

set(handles.POP_swissRoundType, 'Value', idx)
set(handles.EDIT_configurationName, 'String', option.nameConfig)

disp('- Set title')
set(handles.preferencesGUI, 'Name', 'Preferences of Software (by malganis35)');


% --- Outputs from this function are returned to the command line.
function varargout = preferencesGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on selection change in POP_swissRoundType.
function POP_swissRoundType_Callback(hObject, eventdata, handles)
% hObject    handle to POP_swissRoundType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_swissRoundType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_swissRoundType


% --- Executes during object creation, after setting all properties.
function POP_swissRoundType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_swissRoundType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EDIT_csvFileDelimiter_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_csvFileDelimiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_csvFileDelimiter as text
%        str2double(get(hObject,'String')) returns contents of EDIT_csvFileDelimiter as a double


% --- Executes during object creation, after setting all properties.
function EDIT_csvFileDelimiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_csvFileDelimiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_loadConfiguration.
function BUT_loadConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_loadConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option
[filename, pathname] = uigetfile('*.mat','Select the configuration', 'config\');
if isequal(filename,0) || isequal(pathname,0)
   disp('User selected Cancel')
else
   disp(['User selected ',fullfile(pathname,filename)])
   load(fullfile(pathname,filename))
   preferencesGUI
end

% --- Executes on button press in BUT_saveAsConfiguration.
function BUT_saveAsConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_saveAsConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

[filename, pathname] = uiputfile({'*.mat';'*.*'}, 'Save as the configuration', 'config\myconfig.mat');
if isequal(filename,0) || isequal(pathname,0)
   disp('User selected Cancel')
else
   disp(['User selected ',fullfile(pathname,filename)])
   option.nameConfig = filename;
   save([pathname filename], 'option')
   set(handles.EDIT_configurationName, 'String', option.nameConfig)
end


% --- Executes on selection change in LIST_tieBreaker.
function LIST_tieBreaker_Callback(hObject, eventdata, handles)
% hObject    handle to LIST_tieBreaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LIST_tieBreaker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LIST_tieBreaker



% --- Executes during object creation, after setting all properties.
function LIST_tieBreaker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LIST_tieBreaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_addToBreaker.
function BUT_addToBreaker_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_addToBreaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)

% --- Executes on selection change in LIST_additionnalPlayerInfo.
function LIST_additionnalPlayerInfo_Callback(hObject, eventdata, handles)
% hObject    handle to LIST_additionnalPlayerInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LIST_additionnalPlayerInfo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LIST_additionnalPlayerInfo


% --- Executes during object creation, after setting all properties.
function LIST_additionnalPlayerInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LIST_additionnalPlayerInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EDIT_configurationName_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_configurationName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_configurationName as text
%        str2double(get(hObject,'String')) returns contents of EDIT_configurationName as a double


% --- Executes during object creation, after setting all properties.
function EDIT_configurationName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_configurationName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in POP_VariablesFor_swissRoundType.
function POP_VariablesFor_swissRoundType_Callback(hObject, eventdata, handles)
% hObject    handle to POP_VariablesFor_swissRoundType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_VariablesFor_swissRoundType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_VariablesFor_swissRoundType

global option

contents = cellstr(get(hObject,'String'));
option.swissRoundGroup = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function POP_VariablesFor_swissRoundType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_VariablesFor_swissRoundType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_systemPoints.
function BUT_systemPoints_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_systemPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

prompt      = {'Points for winner:','Points for draw', 'Points for loss'};
dlg_title   = 'System Points';
num_lines   = 1;
data        = [option.winningPoint; option.tiePoint; option.losePoint]';
stringData  = strread(num2str(data),'%s');
defaultans  = stringData;
answer      = inputdlg(prompt,dlg_title,num_lines,defaultans);

if isempty(answer) == 0
    option.winningPoint     = str2double(answer{1});
    option.losePoint        = str2double(answer{3});
    option.tiePoint         = str2double(answer{2});
end

% --- Executes on button press in BUT_up.
function BUT_up_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option
idx      = get(handles.LIST_tieBreaker,'Value');
option.column2sort = [option.column2sort(1:idx-2) option.column2sort(idx) option.column2sort(idx-1) option.column2sort(idx+1:end)];
option.sortType    = [option.sortType(1:idx-2) option.sortType(idx) option.sortType(idx-1) option.sortType(idx+1:end)];
set(handles.LIST_tieBreaker, 'String', option.column2sort, 'Value', idx-1)

% --- Executes on button press in BUT_down.
function BUT_down_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global option
idx      = get(handles.LIST_tieBreaker,'Value');
option.column2sort = [option.column2sort(1:idx-1) option.column2sort(idx+1) option.column2sort(idx) option.column2sort(idx+2:end)];
option.sortType    = [option.sortType(1:idx-1) option.sortType(idx+1) option.sortType(idx) option.sortType(idx+2:end)];
set(handles.LIST_tieBreaker, 'String', option.column2sort, 'Value', idx+1)

% --- Executes on button press in BUT_deleteToBreaker.
function BUT_deleteToBreaker_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_deleteToBreaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)

% --- Executes on button press in BUT_Reset2Default.
function BUT_Reset2Default_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_Reset2Default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Reset to default config')
defaultConfig
preferencesGUI


% --- Executes on button press in BUT_addAdditionnalPlayerInfo.
function BUT_addAdditionnalPlayerInfo_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_addAdditionnalPlayerInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

prompt      = {'Enter new variable'};
dlg_title   = 'New Player Info';
num_lines   = 1;
defaultans  = {'Info'};
answer      = inputdlg(prompt,dlg_title,num_lines,defaultans);
answer      = answer{1};

if isempty(answer) == 0
    idx = strfind_idx(option.additionnalTournamentVariable, answer);
    if isempty(idx) == 0
        msg = 'Variable already exists';
        disp(msg)
        msgbox(msg, 'Error', 'error')
    else
        option.additionnalTournamentVariable = [option.additionnalTournamentVariable answer];
        set(handles.LIST_additionnalPlayerInfo, 'String', option.additionnalTournamentVariable')
    end
end


% --- Executes on button press in BUT_deleteAdditionnalPlayerInfo.
function BUT_deleteAdditionnalPlayerInfo_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_deleteAdditionnalPlayerInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

idx = get(handles.LIST_additionnalPlayerInfo,'Value');
if idx <= 3
    msg = 'Series, Language and email cannot be deleted';
    disp(msg)
    msgbox(msg, 'Error', 'error')
else
    option.additionnalTournamentVariable(idx) = [];
    if idx > size(option.additionnalTournamentVariable,2)
        idx = size(option.additionnalTournamentVariable,2);
    end
    set(handles.LIST_additionnalPlayerInfo, 'String', option.additionnalTournamentVariable', 'Value', idx)
end

% --- Executes on button press in BUT_userConfig.
function BUT_userConfig_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_userConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

prompt      = {'Enter your name:','Enter your email address'};
dlg_title   = 'User Configuration';
num_lines   = 1;
defaultans  = {option.userInfo.name, option.userInfo.email};
answer      = inputdlg(prompt,dlg_title,num_lines,defaultans);

if isempty(answer)
    disp('Box is cancelled')
else
    option.userInfo.name  = answer{1}; 
    option.userInfo.email = answer{1}; 
end
