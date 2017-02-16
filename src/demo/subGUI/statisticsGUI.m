function varargout = statisticsGUI(varargin)
% STATISTICSGUI MATLAB code for statisticsGUI.fig
%      STATISTICSGUI, by itself, creates a new STATISTICSGUI or raises the existing
%      singleton*.
%
%      H = STATISTICSGUI returns the handle to a new STATISTICSGUI or the handle to
%      the existing singleton*.
%
%      STATISTICSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATISTICSGUI.M with the given input arguments.
%
%      STATISTICSGUI('Property','Value',...) creates a new STATISTICSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before statisticsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to statisticsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help statisticsGUI

% Last Modified by GUIDE v2.5 08-Feb-2017 14:21:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @statisticsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @statisticsGUI_OutputFcn, ...
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


% --- Executes just before statisticsGUI is made visible.
function statisticsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to statisticsGUI (see VARARGIN)

% Choose default command line output for statisticsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes statisticsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global TABLE

variable = TABLE.tablePlayers_forTournament.Properties.VariableNames;
set(handles.LIST_variable, 'String', variable)
set(handles.PLOT_graph, 'Visible', 'Off')

% --- Outputs from this function are returned to the command line.
function varargout = statisticsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in LIST_variable.
function LIST_variable_Callback(hObject, eventdata, handles)
% hObject    handle to LIST_variable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LIST_variable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LIST_variable

global TABLE
contents = cellstr(get(hObject,'String'));
variable2Analyze = contents{get(hObject,'Value')};
subtable = TABLE.tablePlayers_forTournament;
id_BYE = strfind_idx(TABLE.tablePlayers_forTournament.WSCode, '**BYE**');
if isempty(id_BYE) == 0
    subtable(id_BYE,:) = [];
end
pieChart(hObject, eventdata, handles, subtable, variable2Analyze)


function pieChart(hObject, eventdata, handles, subtable, variable2Analyze)

% Analysis of the data
% x = [1,2,3, 4, 5];
% txt = {'Item A: ';'Item B: ';'Item C: ';'Item D: ';'Item E: '}; % strings
% x = [1,2,3];
% txt = {'Item A: ';'Item B: ';'Item C: '}; % strings
idx = strfind_idx(subtable.Properties.VariableNames', variable2Analyze);
idx = idx(1);
data = table2cell(subtable(:,idx));
% Replace all void cells
id = find(cellfun('isempty', data)==true);
txt_default = ['No ' variable2Analyze ' Set'];
data(id) = {txt_default};
% txt = unique(data);
% for i = 1:size(txt,1)
%     txt_i = txt{i};
%     id = strfind_idx(data, txt_i);
%     x(i) = length(id);
% end
try
    txt=unique(data,'stable');
catch
    c = cell2mat(data);
    data = cellstr(num2str(c(:)));
    txt=unique(data,'stable');
end
xx = data; % {'computer', 'car', 'computer', 'bus', 'tree', 'car'}
b=cellfun(@(x) sum(ismember(xx,x)),txt,'un',0);
x= cell2mat(b);

% Sort data
% [x, id]  = sort(x);
% txt = txt(id);

nb_total_item = size(txt,1);
% CREATE A BEAUTIFUL PIE CHART
set(handles.PLOT_graph, 'Visible', 'On')
h = pie(handles.PLOT_graph, x);


% Store Precalculated Percent Values
hText = findobj(h,'Type','text'); % text object handles
percentValues = get(hText,'String'); % percent values

% Combine Percent Values and Additional Text
combinedtxt = strcat(txt,{' ('},percentValues,{')'}); % strings and percent values
oldExtents_cell = get(hText,'Extent'); % cell array
if nb_total_item > 1    
    disp('do nothing')
else
    oldExtents_cell = {oldExtents_cell};
end
oldExtents = cell2mat(oldExtents_cell); % numeric array

% hText(1).String = combinedtxt(1);
% hText(2).String = combinedtxt(2);
% hText(3).String = combinedtxt(3);
for i = 1:nb_total_item
    hText(i).String = combinedtxt(i);
end

if nb_total_item > 1    
    % Determine Horizontal Distance to Move Each Label
    newExtents_cell = get(hText,'Extent'); % cell array
    newExtents = cell2mat(newExtents_cell); % numeric array
    width_change = newExtents(:,3)-oldExtents(:,3);
    % Use the change in width to calculate the horizontal distance to move each label. Store the calculated offsets in offset.
    signValues = sign(oldExtents(:,1));
    offset = signValues.*(width_change/2);
    % Position New Label
    textPositions_cell = get(hText,{'Position'}); % cell array
    textPositions = cell2mat(textPositions_cell); % numeric array
    textPositions(:,1) = textPositions(:,1) + offset; % add offset

    % hText(1).Position = textPositions(1,:);
    % hText(2).Position = textPositions(2,:);
    % hText(3).Position = textPositions(3,:);
    for i = 1:nb_total_item
        hText(i).Position = textPositions(i,:);
    end
end


% --- Executes during object creation, after setting all properties.
function LIST_variable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LIST_variable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
