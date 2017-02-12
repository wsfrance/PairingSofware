function varargout = timerGUI(varargin)
% TIMERGUI MATLAB code for timerGUI.fig
%      TIMERGUI, by itself, creates a new TIMERGUI or raises the existing
%      singleton*.
%
%      H = TIMERGUI returns the handle to a new TIMERGUI or the handle to
%      the existing singleton*.
%
%      TIMERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMERGUI.M with the given input arguments.
%
%      TIMERGUI('Property','Value',...) creates a new TIMERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before timerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to timerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help timerGUI

% Last Modified by GUIDE v2.5 07-Feb-2017 21:01:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @timerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @timerGUI_OutputFcn, ...
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


% --- Executes just before timerGUI is made visible.
function timerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to timerGUI (see VARARGIN)

% Choose default command line output for timerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes timerGUI wait for user response (see UIRESUME)
% uiwait(handles.timerGUI);



% --- Outputs from this function are returned to the command line.
function varargout = timerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function EDIT_timer_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_timer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_timer as text
%        str2double(get(hObject,'String')) returns contents of EDIT_timer as a double


% --- Executes during object creation, after setting all properties.
function EDIT_timer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_timer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BUT_start.
function BUT_start_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global a handle_i
handle_i = handles;
a = timer;
tic;
% disp(toc(tStart))
set(a,'ExecutionMode','fixedRate')
set(a,'TimerFcn', @(~,~)displayTimer);
start(a)

function displayTimer()
global handle_i option
t1 = toc;
if t1>option.timeForARound
    t1 = option.timeForARound +1;
end
timeElapsed = t1;
time_Rested = (option.timeForARound - timeElapsed + 1)/(24*60*60);
timeString = datestr(time_Rested, 'HH:MM:SS');

% disp(timeString)
set(handle_i.EDIT_timer, 'String', timeString)

% disp('---------------------------------------------------')
% disp(['Time for a round: ' num2str(option.timeForARound)])
% timeString_tmp = datestr(option.timeForARound, 'HH:MM:SS');
% disp(['Time for a round (String): ' timeString_tmp])
% disp(['Time Elapsed: ' num2str(timeElapsed)])
% disp(['Time Rested: ' num2str(time_Rested)])
% disp(['Time Rested (String): ' timeString])

% --- Executes on button press in BUT_stop.
function BUT_stop_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global a
stop(a)


% --------------------------------------------------------------------
function MENU_menu_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_setChrono_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_setChrono (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

prompt = {'Enter Time for a Round'};
dlg_title = 'Time for a round (format HH:MM:SS)';
num_lines = 1;
defaultans = {'00:30:00'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

Date = answer{1};
[Y, M, D, H, MN, S] = datevec(Date);
Seconds = H*3600+MN*60+S;
option.timeForARound = Seconds;


% --- Executes when user attempts to close timerGUI.
function timerGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to timerGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global a
stop(a);
% StopTimer(handles);
delete(hObject);
