function varargout = barcodeScannerGUI(varargin)
% BARCODESCANNERGUI MATLAB code for barcodeScannerGUI.fig
%      BARCODESCANNERGUI, by itself, creates a new BARCODESCANNERGUI or raises the existing
%      singleton*.
%
%      H = BARCODESCANNERGUI returns the handle to a new BARCODESCANNERGUI or the handle to
%      the existing singleton*.
%
%      BARCODESCANNERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BARCODESCANNERGUI.M with the given input arguments.
%
%      BARCODESCANNERGUI('Property','Value',...) creates a new BARCODESCANNERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before barcodeScannerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to barcodeScannerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help barcodeScannerGUI

% Last Modified by GUIDE v2.5 16-Dec-2016 21:54:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @barcodeScannerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @barcodeScannerGUI_OutputFcn, ...
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


% --- Executes just before barcodeScannerGUI is made visible.
function barcodeScannerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to barcodeScannerGUI (see VARARGIN)

% Choose default command line output for barcodeScannerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes barcodeScannerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


camList = webcamlist;
camList = ['Select Webcam'; camList];
set(handles.POP_selectWebcam, 'String', camList)
set(handles.PLOT_webcamRender, 'Visible', 'Off')

% --- Outputs from this function are returned to the command line.
function varargout = barcodeScannerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BUT_startWebcam.
function BUT_startWebcam_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_startWebcam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

handles.stop_now = 0;

if option.no_webcam == 0
    msg = 'Not a proper webcam. Select again';
    disp(msg)
    msgbox(msg,'Error','error')
else
    set(handles.PLOT_webcamRender, 'Visible', 'On')
    
    cam = webcam(option.no_webcam);

    bool = 0;
    axes(handles.PLOT_webcamRender)
    tic
    while ~bool
          stop_state = handles.stop_now;
          if stop_state
            clear cam
            break;
          end   
        img = snapshot(cam);
        image(img);
        try
            [ result ] = barcodeScanner( img );
        catch
            result = [];
            disp('Recognition failed')
        end
        if isempty(result)
            disp(['No barcode recognize at time: ' num2str(toc)])
        else
            disp(['Code recognize at time: ' num2str(toc)])
            set(handles.TEXT_barcode, 'String', result)
            clear cam
            bool = 1;
        end
        % handles = guidata(hObject);  %Get the newest GUI data
    end
end

% --- Executes on button press in BUT_stopWebcam.
function BUT_stopWebcam_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_stopWebcam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stop_now = 1;
guidata(hObject, handles); % Update handles structure

% --- Executes on selection change in POP_selectWebcam.
function POP_selectWebcam_Callback(hObject, eventdata, handles)
% hObject    handle to POP_selectWebcam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POP_selectWebcam contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POP_selectWebcam

global option

% list = handles.POP_selectWebcam.String;
option.no_webcam = handles.POP_selectWebcam.Value-1; % -1 because 1st is Select webcam


% --- Executes during object creation, after setting all properties.
function POP_selectWebcam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POP_selectWebcam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
