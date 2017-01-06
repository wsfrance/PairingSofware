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

% Last Modified by GUIDE v2.5 28-Dec-2016 17:10:07

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
% uiwait(handles.beginTournament);


disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Tournament Run')
disp('Author: malganis35')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

global TABLE MATRICE option

% Set title
set(handles.beginTournament, 'Name', 'Tournament (by malganis35)');

if option.bool_Tournamentstarted == 0
    % Update the list of players in handles.LIST_listPlayer
    updateListPlayers(hObject, eventdata, handles);

    % Make a cross-table of already done match (such that a match cannot be 'redone')
    nb_players               = size(TABLE.tablePlayers_forTournament,1);
    MATRICE.mat_HistoryMatch = zeros(nb_players,nb_players);
    [rankTable, playerIdTable, TABLE.historyMatch, TABLE.historyMatch_tmp, indexMat] = generateSubTable(nb_players, option.no_maxRound);

    MATRICE.HistoryTABLE = cell(option.no_maxRound,2);

    % Players for Tournament
    TABLE.tablePlayers_forTournament = [playerIdTable TABLE.tablePlayers_forTournament rankTable];

    % Show in Standing GUI
    columnTable = TABLE.tablePlayers_forTournament.Properties.VariableNames;
    option.Bool_column2displayStanding = true(size(columnTable,2),1);
    option.column2displayStandingALL = TABLE.tablePlayers_forTournament.Properties.VariableNames;
    option.column2displayStanding = option.column2displayStandingALL;
    
    % Initialize pairingTable
    TABLE.pairingTable = table(1,1,1,{'temp'},1,{'temp'},1,{'temp'},...
                                'VariableName', option.columnTablePairing);    
    TABLE.pairingTable(:,:) = [];

    % Set functions for Table
    set(handles.TAB_pairing, 'CellSelectionCallback',@(src, evnt)TAB_pairing_CellSelectionCallback(src, evnt, handles)); 
    % set(handles.TAB_pairing, 'CellSelectionCallback',@cellSelect); 
    % set(handles.TAB_pairing, 'CellSelectionCallback',@TAB_pairing_CellSelectionCallback); 

    % % Center alignment
    % Table = findjobj(handles.TAB_pairing); %findjobj is in the file exchange
    % table1 = get(Table,'Viewport');
    % jtable = get(table1,'View');
    % renderer = jtable.getCellRenderer(2,2);
    % renderer.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
    % renderer.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
end

option.bool_Tournamentstarted = 1;
option.typeRound = 'Round';

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

global TABLE option

% Check is box of CHECK_showPendingResult is checked or not
bool_check = handles.CHECK_showPendingResult.Value;
if bool_check
    % Checkbox is checked
    disp('Select and show pending results (Tables) only')
    id = strfind_idx( TABLE.pairingTable.Result, '<pending>', option.caseInsensitiveOption );
    data = table2cell(TABLE.pairingTable(id,:));
else
    % Checkbox is not checked
    disp('Show all results (Tables)')
    data = table2cell(TABLE.pairingTable(:,:)); 
end
set(handles.TAB_pairing, 'data', data, 'ColumnName', option.columnTablePairing); 


% --- Executes on button press in BUT_printMenu.
function BUT_printMenu_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_printMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% printpreview

global TABLE option

handlesFigure = handles.beginTournament;
[ InterfaceObj, oldpointer ] = turnOffGUI( handlesFigure, option );

% Export to XLS
path = pwd;
filename = [path '/export/Pairing_Round_' num2str(option.no_round) '.xls'];
filename2 = [path '/export/Pairing_Round_' num2str(option.no_round) '.pdf'];
T = TABLE.pairingTable;
column = option.columnTablePairing;
exportTable2CSV( T, filename, column)

export_XLS2PDF(filename, filename2, option)

turnOnGUI( handlesFigure, InterfaceObj, oldpointer, option );


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

global TABLE MATRICE option 

% Pairing of players
switch option.typeRound
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Round'
        if option.no_round < option.no_maxRound
            if option.boolean_Round
                option.no_round         = option.no_round+1; % Incremente number of rounds
                disp(['Create Pairing for Round no.' num2str(option.no_round)])
                [MATRICE.matchID, MATRICE.pairingWSCode, MATRICE.mat_HistoryMatch] = swissRound (TABLE.tablePlayers_forTournament, MATRICE.mat_HistoryMatch, option);

                % display pairing table
                displayPairingTable(hObject, eventdata, handles)

            else
                msg = 'You need to resolve all current matches first before starting a new round !!!';
                disp(msg)
                msgbox(msg, 'Error','error');
            end
        else
            msg = 'You have reached the maximum number of rounds. Go now to Top';
            disp(msg)
            msgbox(msg)
        end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    case 'Top'
        
        TABLE.tablePlayers_FINAL = TABLE.tablePlayers_forTournament;
        TABLE.tablePlayers_forTournament = TABLE.tablePlayers_forTournament(1:option.topX,:);
        TABLE.tablePlayers_forTournament.Points = zeros(option.topX,1);
        [MATRICE.matchID, MATRICE.pairingWSCode, MATRICE.mat_HistoryMatch] = singleElimination (TABLE.tablePlayers_forTournament, MATRICE.mat_HistoryMatch);
        TABLE.historyMatch_tmp(:,:) = [];
        displayPairingTable(hObject, eventdata, handles)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    otherwise        
         msg = 'Not implemented yet';
         disp(msg)
         msgbox(msg,'Error','error')
end


function displayPairingTable(hObject, eventdata, handles)

global TABLE MATRICE option    
    
disp('Display Pairing in UITable')
TABLE.pairingTable = matchID_2_pairingTable(TABLE.tablePlayers_forTournament, TABLE.pairingTable, MATRICE.pairingWSCode, option.no_round);
data = table2cell(TABLE.pairingTable(:,:));
set(handles.TAB_pairing, 'data',data, 'ColumnName', option.columnTablePairing);
updateListPlayers(hObject, eventdata, handles);

% Create matrice match_record to store results
nb_match = length(MATRICE.matchID);
MATRICE.match_record = zeros(nb_match,1)+Inf;

option.boolean_Round    = 0;  % Boolean to avoid new round if not all results have been given


    
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
BUT_saveScore_Callback(hObject, eventdata, handles)

% --- Executes on button press in RADIO_player1.
function RADIO_player1_Callback(hObject, eventdata, handles)
% hObject    handle to RADIO_player1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADIO_player1
BUT_saveScore_Callback(hObject, eventdata, handles)


% --- Executes on button press in RADIO_player2.
function RADIO_player2_Callback(hObject, eventdata, handles)
% hObject    handle to RADIO_player2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADIO_player2
BUT_saveScore_Callback(hObject, eventdata, handles)

% --- Executes on button press in RADIO_draw.
function RADIO_draw_Callback(hObject, eventdata, handles)
% hObject    handle to RADIO_draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADIO_draw
BUT_saveScore_Callback(hObject, eventdata, handles)

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

global TABLE MATRICE option

disp(['Going to Top 2 (Final)'])
topX = 2;
TABLE.tablePlayers_FINAL = TABLE.tablePlayers_forTournament;
TABLE.tablePlayers_forTournament = TABLE.tablePlayers_forTournament(1:topX,:);
[MATRICE.matchID, MATRICE.pairingWSCode, MATRICE.mat_HistoryMatch] = singleElimination (TABLE.tablePlayers_forTop, MATRICE.mat_HistoryMatch, option, topX);


% --------------------------------------------------------------------
function MENU_top4_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_top4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option

disp(['Going to Top 4 (Semi-finals)'])
topX = 4;
TABLE.tablePlayers_FINAL = TABLE.tablePlayers_forTournament;
TABLE.tablePlayers_forTournament = TABLE.tablePlayers_forTournament(1:topX,:);
[MATRICE.matchID, MATRICE.pairingWSCode, MATRICE.mat_HistoryMatch] = singleElimination (TABLE.tablePlayers_forTop, MATRICE.mat_HistoryMatch, option, topX);


% --------------------------------------------------------------------
function MENU_top8_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_top8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option

disp(['Going to Top 8 (Quarter finals)'])
option.topX = 8;
option.typeRound = 'Top';
BUT_pair_Callback(hObject, eventdata, handles)




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

global MATRICE 

% Return selection of a cell in the Table in a callback
cellSelect(hObject, eventdata)

UITable = 'TAB_pairing';
[ data, rows] = getCellSelect( UITable );

% Convert rows to Table (if pending)
no_table = data{rows, 3};

switch MATRICE.match_record(no_table,1)
    case 1
        set(handles.RADIO_player1,'Value', 1);
    case 2
        set(handles.RADIO_player2,'Value', 1);
    case 3
        set(handles.RADIO_draw,'Value', 1);
    case Inf
        set(handles.RADIO_unenteredResult,'Value', 1);
    otherwise
        error('MATRICE.match_record(rows,1) not known')
end    

% Determine player 1, player 2 and their table
player1 = MATRICE.pairingWSCode(rows,1);
namePlayer1 = data{rows,4};
player2 = MATRICE.pairingWSCode(rows,2);
namePlayer2 = data{rows,6};
% table = TABLE.pairingTable.Table(rows);
table = handles.TAB_pairing.Data(rows,3);
% Display in the TEXT boxes
set(handles.EDIT_table, 'String', table)
set(handles.TEXT_player1, 'String', namePlayer1)
set(handles.TEXT_player2, 'String', namePlayer2)




% --- Executes on button press in BUT_saveScore.
function BUT_saveScore_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_saveScore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option

if option.boolean_Round == 0
    % all scores has not been added
    % Save records of the match
    table = str2num(handles.EDIT_table.String{1});

    % Store in match_record
    if handles.RADIO_unenteredResult.Value == 1
        % do nothing
        score = '<pending>';
        MATRICE.match_record(table,1) = Inf;
    elseif handles.RADIO_draw.Value == 1
        % draw
        MATRICE.match_record(table,1) = 3;
        score = '0-0';
    elseif handles.RADIO_player1.Value == 1
        % Player 1 win
        MATRICE.match_record(table,1) = 1;
        score = '1-0';
    elseif handles.RADIO_player2.Value == 1
        % Player 2 win
        MATRICE.match_record(table,1) = 2;
        score = '0-1';
    else
        error('Problem. There is no 1 in any boutton radio')
    end

    TABLE.pairingTable.Result(table) = {score};
    
    % Store in historyMatch_tmp
    lin1 = find(TABLE.tablePlayers_forTournament.playerId == MATRICE.matchID(table,1));
    lin2 = find(TABLE.tablePlayers_forTournament.playerId == MATRICE.matchID(table,2));
    player1 = TABLE.tablePlayers_forTournament.name(lin1);
    player2 = TABLE.tablePlayers_forTournament.name(lin2);
    WSCode1 = TABLE.tablePlayers_forTournament.WSCode(lin1);   
    WSCode2 = TABLE.tablePlayers_forTournament.WSCode(lin2);

    TABLE.historyMatch_tmp.Player1(table,1) = cellstr(player1);
    TABLE.historyMatch_tmp.Player2(table,1) = cellstr(player2);
    TABLE.historyMatch_tmp.WSCode1(table,1) = cellstr(WSCode1);
    TABLE.historyMatch_tmp.WSCode2(table,1) = cellstr(WSCode2);
    TABLE.historyMatch_tmp.Round(table,1) = option.no_round;
    TABLE.historyMatch_tmp.winner(table,1) = MATRICE.match_record(table,1);

    CHECK_showPendingResult_Callback(hObject, eventdata, handles);
    
    
    % Check if all results have been given
    if isempty(find(isinf(MATRICE.match_record)==1)) == 1
        option.boolean_Round = 1;
        if option.no_round == 1
            MATRICE.HistoryTABLE{1,1} = 0;
            MATRICE.HistoryTABLE{1,2} = TABLE.tablePlayers_forTournament;
        end
        computeScore();
        MATRICE.HistoryTABLE{option.no_round+1,1} = option.no_round;
        MATRICE.HistoryTABLE{option.no_round+1,2} = TABLE.tablePlayers_forTournament;
    end
else
    % msg = 'You have already entered all the scores. Go to next round !!';
    % disp(msg)
    % msgbox(msg,'Error','error')
    option.boolean_Round = 0;
    TABLE.tablePlayers_forTournament = MATRICE.HistoryTABLE{option.no_round,2}; % reload previous TABLE in the data
    BUT_saveScore_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in BUT_showStandings.
function BUT_showStandings_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_showStandings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TABLE

TABLE.tablePlayers_forTournament
standingGUI


function computeScore(hObject, eventdata, handles)
global TABLE MATRICE option

% Assign scores
for i = 1:size(TABLE.historyMatch_tmp,1)    
    TABLE.tablePlayers_forTournament = assignScores(TABLE.tablePlayers_forTournament, MATRICE.matchID, MATRICE.match_record, i, option );
end

TABLE.historyMatch = [TABLE.historyMatch; TABLE.historyMatch_tmp];

% Sort the data : 1st time
TABLE.tablePlayers_forTournament = sortrows(TABLE.tablePlayers_forTournament,option.column2sort,option.sortType);


% Compute Solkoff or Buchholz points
typeSolkoff_buchholz = 'median';
TABLE.tablePlayers_forTournament = Solkoff_buchholz_Compute (TABLE.historyMatch, TABLE.tablePlayers_forTournament, typeSolkoff_buchholz, option.no_maxRound);

% Determine if 1st Loss and store it
TABLE.tablePlayers_forTournament = firstLoss(TABLE.tablePlayers_forTournament, TABLE.historyMatch_tmp);

% Store cumulative score
TABLE.tablePlayers_forTournament = Cumulative_Tie_break (TABLE.tablePlayers_forTournament, option.no_round);

% Compute Bushi Points
[ TABLE.tablePlayers_forTournament ] = bushi_points( MATRICE.mat_HistoryMatch, TABLE.tablePlayers_forTournament, option.no_round, option.no_maxRound );

% 3.4- Make the ranking
disp('** Making the ranking');

% Sort the data : 2nd time
TABLE.tablePlayers_forTournament = sortrows(TABLE.tablePlayers_forTournament,option.column2sort,option.sortType);

% Assign ranking
TABLE.tablePlayers_forTournament = assignRanking(TABLE.tablePlayers_forTournament,option.column2sort);


% --- Executes on button press in BUT_startTimer.
function BUT_startTimer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_startTimer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stopwatch;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERSONAL ADDED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = updateListPlayers(hObject, eventdata, handles) 

global TABLE option
% Set list
firstnames  = table2cell(TABLE.tablePlayers_forTournament(:,'name'));
lastnames   = table2cell(TABLE.tablePlayers_forTournament(:,'familyName'));
names       = strcat(lastnames, {', '}, firstnames, {' ('}, num2str(option.no_round), ')');
names       = sort(names); % Sort name by alphabetical order
set(handles.LIST_listPlayer, 'String', names)


function pairingTable = matchID_2_pairingTable(tablePlayers_forTournament, pairingTable, pairingWSCode, round)

global option

% Convert matchID to Pairing Table containing the name of players
list_WSCode = tablePlayers_forTournament.WSCode;
[m,n] = size(pairingWSCode);

pairingTable(:,:) = [];

% Loop for all pairings
for i = 1:m
    for j = 1:n
        % Search names
        code_i      = pairingWSCode{i,j};
        id          = strfind_idx( list_WSCode, code_i, option.caseInsensitiveOption );
        firstnames  = tablePlayers_forTournament.name(id);
        lastnames   = tablePlayers_forTournament.familyName(id);
        names       = strcat(lastnames, {', '}, firstnames);
        if j == 1
            % Player 1
            pairingTable.Player1(i,1) = names;
            pairingTable.Points_P1(i,1) = tablePlayers_forTournament.Points(id);
        elseif j == 2
            % Player 2
            pairingTable.Player2(i,1) = names;
            pairingTable.Points_P2(i,1) = tablePlayers_forTournament.Points(id);
        else
            error('Problem in pairingWSCode. Not of size 2')
        end
    end
end

% Set default options of pairingTable
pairingTable.Table = [1:m]';
pairingTable.Round = repmat(round,m,1);
pairingTable.Result = repmat({'<pending>'}, m, 1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in BUT_sendPairing.
function BUT_sendPairing_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_sendPairing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option

% For each table, find player in DB and send mail
for i = 1:size(MATRICE.pairingWSCode,1)
        wscode_p1 = MATRICE.pairingWSCode{i,1};
        wscode_p2 = MATRICE.pairingWSCode{i,2};
        % find ws code in the DB
        Index1 = strfind_idx( TABLE.tablePlayers_forTournament.WSCode, wscode_p1, option.caseInsensitiveOption );
        Index2 = strfind_idx( TABLE.tablePlayers_forTournament.WSCode, wscode_p2, option.caseInsensitiveOption );
        name1 = TABLE.tablePlayers_forTournament.name(Index1);
        name2 = TABLE.tablePlayers_forTournament.name(Index2);
        % recipients = {'caotri.do88@gmail.com'};
        recipients1 = TABLE.tablePlayers_forTournament.email(Index1);
        recipients2 = TABLE.tablePlayers_forTournament.email(Index2);
        subject     = ['Tournament xxx Round no.' num2str(option.no_round) ' - Your Table : ' num2str(i)];
        message1    = ['Dear ' name1{1} ',' 10 10 ...
                        'Your new opponent (' name2{1} ') is ready' 10 ...
                        'Go to Table no. ' num2str(i) 10 10 ...
                        'And do not forget to have fun !!!'];      
                    
        message2    = ['Dear ' name2{1} ',' 10 10 ...
                        'Your new opponent (' name1{1} ') is ready' 10 ...
                        'Go to Table no. ' num2str(i) 10 10 ...
                        'And do not forget to have fun !!!'];            
        try                                
            send_msg(recipients1, subject, message1)
            disp(['SUCCESS: Message sent to ' recipients1{1}])
        catch
            disp(['FAIL: Message sent to ' recipients1{1}])
        end
        
        try
            send_msg(recipients2, subject, message2)
            disp(['SUCCESS: Message sent to ' recipients2{1}])
        catch
            disp(['FAIL: Message sent to ' recipients2{1}])
        end
end

