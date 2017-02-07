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

% Last Modified by GUIDE v2.5 07-Feb-2017 14:22:28

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
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = preferencesGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in POP_systemPoints.
function POP_systemPoints_Callback(hObject, eventdata, handles)
% hObject    handle to POP_systemPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_systemPoints contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_systemPoints


% --- Executes during object creation, after setting all properties.
function POP_systemPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_systemPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on button press in BUT_saveAsConfiguration.
function BUT_saveAsConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_saveAsConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in LIT_tieBreaker.
function LIT_tieBreaker_Callback(hObject, eventdata, handles)
% hObject    handle to LIT_tieBreaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LIT_tieBreaker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LIT_tieBreaker


% --- Executes during object creation, after setting all properties.
function LIT_tieBreaker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LIT_tieBreaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_tieBreaker.
function BUT_tieBreaker_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_tieBreaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in BUT_additionnalPlayerInfo.
function BUT_additionnalPlayerInfo_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_additionnalPlayerInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
