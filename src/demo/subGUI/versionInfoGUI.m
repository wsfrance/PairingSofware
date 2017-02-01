function varargout = versionInfoGUI(varargin)
% VERSIONINFOGUI MATLAB code for versionInfoGUI.fig
%      VERSIONINFOGUI, by itself, creates a new VERSIONINFOGUI or raises the existing
%      singleton*.
%
%      H = VERSIONINFOGUI returns the handle to a new VERSIONINFOGUI or the handle to
%      the existing singleton*.
%
%      VERSIONINFOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VERSIONINFOGUI.M with the given input arguments.
%
%      VERSIONINFOGUI('Property','Value',...) creates a new VERSIONINFOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before versionInfoGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to versionInfoGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help versionInfoGUI

% Last Modified by GUIDE v2.5 01-Feb-2017 19:41:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @versionInfoGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @versionInfoGUI_OutputFcn, ...
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


% --- Executes just before versionInfoGUI is made visible.
function versionInfoGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to versionInfoGUI (see VARARGIN)

% Choose default command line output for versionInfoGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes versionInfoGUI wait for user response (see UIRESUME)
% uiwait(handles.versionInfoGUI);

% Set title
set(handles.versionInfoGUI, 'Name', 'New Bushiroad Tournament Software (by malganis35)');

% Set text
fid = fopen('versionInfo.txt','r');
if fid~=-1 %if the file doesn't exist ignore the reading code
    set(handles.TXT_versionInfo,'String',fscanf(fid,'%c'))
    fclose(fid);
end



% --- Outputs from this function are returned to the command line.
function varargout = versionInfoGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
