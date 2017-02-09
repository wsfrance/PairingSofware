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

% Last Modified by GUIDE v2.5 09-Feb-2017 11:36:08

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

global TABLE MATRICE option timer

disp('--------------------------------------------------------------------')
disp('Start the Tournament Core')

% Set title
disp('- Set the title of the window')
set(handles.beginTournament, 'Name', 'Tournament (by malganis35)');


disp('- Look if we start from a save file or a new tournament')
if option.bool_Tournamentstarted == 0
    
    % ask the number of rounds
    disp('- Ask the number of rounds')
    answer = askNbRounds();
    option.no_maxRound = str2num(answer);

    % disp('- Get IP and Mac Adress')
    % [option.UserInfo.MyExternalIP, option.UserInfo.linkIPLocation, option.UserInfo.mac, option.UserInfo.bool_getIP] = getIPandMAC();
    
    disp('-- This is a new tournament. Set boolean to 1 and typeRound = Round')
    option.bool_Tournamentstarted = 1;
    option.typeRound = 'Round';
    
    % Check the numbers of players
    [ TABLE.tablePlayers_forTournament, option.tmp.bool_byePlayer ] = createByePlayer( TABLE.tablePlayers_forTournament );
    
    % Make a cross-table of already done match (such that a match cannot be 'redone')
    disp('-- Initialize the subTables and a Matrice to store already done match (such that a match cannot be re-done)')
    nb_players               = size(TABLE.tablePlayers_forTournament,1);
    MATRICE.mat_HistoryMatch = zeros(nb_players,nb_players);
    [rankTable, playerIdTable, TABLE.historyMatch, TABLE.historyMatch_tmp, indexMat] = generateSubTable(nb_players, option.no_maxRound);
    TABLE.historyMatch_tmp_allocation = {'inf' 'inf' 'inf' 'inf' inf inf};
    
    % Players for Tournament
    disp('-- Initialize the table tablePlayers_forTournament')
    TABLE.tablePlayers_forTournament = [playerIdTable TABLE.tablePlayers_forTournament rankTable];

    % Show in Standing GUI
    disp('-- Set the option of columns to display')
    columnTable = TABLE.tablePlayers_forTournament.Properties.VariableNames;
    option.Bool_column2displayStanding = true(size(columnTable,2),1);
    option.column2displayStandingALL = TABLE.tablePlayers_forTournament.Properties.VariableNames;
    option.column2displayStanding = option.column2displayStandingALL;
    
    % Initialize pairingTable
    disp('-- Initialize the table pairingTable and its allocation')
    TABLE.pairingTable_allocation = {inf inf inf 'inf, inf' inf 'inf, inf' inf []};
    TABLE.pairingTable = table(1,1,1,{'temp'},1,{'temp'},1,{'temp'},...
                                'VariableName', option.columnTablePairing);    
    TABLE.pairingTable(:,:) = [];
    

    % Initialize HistoryTable : store the standing at each round
    disp('-- Initialize the table HistoryTable to store the standing at each round')
    TABLE.HistoryTABLE = table(0,{option.typeRound}, {TABLE.tablePlayers_forTournament},'VariableName', {'no_Round', 'typeOfRound', 'standing'});  
    TABLE.HistoryTABLE_allocation = {inf 'inf' []};
    % nb_allocation = option.no_round + 3;
    % [TABLE.HistoryTABLE] = tableAllocation(nb_allocation, TABLE.HistoryTABLE, TABLE.HistoryTABLE_allocation);
    % TABLE.HistoryTABLE(:,:) = []; 
    
    TABLE.HistoryTABLE.no_Round(1,1)      = 0;
    TABLE.HistoryTABLE.typeOfRound{1,1}   = option.typeRound;
    TABLE.HistoryTABLE.standing{1,1}      = TABLE.tablePlayers_forTournament;
    
    
    
    disp('- Visibility Off')
    mode = 'Off';
    visibilityOnOff(handles, mode)
    
    
    
else
    
    disp('- Automatic load from save file')
    disp('- Display the pairing table in the GUI')
    % displayPairingTable(hObject, eventdata, handles)
    CHECK_showPendingResult_Callback(hObject, eventdata, handles);
    set(handles.EDIT_table, 'String', 1)
    EDIT_table_Callback(hObject, eventdata, handles)
    
end

% Save state automatically
disp('- Save state automatically of the GUI')
timer.c = saveState(option.periodOfSave);

% Update the list of players in handles.LIST_listPlayer
disp('-- Update the list of Players in the handles.LIST_listPlayer')
updateListPlayers(hObject, eventdata, handles);

% Set functions for Table
disp('-- Set the callbacks of the tables')
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



function answer = askNbRounds()
bool_Notnumber = true;
while bool_Notnumber
    
    prompt      = {'Enter the number of desired rounds (default: 6) (NB: you can go to Top before)'};
    dlg_title   = 'Question : Number of rounds';
    num_lines   = 1;
    defaultans  = {'6'};
    answer      = inputdlg(prompt,dlg_title,num_lines,defaultans);
    answer      = answer{1};
    if all(ismember(answer, '0123456789+-.eEdD')) == 1
        msg = '- This a number. Continue ...';
        disp(msg)
        bool_Notnumber = false;
    else
        msg = '- This is not a number. Go again ...';
        bool_Notnumber = true;
        disp(msg)
        msgbox(msg,'Error','error');
    end
end

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

% futureFunctionalityMsg(handles)

global TABLE option

% Check is box of CHECK_showPendingResult is checked or not
% bool_check = handles.CHECK_showPendingResult.Value;
bool_check = false;
disp('CHECK_showPendingResult_Callback added in the future')
if bool_check
    % Checkbox is checked
    disp('- Select and show pending results (Tables) only')
    id = strfind_idx( TABLE.pairingTable.Result, '<pending>', option.caseInsensitiveOption );
    data = table2cell(TABLE.pairingTable(id,:));
else
    % Checkbox is not checked
    disp('- Show all results (Tables)')
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

% handlesFigure = handles.beginTournament;
% [ InterfaceObj, oldpointer ] = turnOffGUI( handlesFigure, option );

h = waitbar(0.50,'Export the pairing in .XLS and .PDF. Please wait ...');

disp('--------------------------------------------------------------------')
disp('Export the pairing in .XLS and .PDF')

path        = pwd;
filenamehtml= [path '/export/Pairing_Round_' num2str(option.no_round) '.html'];
filename    = [path '/export/Pairing_Round_' num2str(option.no_round) '.xls'];
filename2   = [path '/export/Pairing_Round_' num2str(option.no_round) '.pdf'];
T           = TABLE.pairingTable;
column      = option.columnTablePairing;

disp('- Quit the Application')
quitApplication ();

disp('- Delete files if they exist')
if exist(filename, 'file') == 2
    delete(filename)
end

if exist(filename2, 'file') == 2
    delete(filename2)
end

try
    % Export to XLS
    disp('- Export the Tables in .xls')
    exportTable2CSV( T, filename, column, option);

    % Export to PDF
    disp('- Export the Tables in .pdf')
    export_XLS2PDF(filename, filename2, option);
       
catch
    % Export in HTML
    disp('- Export the Tables in .html')
    exportTable2html( T, filenamehtml, column, option);
    
    % Open in Internet explorer
    % url = 'http://www.ws-france.fr';
    web(filenamehtml,'-browser')
    
end



% turnOnGUI( handlesFigure, InterfaceObj, oldpointer, option );
close(h)

% --- Executes on button press in BUT_playerHistory.
function BUT_playerHistory_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_playerHistory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg( handles )



% --- Executes on button press in BUT_pair.
function BUT_pair_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_pair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option 

disp('--------------------------------------------------------------------')
disp('Start the function to pair players')



% Pairing of players
switch option.typeRound
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Round'
        disp('Save the actual Table of tournament for replay')
        % saveHistoryTABLE([]);
        if option.no_round+1 <= option.no_maxRound
            % Incremente number of rounds
            disp('- Incremente number of rounds')
            option.no_round = option.no_round + 1;
            if option.boolean_Round
                
                disp('- Visibility ON')
                mode = 'On';
                visibilityOnOff(handles, mode)

                disp('- Reset option.tmp.compteur_computeScore to 0')
                option.tmp.compteur_computeScore = 0;
                disp(['- Create Pairing for Round no.' num2str(option.no_round)])
                [MATRICE.matchID, MATRICE.pairingWSCode, MATRICE.mat_HistoryMatch] = swissRound (TABLE.tablePlayers_forTournament, MATRICE.mat_HistoryMatch, option);
                
                % Allocate TABLE.historyMatch_tmp
                disp('- Allocate TABLE.historyMatch_tmp')
                nb_match = size(MATRICE.matchID,1);
                TABLE.historyMatch_tmp = tableAllocation(nb_match, TABLE.historyMatch_tmp, TABLE.historyMatch_tmp_allocation);
                
                % display pairing table
                disp('- Display the pairing table in the GUI')
                displayPairingTable(hObject, eventdata, handles)
                option.boolean_Round = false;  % Boolean to avoid new round if not all results have been given
            else
                msg = 'You need to resolve all current matches first before starting a new round !!!';
                handles_i = handles.TXT_error;
                prefix = '- ';
                displayErrorMsg( msg, handles_i, prefix )
                option.no_round = option.no_round - 1;
            end
        else
            msg = 'You have reached the maximum number of rounds. Go now to Top';
            handles_i = handles.TXT_error;
            prefix = '- ';
            displayErrorMsg( msg, handles_i, prefix )
            option.no_round = option.no_round - 1;
        end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    case 'Top'
        if option.boolean_Round
            disp('- Reset option.tmp.compteur_computeScore to 0')
            option.tmp.compteur_computeScore = 0;
            
            % Save the current standing to the right place in HistoryTABLE
            if option.no_top == 1
                % New type
                option.column2sort = ['PointsOfTop' option.column2sort];
                option.sortType    = ['descend' option.sortType];
                % First round of the top
                disp('- 1st round of the top')
                TABLE.tablePlayers_forTournament = TABLE.tablePlayers_forTournament(1:option.topX,:); 
                % Reset PointsOfTop to zero
                zeroMat = zeros(option.topX,1);
                TABLE.tablePlayers_forTournament.PointsOfTop = zeroMat;
            else
                disp('- NOT 1st round of the top')
                disp('- Save table of standings of previous round')
                option.topX = option.topX/2;
                TABLE.tablePlayers_forTournament = TABLE.tablePlayers_forTournament(1:option.topX,:);                 
            end
            
            % Pairing or not of the players
            if size(TABLE.tablePlayers_forTournament) > 1
                % Incremente number of rounds
                disp('- Incremente number of rounds')
                option.no_round = option.no_round + 1;
                % If there is more players, continue to make a pairing
                disp('- Pair the players by Single elimination')
                % TABLE.tablePlayers_forTournament.Points = zeros(size(TABLE.tablePlayers_forTournament,1),1);
                [MATRICE.matchID, MATRICE.pairingWSCode, MATRICE.mat_HistoryMatch] = singleElimination (TABLE.tablePlayers_forTournament, MATRICE.mat_HistoryMatch, option);
                TABLE.historyMatch_tmp(:,:) = [];
                
                disp('- Display the pairing table in the GUI')
                displayPairingTable(hObject, eventdata, handles)
                
                disp('- Incremente option.no_top by 1')
                option.no_top = option.no_top+1;
                option.boolean_Round = false;  % Boolean to avoid new round if not all results have been given
            else
                % There is only 1 player left in the tournament. Finish the
                % tournament
                msg = 'You have finished the tournament. Send now the report (Go to MENU Send --> Send Report) !';
                handles_i = handles.TXT_error;
                prefix = '- ';
                displayErrorMsg( msg, handles_i, prefix )
                % Delete the last save
                % TABLE.HistoryTABLE(end,:) = [];
                option.boolean_Round = true;
                disp('- Visibility Off')
                mode = 'Off';
                visibilityOnOff(handles, mode)
            end
        else
            msg = 'You need to resolve all current matches first before starting a new round !!!';
            handles_i = handles.TXT_error;
            prefix = '- ';
            displayErrorMsg( msg, handles_i, prefix )
            option.no_round = option.no_round - 1;
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    otherwise        
         msg = 'Not implemented yet';
         handles_i = handles.TXT_error;
         prefix = '- ';
         displayErrorMsg( msg, handles_i, prefix )        
         % disp(['- ' msg])
         % msgbox(msg,'Error','error')
         option.no_round = option.no_round - 1;
end

% Create matrice match_record to store results
disp('-- Create matrice match_record to store results')
nb_match             = size(MATRICE.matchID,1);
MATRICE.match_record = zeros(nb_match,1)+inf  ;
set2Table1(hObject, eventdata, handles)

% Automatically assign win to the player opposing the bye
disp('- Assign win to player against BYE')
automaticCheck_BYE_OfPairingTable(hObject, eventdata, handles, MATRICE.pairingWSCode)

% Display table 
% displayPairingTable(hObject, eventdata, handles)
disp('- Refresh the table of pairing')
CHECK_showPendingResult_Callback(hObject, eventdata, handles);


function automaticCheck_BYE_OfPairingTable(hObject, eventdata, handles, pairingWSCode)
% Automatically assign win to the player opposing the bye

    global TABLE MATRICE option

    [table, column] = strfind_idx(pairingWSCode, '**BYE**');

    if isempty(table) == 0
        % Extract information about the players
        disp('- Extract informations about the players')
        lin1 = find(TABLE.tablePlayers_forTournament.playerId == MATRICE.matchID(table,1));
        lin2 = find(TABLE.tablePlayers_forTournament.playerId == MATRICE.matchID(table,2));
        player1 = TABLE.tablePlayers_forTournament.name(lin1);
        player2 = TABLE.tablePlayers_forTournament.name(lin2);
        WSCode1 = TABLE.tablePlayers_forTournament.WSCode(lin1);   
        WSCode2 = TABLE.tablePlayers_forTournament.WSCode(lin2);

        % assign score
        disp('- Assign score according to BYE: 1-0, 0-0, or 0-1 ')
        score = assignScore4BYE(hObject, eventdata, handles, table, column);
        TABLE.pairingTable.Result(table) = {score};

        % Store in historyMatch_tmp
        disp('- Store the match in the record of the rounds (TABLE.historyMatch_tmp)')
        TABLE.historyMatch_tmp.Player1(table,1) = cellstr(player1);
        TABLE.historyMatch_tmp.Player2(table,1) = cellstr(player2);
        TABLE.historyMatch_tmp.WSCode1(table,1) = cellstr(WSCode1);
        TABLE.historyMatch_tmp.WSCode2(table,1) = cellstr(WSCode2);
        TABLE.historyMatch_tmp.Round(table,1) = option.no_round;
        TABLE.historyMatch_tmp.winner(table,1) = MATRICE.match_record(table,1);

        bool_radio = false;
        automaticWinAgainstBYE(hObject, eventdata, handles, WSCode1, WSCode2, bool_radio)
    else
        disp('No BYE Player detected.')
    end


    




function automaticWinAgainstBYE(hObject, eventdata, handles, WSCode1, WSCode2, bool_radio)
	disp('-- Checking if there is a **BYE** Player')

    if strcmp(WSCode1, '**BYE**') == 1
        msg = 'Automatic **BYE** Player was detected. Assigning WIN automatically the score to the player';
        handles_i = handles.TXT_error;
        prefix = '-- ';
        displayErrorMsg( msg, handles_i, prefix )
        disp('-- Player 1 is **BYE**')
        disp('-- Assigning Radio button automatically')
        if bool_radio
            set(handles.RADIO_player2, 'Value', 1)
        end
    elseif strcmp(WSCode2, '**BYE**') == 1
        msg = 'Automatic **BYE** Player was detected. Assigning WIN automatically the score to the player';
        handles_i = handles.TXT_error;
        prefix = '-- ';
        displayErrorMsg( msg, handles_i, prefix )
        disp('-- Player 2 is **BYE**')
        disp('-- Assigning Radio button automatically')
        if bool_radio
            set(handles.RADIO_player1, 'Value', 1)
        end
    else
        disp('-- There is no **BYE** player')
    end

function score = assignScore4BYE(hObject, eventdata, handles, table, column)
    % Assign score according to the button radio
    global MATRICE
    
    % Store in match_record
    disp('-- Checking the state of BYE player')
    if column == 2
        % Player 1 win
        MATRICE.match_record(table,1) = 1;
        score = '1-0';
    elseif column == 1
        % Player 2 win
        MATRICE.match_record(table,1) = 2;
        score = '0-1';
    else
        error('Problem. There is no 1 in any boutton radio')
    end
    disp(['-- The score is: ' score])

% --- Executes on button press in BUT_saveScore.
function BUT_saveScore_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_saveScore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option

if option.boolean_Round == 0
    % all scores has not been added
    disp('- All scores has not been added')
    % Save records of the match
    table = str2num(handles.EDIT_table.String{1});

    % Extract information about the players
    disp('- Extract informations about the players')
    lin1 = find(TABLE.tablePlayers_forTournament.playerId == MATRICE.matchID(table,1));
    lin2 = find(TABLE.tablePlayers_forTournament.playerId == MATRICE.matchID(table,2));
    player1 = TABLE.tablePlayers_forTournament.name(lin1);
    player2 = TABLE.tablePlayers_forTournament.name(lin2);
    WSCode1 = TABLE.tablePlayers_forTournament.WSCode(lin1);   
    WSCode2 = TABLE.tablePlayers_forTournament.WSCode(lin2);
    
    % assign score
    disp('- Assign score : 1-0, 0-0, or 0-1 according to the radio button')
    score = assignScoreAccording2RadioButton(hObject, eventdata, handles, table, WSCode1, WSCode2);
    TABLE.pairingTable.Result(table) = {score};
    
    % Store in historyMatch_tmp
    disp('- Store the match in the record of the rounds (TABLE.historyMatch_tmp)')
    TABLE.historyMatch_tmp.Player1(table,1) = cellstr(player1);
    TABLE.historyMatch_tmp.Player2(table,1) = cellstr(player2);
    TABLE.historyMatch_tmp.WSCode1(table,1) = cellstr(WSCode1);
    TABLE.historyMatch_tmp.WSCode2(table,1) = cellstr(WSCode2);
    TABLE.historyMatch_tmp.Round(table,1) = option.no_round;
    TABLE.historyMatch_tmp.winner(table,1) = MATRICE.match_record(table,1);
    
    % Display of the match
    disp('- Display the match (if only pending result or all results)')
    CHECK_showPendingResult_Callback(hObject, eventdata, handles);
    
    
    % Check if all results have been given
    if isempty(find(isinf(MATRICE.match_record)==1)) == 1
        option.boolean_Round = 1;
        computeScore(hObject, eventdata, handles);
    end
else
    option.boolean_Round = 0;
    id = find(TABLE.HistoryTABLE.no_Round==option.no_round-1);
    TABLE.tablePlayers_forTournament = TABLE.HistoryTABLE.standing{id}; % reload previous TABLE in the data
    BUT_saveScore_Callback(hObject, eventdata, handles)
end


function saveHistoryTABLE_afterMatch(table2sort)

global TABLE MATRICE option



function score = assignScoreAccording2RadioButton(hObject, eventdata, handles, table, WSCode1, WSCode2)
    % Assign score according to the button radio
    global MATRICE
    
    % Check for BYE player        
    bool_radio = true;
    automaticWinAgainstBYE(hObject, eventdata, handles, WSCode1, WSCode2, bool_radio)
    
    % Store in match_record
    disp('-- Checking the state of the button radio : pending, win Player1, win Player 2, draw')
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
    disp(['-- The score is: ' score])

    



% --- Executes on button press in BUT_showStandings.
function BUT_showStandings_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_showStandings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global TABLE

% TABLE.tablePlayers_forTournament
disp('--------------------------------------------------------------------')
disp('Display the Standing')
standingGUI




function [table2sort,player2top] = cutTable()
% Function to cut the number of player to the top
global TABLE
% Following rounds in the top (except the 1st cut)
disp('-- Cut first the number of players')
nb_players = size(TABLE.tablePlayers_forTournament,1);
% update future delete players
player2top = TABLE.tablePlayers_forTournament(1:nb_players/2,:);
player2update = TABLE.tablePlayers_forTournament(nb_players/2+1:end,:);
% table2sort = updateFinalTable(player2top, player2update);


% function table2sort = updateFinalTable(player2top, player2bottom)
% 
% global TABLE option
% 
% table2sort = TABLE.tablePlayers_FINAL;
% 
% % Sort the list of players
% % - Extract the ids of top, bottom and other
% id_top    = find( ismember(table2sort.WSCode, player2top.WSCode)    == 1);
% id_bottom = find( ismember(table2sort.WSCode, player2bottom.WSCode) == 1);
% all_wsCodeOfTop = [player2top.WSCode; player2bottom.WSCode];
% other_id  = find( ismember(table2sort.WSCode, all_wsCodeOfTop)    == 0);
% 
% % - Re-arrange ids of bottom depending on their score in rounds
% orderBottom_WSCode = sortrows(TABLE.tablePlayers_FINAL(id_bottom,:),option.column2sort,option.sortType);
% n = size(orderBottom_WSCode,1);
% id_bottom_sorted = zeros(n,1);
% for i = 1:n
%     id_bottom_sorted(i,1) = find( ismember(table2sort.WSCode, orderBottom_WSCode.WSCode(i)) == 1);
% end
% 
% % - Re-arrange the table
% id_sorted = [id_top; id_bottom_sorted; other_id];
% table2sort = table2sort(id_sorted,:);
% 
% % Assign ranking
% choice = 'advanced';
% switch choice
%     case 'simple'
%         table2sort.Ranking = [1:size(table2sort,1)]';
%     case 'advanced'
%         % Top
%         table1 = table2sort(id_top,:);
%         nb_top = size(table1,1);
%         table1.Ranking = ones(nb_top,1);
%         % Bottom
%         start_ranking = nb_top+1;
%         table2 = table2sort(id_bottom_sorted,:);
%         table2 = assignRanking(table2,option.column2sort, start_ranking);
%         % Other
%         start_ranking = nb_top + size(table2,1) +1;
%         table3 = table2sort(other_id,:);
%         table3 = assignRanking(table3,option.column2sort, start_ranking);
%         
%         table2sort = [table1; table2; table3];
% end
% % Store in the Table
% TABLE.tablePlayers_FINAL = table2sort;


function displayPairingTable(hObject, eventdata, handles)
% Diplay the TABLE.pairingTable in the GUI of tournament

global TABLE MATRICE option    

disp('-- Display the table')
TABLE.pairingTable = matchID_2_pairingTable(TABLE.tablePlayers_forTournament, TABLE.pairingTable, MATRICE.pairingWSCode, option.no_round);
data = table2cell(TABLE.pairingTable(:,:));
set(handles.TAB_pairing, 'data',data, 'ColumnName', option.columnTablePairing);

disp('-- Update the list of players')
updateListPlayers(hObject, eventdata, handles);


% --- Executes when selected cell(s) is changed in TAB_pairing.
function TAB_pairing_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to TAB_pairing (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% Return selection of a cell in the Table in a callback
cellSelect(hObject, eventdata)

UITable = 'TAB_pairing';
[ data, rows] = getCellSelect( UITable );

% Convert rows to Table (if pending)
no_table = data{rows, 3};
disp('Display Informations about the match')
displayInfoMatch(hObject, eventdata, handles, no_table, data, rows)



function displayInfoMatch(hObject, eventdata, handles, no_table, data, rows)

global MATRICE

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


    
function EDIT_table_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_table as text
%        str2double(get(hObject,'String')) returns contents of EDIT_table as a double

disp('--------------------------------------------------------------------')
disp('Display the chosen table')
no_table = str2double(get(handles.EDIT_table,'String'));
disp('Display the match Informations')

UITable = 'TAB_pairing';
[ data, rows] = getCellSelect( UITable );
rows = no_table;
if no_table <= size(data,1)
    displayInfoMatch(hObject, eventdata, handles, no_table, data, rows)
else
    msg = 'You have exceed the number of existing tables. Coming back to Table 1';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
    % disp(msg)
    % msgbox(msg,'Error','error')
    set2Table1(hObject, eventdata, handles)
end
    
function set2Table1(hObject, eventdata, handles)
% Set to table 1
table1 = 1;
set(handles.EDIT_table, 'String', table1)
EDIT_table_Callback(hObject, eventdata, handles)


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
futureFunctionalityMsg(handles)


% --- Executes on button press in CHECK_dropPlayer2.
function CHECK_dropPlayer2_Callback(hObject, eventdata, handles)
% hObject    handle to CHECK_dropPlayer2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CHECK_dropPlayer2
futureFunctionalityMsg(handles)


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
futureFunctionalityMsg(handles)

% --------------------------------------------------------------------
function MENU_resetCurrentRound_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_resetCurrentRound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)

% --------------------------------------------------------------------
function MENU_showStandings_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_showStandings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BUT_showStandings_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function MENU_exit_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% --------------------------------------------------------------------
function MENU_top2_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_top2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option
option.topX = 2;
go2Top(hObject, eventdata, handles)


% --------------------------------------------------------------------
function MENU_top4_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_top4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option
option.topX = 4;
go2Top(hObject, eventdata, handles)


% --------------------------------------------------------------------
function MENU_top8_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_top8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option
option.topX = 8;
go2Top(hObject, eventdata, handles)



function go2Top(hObject, eventdata, handles)

global TABLE option

switch option.topX
    case 2
        disp('Going to Top 2 (Finals)')
    case 4
        disp('Going to Top 4 (Semi-finals)')
    case 8
        disp('Going to Top 8 (Quarter finals)')
    otherwise
        disp('Other top or not known')
end

if size(TABLE.tablePlayers_forTournament,1)>=option.topX
    option.typeRound    = 'Top';
    option.no_top       = 1; % Set to 1st round of top
    BUT_pair_Callback(hObject, eventdata, handles)
else
    msg = 'Not enough player in the tournament to make a top 8. Lower the number of player in your top';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end

% --------------------------------------------------------------------
function MENU_otherTop_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_otherTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% futureFunctionalityMsg(handles)

global option
bool = false;

prompt      = 'Number of players in the Top (it has to be a power of 2)';

while bool == false
    % Ask for the new player
    
    dlg_title   = 'Question : Top Cut';
    num_lines   = 1;
    defaultans  = {'8'};
    answer      = inputdlg(prompt,dlg_title,num_lines, defaultans);
    if isempty(answer) == 0
        n = str2num(answer{1});
        bool = floor(log2(n))==log2(n);

        if bool
            option.topX = answer{1};
            go2Top(hObject, eventdata, handles)
        else
            prompt      = 'Entered number was not a number of 2. Again : Number of players in the Top (it has to be a power of 2)';
        end
    else
        disp('Selection was cancelled.')
        bool = true;
    end
end
% --------------------------------------------------------------------
function MENU_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global option

if option.tmp.bool_createTournament
    disp('- Accorded')
    statisticsGUI
else
    msg = 'Before editing a tournament, you have a create one first !';
    handles_i = handles.TXT_error;
    prefix = '';
    displayErrorMsg( msg, handles_i, prefix )
end




function computeScore(hObject, eventdata, handles)
% Compute the score of the TABLE.tablePlayers_forTournament

global TABLE MATRICE option

option.tmp.compteur_computeScore = option.tmp.compteur_computeScore +1;

disp('-- Update TABLE.historyMatch')
if option.tmp.compteur_computeScore > 1
    disp('--- NOT 1st time to compute score: Need to delete line in TABLE.historyMatch before storing')
    nb_match = size(TABLE.historyMatch_tmp,1);
    TABLE.historyMatch(end-nb_match+1:end,:) = [];
    disp('-- Reload TABLE.tablePlayers_forTournament from last round')
    id = find(TABLE.HistoryTABLE.no_Round == option.no_round-1);
    TABLE.tablePlayers_forTournament = TABLE.HistoryTABLE.standing{id};
else
    disp('--- 1st time to compute score: Store directly the TABLE.historyMatch_tmp to TABLE.historyMatch')    
end
TABLE.historyMatch = [TABLE.historyMatch; TABLE.historyMatch_tmp];

% Assign scores
disp('-- Assign Scores')
for i = 1:size(TABLE.historyMatch_tmp,1)    
    TABLE.tablePlayers_forTournament = assignScores(TABLE.tablePlayers_forTournament, MATRICE.matchID, MATRICE.match_record, i, option );
end

% Sort the data : 1st time
disp('-- Sort the data : 1st time')
TABLE.tablePlayers_forTournament = sortrows(TABLE.tablePlayers_forTournament,option.column2sort,option.sortType);

% take back if in top
switch option.typeRound
    case 'Top'
        TableFromLastRound = TABLE.HistoryTABLE.standing{option.no_round,1};
        nb_current_player = size(TABLE.tablePlayers_forTournament,1);
        subtable = [TABLE.tablePlayers_forTournament; TableFromLastRound(nb_current_player+1:end,:)];
        TABLE.tablePlayers_forTournament = subtable;
end

% Determine if 1st Loss and store it
disp('-- Determine if 1st Loss and store it')
TABLE.tablePlayers_forTournament = firstLoss(TABLE.tablePlayers_forTournament, TABLE.historyMatch_tmp);

switch option.typeRound
    case 'Round'        
        % Compute Solkoff or Buchholz points
        disp('-- Compute Solkoff or Buchholz points')
        typeSolkoff_buchholz = 'median';
        TABLE.tablePlayers_forTournament = Solkoff_buchholz_Compute (TABLE.historyMatch, TABLE.tablePlayers_forTournament, typeSolkoff_buchholz, option.no_maxRound);

        % Store cumulative score
        disp('-- Store cumulative score')
        TABLE.tablePlayers_forTournament = Cumulative_Tie_break (TABLE.tablePlayers_forTournament, option.no_round);

        % Compute Bushi Points
        disp('-- Compute Bushi Points')
        [ TABLE.tablePlayers_forTournament ] = bushi_points( MATRICE.mat_HistoryMatch, TABLE.tablePlayers_forTournament, option.no_round, option.no_maxRound );
    
    case 'Top'
        disp('This Top. No computation for cumulative score and Bushi Points')
    otherwise
        disp('Case not known')
end

% 3.4- Make the ranking
disp('-- Making the ranking');
msg = 'All the matches have been reported. You can see the new standings';
handles_i = handles.TXT_error;
prefix = '- ';
displayErrorMsg( msg, handles_i, prefix )
% disp(['- ' msg])
% msgbox(msg, 'Error', 'error')

% Sort the data : 2nd time
disp('-- Sort the data : 2nd time');
TABLE.tablePlayers_forTournament = sortrows(TABLE.tablePlayers_forTournament,option.column2sort,option.sortType);

% Assign ranking
disp('-- Assign ranking');
TABLE.tablePlayers_forTournament = assignRanking(TABLE.tablePlayers_forTournament,option.column2sort);

TABLE.tablePlayers_FINAL = TABLE.tablePlayers_forTournament;    

disp('-- Save in HistoryTABLE')
TABLE.HistoryTABLE.no_Round(option.no_round+1,1)      = option.no_round;
TABLE.HistoryTABLE.typeOfRound{option.no_round+1,1}   = option.typeRound;
TABLE.HistoryTABLE.standing{option.no_round+1,1}      = TABLE.tablePlayers_forTournament; 


% --- Executes on button press in BUT_startTimer.
function BUT_startTimer_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_startTimer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

timerGUI



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERSONAL ADDED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = updateListPlayers(hObject, eventdata, handles) 

global TABLE option
% Set list
% subtable = TABLE.tablePlayers_forTournament
try
    subtable    = TABLE.HistoryTABLE.standing{1};
catch
    subtable = TABLE.tablePlayers_forTournament;
end
firstnames  = table2cell(subtable(:,'name'));
lastnames   = table2cell(subtable(:,'familyName'));
names       = strcat(lastnames, {', '}, firstnames, {' ('}, num2str(option.no_round), ')');
names       = sort(names); % Sort name by alphabetical order
set(handles.LIST_listPlayer, 'String', names)


function pairingTable = matchID_2_pairingTable(tablePlayers_forTournament, pairingTable, pairingWSCode, round)

global option TABLE

% Convert matchID to Pairing Table containing the name of players
list_WSCode = tablePlayers_forTournament.WSCode;
[m,n] = size(pairingWSCode);

% pairingTable(:,:) = [];
% pairingTable_allocation = {inf inf inf 'inf, inf' inf 'inf, inf' inf []};
% variableName = pairingTable.Properties.VariableNames;
% pairingTable(1,:) = cell2table(TABLE.pairingTable_allocation);
% pairingTable = repmat(cell2table(TABLE.pairingTable_allocation),m,1);
pairingTable = tableAllocation(m, pairingTable, TABLE.pairingTable_allocation);


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



% --------------------------------------------------------------------
function MENU_send_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MENU_sendReport_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_sendReport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE MATRICE option

disp('--------------------------------------------------------------------')
disp('Sending the report')

disp('- Save the report')
[fileNameStanding fileNameCSV] = writeStanding();

header = [option.tournamentInfo.locationInfo.locname{1} ' (' option.tournamentInfo.locationInfo.country{1} ') - ' option.tournamentInfo.date];
id_location = num2str(option.tournamentInfo.locationInfo.idloc{1});

prompt      = {'Enter your name:', 'Enter your email address', 'Enter additionnal informations (if you want)', 'Enter email addresses to send (put a comma between each email)'};
dlg_title   = 'Send the report';
num_lines   = 1;
defaultans  = {option.userInfo.name, option.userInfo.email, 'my additionnal information', 'pairing.software@gmail.com; '};
answer      = inputdlg(prompt,dlg_title,num_lines,defaultans);

h = waitbar(0.50,'Sending the report. Please wait ...');

disp('- Extract the date of now')
formatOut = 'yyyy/mm/dd';
date2 = datestr(datetime('today'),formatOut);
formatOut = 'yyyymmdd';
date1 = datestr(datetime('today'),formatOut);

disp('- Save the global variable TABLE MATRICE and option to a .mat file to send')
filepath = pwd;
filename = [filepath '/results/' date1 '_config.mat'];
save(filename,'TABLE','MATRICE','option')

% Compress into a zip file
% To be put in the future

% if option.UserInfo.bool_getIP == false
    [option.UserInfo.MyExternalIP, option.UserInfo.linkIPLocation, option.UserInfo.mac, option.UserInfo.bool_getIP] = getIPandMAC();
% else
    MyExternalIP = option.UserInfo.MyExternalIP;
    linkIPLocation = option.UserInfo.linkIPLocation;
    mac = option.UserInfo.mac;
% end

disp('- Configure the mail adress to send :')
recipients = answer{4};
recipients  = strsplit(recipients,';');
if strcmp(recipients(end),' ') == 1 || strcmp(recipients(end),'') == 1
    recipients = recipients(1:end-1);
end
% recipients(strcmp('',recipients)) = [];
% recipients  = recipients(~cellfun('isempty', recipients)); % delete empty cell 
subject     = [date2 ' Report of tournament (' answer{1} '):' option.tournamentInfo.name];
message     = ['Dear Admin,' 10 10 ...
                'Here is the report' 10 ...
                'Author: ' answer{1} 10 ...
                'Contact: ' answer{2} 10 ...
                'Location Information: ' header 10 ...
                'ID Location: ' id_location 10 10 ...
                'IP Adress: ' MyExternalIP{1} 10 ....
                'MAC Address: ' mac 10 10 ...
                'Additionnal informations: ' 10 answer{3} 10 10 10 ...
                'Note: You can view the origin of the sender by clicking the following link: ' 10 ...
                linkIPLocation];
attachments = {filename, fileNameStanding, fileNameCSV};

disp(['-- ' recipients])
disp(['-- ' subject])
disp(['-- ' message])
disp('-- File Attached')
disp(attachments)

disp('- Send with the Gmail adress pairing.software@gmail.com')
try
    sendGmail( recipients, subject, message, attachments )
    msg = ['Report has been sent successfully to: ' recipients];
catch
    msg = ['FAIL : Report cannot be sent to: ' recipients '. Maybe you have to configure your '...
           'antivirus to allow mail to be sent outside (Problem known with Avast: ' ...
           'paramètres, protection active, agent mail, tu cliques sur la roue dentée et tu décoches la case " analyser le courrier sortant" + desactivate SSL analysis'];
end
handles_i = handles.TXT_error;
prefix = '';
displayErrorMsg( msg, handles_i, prefix )
% disp(['- ' msg])
% msgbox(msg, 'Error', 'error')

close(h)

function visibilityOnOff(handles, mode)

set(handles.BUT_printMenu, 'Visible', mode)
set(handles.BUT_sendPairing, 'Visible', mode)
set(handles.BUT_startTimer, 'Visible', mode)
set(handles.TAB_pairing, 'Visible', mode)
set(handles.GROUP_reportScores, 'Visible', mode)
set(handles.CHECK_showPendingResult, 'Visible', mode)



% --------------------------------------------------------------------
function MENU_postFacebook_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_postFacebook (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
futureFunctionalityMsg(handles)
% url = 'http://www.mathworks.com';
% web(url,'-browser')
% 
% 
% thingSpeakURL = 'https://www.facebook.com/dialog/feed?';
% thingSpeakWriteURL = thingSpeakURL;
% writeApiKey = '362799644106668';
% fieldName = 'field1';
% fieldValue = 42;
% response = webwrite(thingSpeakWriteURL,'api_key',writeApiKey,fieldName,fieldValue)
% % 
% 
% 
% thingSpeakURL = 'https://www.facebook.com/dialog/feed?';
% thingSpeakWriteURL = thingSpeakURL;
% writeApiKey = '362799644106668';
% fieldName = 'field1';
% fieldValue = 42;
% response = webwrite(thingSpeakWriteURL,'api_key',writeApiKey,fieldName,fieldValue)


% % test for matlab online
% thingSpeakURL = 'http://api.thingspeak.com/';
% thingSpeakWriteURL = [thingSpeakURL 'update'];
% writeApiKey = '19M8YL1FP1ADB3Q4'; % 'Your Write API Key';
% data = 42;
% data = num2str(data);
% data = ['api_key=',writeApiKey,'&field1=',data];
% response = webwrite(thingSpeakWriteURL,data)


% --- Executes when user attempts to close beginTournament.
function beginTournament_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to beginTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global timer
stop(timer.c)
delete(hObject);


% --------------------------------------------------------------------
function MENU_saveAsTournament_Callback(hObject, eventdata, handles)
% hObject    handle to MENU_saveAsTournament (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TABLE MATRICE option

[filename, pathname] = uiputfile({'*.mat';'*.*'}, 'Save as the tournament configuration', [ pwd '\tournamentSave\mytournament.mat']);
if isequal(filename,0) || isequal(pathname,0)
   disp('User selected Cancel')
else
   disp(['User selected ',fullfile(pathname,filename)])
   option.nameConfig = filename;
   save([pathname filename], 'TABLE', 'MATRICE', 'option')
end


% --- Executes on button press in BUT_printPlayerSlips.
function BUT_printPlayerSlips_Callback(hObject, eventdata, handles)
% hObject    handle to BUT_printPlayerSlips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TABLE option
h = waitbar(0.50,'Generating the player slips. Please wait ...');
printPlayerSlips(TABLE,option)
close(h)