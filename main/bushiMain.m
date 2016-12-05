function [ tablePlayers_forTournament, historyMatch ] = bushiMain( tablePlayers_fromDB, tablePlayers_forTournament )
%bushiMain Summary of this function goes here
%   Detailed explanation goes here
%--------------------------------------------------------------------------
% Input:
%       * list_dataset      : a list of n datasets. Size : n x 1.
%       * experimentTable   : Table of experiment
%       * choice            : no of the experiment (suffixe for save).
%                             default: 0;
%       * parallelOption    : execute using parallel toolbox. 0: No; 1:Yes.
%                             default: 0;
%--------------------------------------------------------------------------
% Output:
%
%--------------------------------------------------------------------------
% Author: Cao Tri DO
% contact: caotri.do88@gmail.com
% Date: 2016-11-15
%--------------------------------------------------------------------------

verbose = 1;
no_maxRound = 3;

%--------------------------------------------------------------------------
% Check nargin
if nargin < 3
    disp('Nargin to DO')
end
%--------------------------------------------------------------------------

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Bushiroad Swiss Round System')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')


%% 1- add players
if verbose
    disp('-------------------------------------------------------------------')
    disp('** Adding new players')
end

% tablePlayers_fromDB = addPlayers(tablePlayers_fromDB);
% answer2 = saveToDB();    


%% 2- Load players
if verbose
    disp('-------------------------------------------------------------------')
    disp('** Loading Players for Tournament');
    warning ('For now, all players in the DB are added to the tournament')
end

% Generate sub-Tables
nb_players = size(tablePlayers_fromDB,1);
[rankTable, playerIdTable, historyMatch, historyMatch_tmp, indexMat] = generateSubTable(nb_players, no_maxRound);

% Players for Tournament
tablePlayers_forTournament = [playerIdTable tablePlayers_fromDB rankTable];

% Make a cross-table of already done match (such that a match cannot be 'redone')
mat_HistoryMatch = zeros(nb_players,nb_players);

%% 3 - Start Tournament

% option.col_classement_init  = 7;
% option.col_winNumber        = 8;
% option.col_playersID        = 1;
% option.col_win              = 9;
% option.col_tie              = 10;
% option.col_loss             = 11;
option.winningPoint = 1;
option.losePoint    = 0;
option.tiePoint     = 0.5;

for current_round = 1:no_maxRound
    option.no_round = current_round;
    %% 3.1 - Make a pairing players
    if verbose
        disp(['Round number : ' num2str(option.no_round)])
        disp('-------------------------------------------------------------------')
        disp('** Making a pairing players');  
    end
    
    [matchID, pairingWSCode, mat_HistoryMatch] = swissRound (tablePlayers_forTournament, mat_HistoryMatch, option);

    %% 3.2- Report the results +  Compute the new points
    if verbose
        disp('-------------------------------------------------------------------')
        disp('** Reporting the results');
    end
    nb_match = length(matchID);
    match_record = zeros(nb_match,1)+Inf;
    for i = 1:nb_match
       % Ask the result
       lin1 = find(tablePlayers_forTournament.playerId == matchID(i,1));
       lin2 = find(tablePlayers_forTournament.playerId == matchID(i,2));
       player1 = tablePlayers_forTournament.name(lin1);
       player2 = tablePlayers_forTournament.name(lin2);  
       WSCode1 = tablePlayers_forTournament.WSCode(matchID(i,1));
       WSCode2 = tablePlayers_forTournament.WSCode(matchID(i,2));
       message = strjoin([ 'match no ' num2str(i) ' : ' player1 ' (' WSCode1 ') vs ' player2 ' (' WSCode2 ') : winner? (1/2 or 3 for tie) : ']);
       disp(message)
       match_record(i,1) = str2double(input('Result:', 's'));
       
       % Store
       historyMatch_tmp.Player1(i,1) = cellstr(player1);
       historyMatch_tmp.Player2(i,1) = cellstr(player2);
       historyMatch_tmp.WSCode1(i,1) = cellstr(WSCode1);
       historyMatch_tmp.WSCode2(i,1) = cellstr(WSCode2);
       historyMatch_tmp.Round(i,1) = current_round;
       historyMatch_tmp.winner(i,1) = match_record(i,1);
       
       % Assign scores
       tablePlayers_forTournament = assignScores(tablePlayers_forTournament, matchID, match_record, i, option );       
    end

    historyMatch = [historyMatch; historyMatch_tmp];
    
    % Sort the data : 1st time
    column2sort = {'Points', 'Modified_Median', 'Solkoff', 'Cumulative_Score', 'first_Loss', 'name'};
    sortType = {'descend', 'descend', 'descend', 'descend', 'descend', 'ascend'};
    tablePlayers_forTournament = sortrows(tablePlayers_forTournament,column2sort,sortType);
    
    
    % Compute Solkoff or Buchholz points
    typeSolkoff_buchholz = 'median';
    tablePlayers_forTournament = Solkoff_buchholz_Compute (historyMatch, tablePlayers_forTournament, typeSolkoff_buchholz, no_maxRound);
    
    % Determine if 1st Loss and store it
    tablePlayers_forTournament = firstLoss(tablePlayers_forTournament, historyMatch_tmp);
    
    % Store cumulative score
    tablePlayers_forTournament = Cumulative_Tie_break (tablePlayers_forTournament, current_round);
    
    
    %% 3.4- Make the ranking
    if verbose
        disp('-------------------------------------------------------------------')
        disp('** Making the ranking');
    end
    
    % Sort the data : 2nd time
    tablePlayers_forTournament = sortrows(tablePlayers_forTournament,column2sort,sortType);
    
    % old code
    % tablePlayers_forTournament.Ranking = indexMat;
    % Assign ranking
    column2check = {'Points', 'Modified_Median', 'Cumulative_Score', 'Solkoff'};
    tablePlayers_forTournament = assignRanking(tablePlayers_forTournament,column2check);
    
    tablePlayers_forTournament
    pause
end

tablePlayers_forTournament
historyMatch
mat_HistoryMatch

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('End of the program')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADDED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tablePlayers_fromDB = addPlayers(tablePlayers_fromDB)

    bool = 1;

    new_playerTable = table(...
        {'temp'},...
        {'temp'},...
        {'None'},...
        {'None'},...
        'VariableName', {'name', 'familyName', 'country', 'town'});
    new_playerTable(1,:)=[];
    counter = 1;

    while bool == 1
        if bool ==1

        end
        answer = input('Do you want to add new user? (y/n) : ','s');
        switch answer
            case 'y'
                bool = 1;
                % Ask questions
                new_playerTable.name(counter,1) = cellstr(input('Name : ','s'));
                new_playerTable.familyName(counter,1) = cellstr(input('familyName : ','s'));
                new_playerTable.country(counter,1) = cellstr(input('country : ','s'));
                new_playerTable.town(counter,1) = cellstr(input('town : ','s'));

                counter = counter+1;

            case 'n'
                bool = 0;
            otherwise
                warning ('Not a good answer. Do again !!!')
        end
    end

    if size(new_playerTable,1)>0
        tablePlayers_fromDB = [tablePlayers_fromDB; new_playerTable];
    end

end



function [answer2] = saveToDB()

    answer2 = input('Do you want to save the current database? (y/n) : ', 's');
    switch answer2
        case 'y'
            disp('Saving the new database')
            warning ('TO DO')
        case 'n'
            disp('No saving ... continuing')
        otherwise
            disp('Case not known')
    end
end


















