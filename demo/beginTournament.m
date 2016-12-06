function varargout = beginTournament(varargin)
% BEGINTOURNAMENT MATLAB code for beginTournament.fig
%      BEGINTOURNAMENT, by itself, creates a new BEGINTOURNAMENT or raises the existing
%      singleton*.
%
%      H = BEGINTOURNAMENT returns the handle to a new BEGINTOURNAMENT or the handle to
%      the existing singleton*.
%
%      BEGINTOURNAMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEGINTOURNAMENT.M with the given input arguments.
%
%      BEGINTOURNAMENT('Property','Value',...) creates a new BEGINTOURNAMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beginTournament_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beginTournament_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beginTournament

% Last Modified by GUIDE v2.5 05-Dec-2016 18:18:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beginTournament_OpeningFcn, ...
                   'gui_OutputFcn',  @beginTournament_OutputFcn, ...
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


% --- Executes just before beginTournament is made visible.
function beginTournament_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beginTournament (see VARARGIN)

% Choose default command line output for beginTournament
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes beginTournament wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global tablePlayers_forTournament columnTable mat_HistoryMatch historyMatch historyMatch_tmp pairingTable columnTablePairing option

% User define
option.boolean_Round = 1;
option.winningPoint = 1;
option.losePoint    = 0;
option.tiePoint     = 0.5;
option.column2displayStanding = true(size(columnTable,2),1);
option.no_maxRound = 3;
option.no_round = 0;

% Set title
set(handles.figure1, 'Name', 'Tournament (by malganis35)');


updateListPlayers(hObject, eventdata, handles);

% Make a cross-table of already done match (such that a match cannot be 'redone')
nb_players = size(tablePlayers_forTournament,1);
mat_HistoryMatch = zeros(nb_players,nb_players);
[rankTable, playerIdTable, historyMatch, historyMatch_tmp, indexMat] = generateSubTable(nb_players, option.no_maxRound);

% Players for Tournament
tablePlayers_forTournament = [playerIdTable tablePlayers_forTournament rankTable];

% Initialize pairingTable
columnTablePairing = {'Flt', 'Round', 'Table', 'Player1', 'Points_P1', 'Player2', 'Points_P2', 'Result'};
pairingTable = table(...
               1,...
               1,...
               1,...
               {'temp'},...
               1,...
               {'temp'},...
               1,...
               {'temp'},...
               'VariableName', columnTablePairing);    
pairingTable(:,:) = [];

% Set functions for Table
set(handles.TAB_pairing, 'CellSelectionCallback',@(src, evnt)TAB_pairing_CellSelectionCallback(src, evnt, handles)); 
% set(handles.TAB_pairing, 'CellSelectionCallback',@cellSelect); 
% set(handles.TAB_pairing, 'CellSelectionCallback',@TAB_pairing_CellSelectionCallback); 



% --- Outputs from this function are returned to the command line.
function varargout = beginTournament_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in LIST_listPlayer.
function LIST_listPlayer_Callback(hObject, eventdata, handles)
% hObject    handle to LIST_listPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LIST_listPlayer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LIST_listPlayer


% --- Executes during object creation, after setting all properties.
function LIST_listPlayer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LIST_listPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CHECK_showPendingResult.
function CHECK_showPendingResult_Callback(hObject, eventdata, handles)
% hObject    handle to CHECK_showPendingResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CHECK_showPendingResult


% --- Executes on button press in BUT_printMenu.
function BUT_printMenu_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_printMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printpreview

% --- Executes on button press in BUT_playerHistory.
function BUT_playerHistory_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_playerHistory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in BUT_pair.
function BUT_pair_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_pair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tablePlayers_forTournament columnTable mat_HistoryMatch pairingTable columnTablePairing option pairingWSCode matchID match_record

if option.boolean_Round
    option.boolean_Round = 0;
    option.no_round = option.no_round+1;
    disp(['Create Pairing for Round no.' num2str(option.no_round)])
    % option.no_round = round;

    [matchID, pairingWSCode, mat_HistoryMatch] = swissRound (tablePlayers_forTournament, mat_HistoryMatch, option);

    disp('Display Pairing in UITable')
    pairingTable = matchID_2_pairingTable(tablePlayers_forTournament, pairingTable, pairingWSCode, option.no_round);
    data = table2cell(pairingTable(:,:));
    set(handles.TAB_pairing, 'data',data, 'ColumnName', columnTablePairing); 
    updateListPlayers(hObject, eventdata, handles); 
       
    nb_match = length(matchID);
    match_record = zeros(nb_match,1)+Inf;

else
    disp('You need to resolve all current matches first before starting a new round !!!')
    msgbox('You need to resolve all current matches first before starting a new round !!!', 'Error','error');
end
    
    
function EDIT_table_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_table as text
%        str2double(get(hObject,'String')) returns contents of EDIT_table as a double


% --- Executes during object creation, after setting all properties.
function EDIT_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in RADIO_unenteredResult.
function RADIO_unenteredResult_Callback(hObject, eventdata, handles)
% hObject    handle to RADIO_unenteredResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADIO_unenteredResult


% --- Executes on button press in RADIO_player1.
function RADIO_player1_Callback(hObject, eventdata, handles)
% hObject    handle to RADIO_player1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADIO_player1


% --- Executes on button press in RADIO_player2.
function RADIO_player2_Callback(hObject, eventdata, handles)
% hObject    handle to RADIO_player2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADIO_player2


% --- Executes on button press in RADIO_draw.
function RADIO_draw_Callback(hObject, eventdata, handles)
% hObject    handle to RADIO_draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADIO_draw


% --- Executes on button press in CHECK_dropPlayer1.
function CHECK_dropPlayer1_Callback(hObject, eventdata, handles)
% hObject    handle to CHECK_dropPlayer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CHECK_dropPlayer1


% --- Executes on button press in CHECK_dropPlayer2.
function CHECK_dropPlayer2_Callback(hObject, eventdata, handles)
% hObject    handle to CHECK_dropPlayer2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CHECK_dropPlayer2



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERSONAL ADDED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = updateListPlayers(hObject, eventdata, handles) 

global tablePlayers_forTournament option
% Set list
firstnames = table2cell(tablePlayers_forTournament(:,'name'));
lastnames = table2cell(tablePlayers_forTournament(:,'familyName'));
names = strcat(lastnames, {', '}, firstnames, {' ('}, num2str(option.no_round), ')');
names = sort(names);
set(handles.LIST_listPlayer, 'String', names)


function pairingTable = matchID_2_pairingTable(tablePlayers_forTournament, pairingTable, pairingWSCode, round)

list_WSCode = tablePlayers_forTournament.WSCode;
[m,n] = size(pairingWSCode);

for i = 1:m
    for j = 1:n
        code_i = pairingWSCode{i,j};
        id = strfind_idx( list_WSCode, code_i );
        firstnames = tablePlayers_forTournament.name(id);
        lastnames = tablePlayers_forTournament.familyName(id);
        names = strcat(lastnames, {', '}, firstnames);
        if j == 1
            pairingTable.Player1(i,1) = names;
            pairingTable.Points_P1(i,1) = tablePlayers_forTournament.Points(id);
        elseif j == 2
            pairingTable.Player2(i,1) = names;
            pairingTable.Points_P2(i,1) = tablePlayers_forTournament.Points(id);
        else
            error('Problem in pairingWSCode. Not of size 2')
        end
    end
end

pairingTable.Table = [1:m]';
pairingTable.Round = repmat(round,m,1);
pairingTable.Result = repmat('<pending>', m, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function MENU_tournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_tournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_adjustPairingManually_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_adjustPairingManually (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_resetCurrentRound_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_resetCurrentRound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_showStandings_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_showStandings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_exit_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_top2_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_top2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_top4_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_top4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_top8_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_top8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_otherTop_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_otherTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in TAB_pairing.
function TAB_pairing_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to TAB_pairing (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

global pairingWSCode tablePlayers_forTournament pairingTable

cellSelect(hObject, eventdata)

UITable = 'TAB_pairing';
[ data, rows] = getCellSelect( UITable );

player1 = pairingWSCode(rows,1);
namePlayer1 = data{rows,4};
player2 = pairingWSCode(rows,2);
namePlayer2 = data{rows,6};
table = pairingTable.Table(rows);

set(handles.EDIT_table, 'String', table)
set(handles.TEXT_player1, 'String', namePlayer1)
set(handles.TEXT_player2, 'String', namePlayer2)




% --- Executes on button press in BUT_saveScore.
function BUT_saveScore_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_saveScore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tablePlayers_forTournament historyMatch_tmp match_record matchID option

table = str2num(handles.EDIT_table.String);

% Store in match_record
if handles.RADIO_unenteredResult.Value == 1
    % do nothing
elseif handles.RADIO_draw.Value == 1
    % draw
    match_record(table,1) = 3;
elseif handles.RADIO_player1.Value == 1
    % Player 1 win
    match_record(table,1) = 1;
elseif handles.RADIO_player2.Value == 1
    % Player 2 win
    match_record(table,1) = 2;
else
    error('Problem. There is no 1 in any boutton radio')
end

% Store in historyMatch_tmp
lin1 = find(tablePlayers_forTournament.playerId == matchID(table,1));
lin2 = find(tablePlayers_forTournament.playerId == matchID(table,2));
player1 = tablePlayers_forTournament.name(lin1);
player2 = tablePlayers_forTournament.name(lin2);
WSCode1 = tablePlayers_forTournament.WSCode(matchID(table,1));
WSCode2 = tablePlayers_forTournament.WSCode(matchID(table,2));

historyMatch_tmp.Player1(table,1) = cellstr(player1);
historyMatch_tmp.Player2(table,1) = cellstr(player2);
historyMatch_tmp.WSCode1(table,1) = cellstr(WSCode1);
historyMatch_tmp.WSCode2(table,1) = cellstr(WSCode2);
historyMatch_tmp.Round(table,1) = option.no_round;
historyMatch_tmp.winner(table,1) = match_record(table,1);

% Check if all results have been given

if isempty(find(isinf(match_record)==1)) == 1
    option.boolean_Round = 1;
    computeScore();
end


% --- Executes on button press in BUT_showStandings.
function BUT_showStandings_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_showStandings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tablePlayers_forTournament
tablePlayers_forTournament
standingGUI


function computeScore(hObject, eventdata, handles)
global tablePlayers_forTournament historyMatch_tmp historyMatch matchID option match_record round

% Assign scores
for i = 1:size(historyMatch_tmp,1)    
    tablePlayers_forTournament = assignScores(tablePlayers_forTournament, matchID, match_record, i, option );
end

historyMatch = [historyMatch; historyMatch_tmp];

% Sort the data : 1st time
column2sort = {'Points', 'Modified_Median', 'Solkoff', 'Cumulative_Score', 'first_Loss', 'name'};
sortType = {'descend', 'descend', 'descend', 'descend', 'descend', 'ascend'};
tablePlayers_forTournament = sortrows(tablePlayers_forTournament,column2sort,sortType);


% Compute Solkoff or Buchholz points
typeSolkoff_buchholz = 'median';
tablePlayers_forTournament = Solkoff_buchholz_Compute (historyMatch, tablePlayers_forTournament, typeSolkoff_buchholz, option.no_maxRound);

% Determine if 1st Loss and store it
tablePlayers_forTournament = firstLoss(tablePlayers_forTournament, historyMatch_tmp);

% Store cumulative score
tablePlayers_forTournament = Cumulative_Tie_break (tablePlayers_forTournament, round);

% 3.4- Make the ranking
disp('** Making the ranking');

% Sort the data : 2nd time
tablePlayers_forTournament = sortrows(tablePlayers_forTournament,column2sort,sortType);

% Assign ranking
column2check = {'Points', 'Modified_Median', 'Cumulative_Score', 'Solkoff'};
tablePlayers_forTournament = assignRanking(tablePlayers_forTournament,column2check);
