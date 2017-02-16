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

% Last Modified by GUIDE v2.5 16-Feb-2017 10:39:51

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
% uiwait(handles.GUI_barcode);

global option

camList = webcamlist;
camList = ['Select Webcam'; camList];
option.no_webcam = 1;
set(handles.POP_selectWebcam, 'String', camList, 'Value', 2)
set(handles.PLOT_webcamRender, 'Visible', 'Off')

% path of dynamic JAVA library
javaaddpath('..\externalLibs\QR-code-WORKING\QRCodeGenerator1.1\qrcode_gen\jarfiles\core-3.2.0.jar');
javaaddpath('..\externalLibs\QR-code-WORKING\QRCodeGenerator1.1\qrcode_gen\jarfiles\javase-3.2.0.jar');

refreshTableQRPlayers(hObject, eventdata, handles)

disp('- Initialize functions (@cellSelect) to Tables')
set(handles.TAB_playerQR, 'CellSelectionCallback',@cellSelect); 


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

% Check webcam
if option.no_webcam == 0
    msg = 'Not a proper webcam. Select again';
    disp(msg)
    msgbox(msg,'Error','error')
else
    cam = webcam(option.no_webcam);
end
% playWebcamAndRecognizeQRCode(hObject, eventdata, handles)

% create a data field within handles to say that we've started the
% image acquisition
handles.stop_now = 0;
% save the field to the handles structure
guidata(hObject,handles);
% condition on this field being one
axes(handles.PLOT_webcamRender)
tic
while handles.stop_now == 0
    % get the most recent copy of handles
    handles = guidata(hObject);
    % etc., as before   
    img = snapshot(cam);
    image(img);
    axis off
    recognizeQRCode(hObject, eventdata, handles, img)
end

% If GUI is closed
if handles.stop_now==2
    delete(handles.GUI_barcode);
end


function recognizeQRCode(hObject, eventdata, handles, img)
global TABLE
try
    [ subtable, result ] = qrcode_reader_Cao( img );
    
    % Check if player is in the database
    if isempty(TABLE.playerQR)
        % intialization of the table
        idx = [];
    else
        idx = find(ismember(TABLE.playerQR.WSCode, subtable.WSCode)==true);
    end
    if isempty(idx)
        msg = 'Player is not in the Database QR. Adding it';
        disp(msg)
        TABLE.playerQR = [TABLE.playerQR; subtable];
    else
        msg = ['Player is already in the Database at number: ' num2str(idx(1))];
        disp(msg)
        % msgbox(msg, 'Error', 'error')
        % BUT_stopWebcam_Callback(hObject, eventdata, handles)
        set(handles.TXT_errorDisplay, 'String', msg)
    end
catch
    result = [];
    disp('Recognition failed')
    set(handles.TXT_errorDisplay, 'String', 'No player recognized')
end

if isempty(result)
    disp(['No barcode recognize at time: ' num2str(toc)])
else
    disp(['Code recognize at time: ' num2str(toc)])
    set(handles.TEXT_barcode, 'String', 'QR Code recognized')
    refreshTableQRPlayers(hObject, eventdata, handles)
    % Stop Cam if checkbox is checked
    if get(handles.CHECK_stopCamAtQR,'Value')
        BUT_stopWebcam_Callback(hObject, eventdata, handles)
    end
end



function playWebcamAndRecognizeQRCode(hObject, eventdata, handles)
global TABLE option
if option.no_webcam == 0
    msg = 'Not a proper webcam. Select again';
    disp(msg)
    msgbox(msg,'Error','error')
else
        
        set(handles.PLOT_webcamRender, 'Visible', 'On')

        cam = webcam(option.no_webcam);

        bool = 0;
        axes(handles.PLOT_webcamRender)
        axis off
        tic
        while ~bool   
            img = snapshot(cam);
            image(img);
            stop_state = handles.stop_now;
            if stop_state
                clear cam
                break;
            end
            try
                [ subtable, result ] = qrcode_reader_Cao( img );

                % Check if player is in the database
                if isempty(TABLE.playerQR)
                    % intialization of the table
                    idx = [];
                else
                    idx = find(ismember(TABLE.playerQR.WSCode, subtable.WSCode)==true);
                end
                if isempty(idx)
                    msg = 'Player is not in the Database QR. Adding it';
                    disp(msg)
                    TABLE.playerQR = [TABLE.playerQR; subtable];
                else
                    msg = ['Player is already in the Database at number: ' num2str(idx(1))];
                    disp(msg)
                    msgbox(msg, 'Error', 'error')
                end
            catch
                result = [];
                disp('Recognition failed')
            end
            if isempty(result)
                disp(['No barcode recognize at time: ' num2str(toc)])
            else
                disp(['Code recognize at time: ' num2str(toc)])
                set(handles.TEXT_barcode, 'String', 'QR Code recognized')
                clear cam
                bool = 1;
                refreshTableQRPlayers(hObject, eventdata, handles)
            end
            % handles = guidata(hObject);  %Get the newest GUI data
        end
end


function refreshTableQRPlayers(hObject, eventdata, handles)
global TABLE

try
    subtable = TABLE.playerQR;
    data = table2cell(subtable);
    header = subtable.Properties.VariableNames;
    set(handles.TAB_playerQR, 'data', data, 'ColumnName', header)
end


% --- Executes on button press in BUT_stopWebcam.
function BUT_stopWebcam_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_stopWebcam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.stop_now = 1;
% guidata(hObject, handles); % Update handles structure

fprintf('trying to stop...\n');
 % stop the image acquisition
%  handles.imgAcqStarted = 0;
 handles.stop_now = 1;
 % save the field to the handles structure
 guidata(hObject,handles);


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


% --- Executes on button press in BUT_addPlayerQRTournament.
function BUT_addPlayerQRTournament_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_addPlayerQRTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option

% Get the cells selected in 'TAB_players'
UITable = 'TAB_playerQR';
[ data, rows] = getCellSelect( UITable );
rows = unique(rows); % to avoid multiple selection on the same line

TABLE.tablePlayers_forTournament = concatenateTable(TABLE.tablePlayers_forTournament , TABLE.playerQR(rows,:));

% Refresh main GUI
column2sort     = option.column2sortTournament      ;
table_tmp       = TABLE.tablePlayers_forTournament  ;
handle_display  = findobj('Tag', 'TAB_players_Tournament');
column2display  = [option.columnTableDB option.additionnalTournamentVariable];
sortOrder       = option.sortOrderTournament        ;
displayOrderTable(option,column2sort, table_tmp, handle_display, column2display, sortOrder)

% Delete from QR Code
TABLE.playerQR(rows,:) = [];
refreshTableQRPlayers(hObject, eventdata, handles)


% --- Executes on button press in BUT_deletePlayerQR.
function BUT_deletePlayerQR_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_deletePlayerQR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE

% Get the cells selected in 'TAB_players'
UITable = 'TAB_playerQR';
[ data, rows] = getCellSelect( UITable );
rows = unique(rows); % to avoid multiple selection on the same line

TABLE.playerQR(rows,:) = [];
refreshTableQRPlayers(hObject, eventdata, handles)


% --- Executes when user attempts to close GUI_barcode.
function GUI_barcode_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to GUI_barcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(hObject);
if handles.stop_now==0
    handles.imgAcqStarted = 2;
    guidata(hObject,handles);
else
    delete(hObject);
end


% --- Executes on button press in CHECK_stopCamAtQR.
function CHECK_stopCamAtQR_Callback(hObject, eventdata, handles)
% hObject    handle to CHECK_stopCamAtQR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CHECK_stopCamAtQR
