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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tie-breaks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% source 1 : https://theicca.wikispaces.com/file/view/Understanding+Tie-breaks.pdf
% source 2 : http://vtchess.info/Results/Tie_break_rules.htm#Modified Median


function tablePlayers_forTournament = assignScores(tablePlayers_forTournament, matchID, match_record, i, option )
% Report the score
% 1 : par win
% 0.5 : par tie
% 0 : par loss

% Système Baumbach (nombre de victoires)

% Note : Système Kashdan
% 3 points pour une victoire, 1 point pour une partie nulle et 0 pour une 
% défaite. Ce système pénalise les joueurs qui font beaucoup de nulles

id_player1 = find(tablePlayers_forTournament.playerId==matchID(i,1));
id_player2 = find(tablePlayers_forTournament.playerId==matchID(i,2));
switch match_record(i,1)
    case 1
        % Player 1 winner
        id_winner   = id_player1;
        id_loser    = id_player2;
    case 2
        % Player 2 winner
        id_winner   = id_player2;
        id_loser    = id_player1;
    case 3
        id_winner   = id_player2;
        id_loser    = id_player1;
    otherwise
        error('match_record(i,1) not known')
end

switch match_record(i,1)
    case {1,2}
        % Player 1 or 2 winner
        tablePlayers_forTournament.winNumber(id_winner) = tablePlayers_forTournament.winNumber(id_winner)+1;
        tablePlayers_forTournament.lossNumber(id_loser) = tablePlayers_forTournament.lossNumber(id_loser)+1;

        tablePlayers_forTournament.Points(id_winner) = tablePlayers_forTournament.Points(id_winner)+ option.winningPoint;
        tablePlayers_forTournament.Points(id_loser) = tablePlayers_forTournament.Points(id_loser)+ option.losePoint;
    
    case 3    
        % Player 1 and 2 tied
        tablePlayers_forTournament.tieNumber(id_winner) = tablePlayers_forTournament.tieNumber(id_winner)+1;
        tablePlayers_forTournament.tieNumber(id_loser) = tablePlayers_forTournament.tieNumber(id_loser)+1;
        
        tablePlayers_forTournament.Points(id_winner) = tablePlayers_forTournament.Points(id_winner)+ option.tiePoint;
        tablePlayers_forTournament.Points(id_loser) = tablePlayers_forTournament.Points(id_loser)+ option.tiePoint;
    otherwise
        error('match_record(i,1) not known')
end
end


function tablePlayers_forTournament = Solkoff_buchholz_Compute (historyMatch, tablePlayers_forTournament, type, no_maxRound)

% source : wikipedia
% On additionne les résultats des opposants au joueur, 
% ce qui favorise ceux qui ont la plus forte opposition 
% et on multiplie la marque du joueur par cette somme des points des adversaires. 
% Le score Buchholz obtenu permet de classer les joueurs.
% Lorsque le système Buccholz est utilisé pour départager des ex æquo, 
% on n'effectue pas la multiplication et il se confond avec le système de 
% départage Solkoff (ou Solkov).
% Note : ici, on fait un départage Solkoff (pas de multiplication)

if nargin < 3
    type = 'median';
end

if nargin < 4
    no_maxRound = 8;
end

nb_player = size(tablePlayers_forTournament,1);

for i = 1:nb_player
    name = tablePlayers_forTournament.name(i);
    rank = tablePlayers_forTournament.Ranking(i);
    % Extract all matches of player name
    % Opponent in column 1
    id1 = strcmp(historyMatch.Player1,name)==1;
    list1 = historyMatch.Player2(id1);
    
    % Opponent in column 2
    id2 = strcmp(historyMatch.Player2,name)==1;
    list2 = historyMatch.Player1(id2);
    
    % Concatenate list 1 and 2
    list = [list1; list2];
    id_tmp = [];
    
    % Search all opponents of current player
    for j = 1:length(list)
        name_opponent_j = list(j);
        id_table = strcmp(tablePlayers_forTournament.name, name_opponent_j) == 1;
        id_player = find(id_table==1);
        id_tmp = [id_tmp; id_player];       
    end
    
    % Extract the score of the opponent and compute the Buccholz points
    extractPoint = tablePlayers_forTournament.Points(id_tmp);
    extractPoint = sort(extractPoint);
    % Remove lower score and higher scores
    switch type
        case 'normal'
            solkoff_point = sum(extractPoint);
        case 'median'
            if length(extractPoint)>=3
                solkoff_point = sum(extractPoint(2:end-1));
            else
                solkoff_point = 0;
            end
        case 'median2'
            if no_maxRound<=8 && length(extractPoint)>=3
                solkoff_point = sum(extractPoint(2:end-1));
            elseif no_maxRound>=9 && no_maxRound <=12 && length(extractPoint)>=5
                solkoff_point = sum(extractPoint(3:end-2));
            elseif no_maxRound <=12 && length(extractPoint)>=7
                solkoff_point = sum(extractPoint(4:end-3));
            else
                solkoff_point = 0;
            end
        otherwise
            error('type not known')
    end
    
    % case 'modified_median'
    % Note : http://www.swissperfect.com/tiebreak.htm
    if length(extractPoint)>=2
        if rank < nb_player/2
            modified_median = sum(extractPoint(2:end));
        elseif rank > nb_player/2
            modified_median = sum(extractPoint(1:end-1));
        else
            % rank == nb_player/2
            if length(extractPoint)>=3
                modified_median = sum(extractPoint(2:end-1));
            else
                modified_median = sum(extractPoint(2:end));
            end
        end
    else
        modified_median = 0;
    end
    
    % On multiplie le score du joueur par la somme des points de tous les 
    % joueurs rencontrés (SPA).
    buchholz_point = solkoff_point * tablePlayers_forTournament.Points(i);
    
    tablePlayers_forTournament.Solkoff(i) = solkoff_point;
    tablePlayers_forTournament.Buchholz(i) = buchholz_point;
    tablePlayers_forTournament.Modified_Median(i) = modified_median;
end
end


function tablePlayers_forTournament = firstLoss(tablePlayers_forTournament, historyMatch_tmp)

% Time of loss
% Among tied players, the player whose first loss came last gets priority. 
% If player A’s first loss was in round 4 and player B’s first loss was in 
% round 2, player A gets priority. This was a tiebreaker used by POP in 2004-2005.

no_round = historyMatch_tmp.Round(1);

id_winner = historyMatch_tmp.winner;
id1 = id_winner == 1;
name_loser1 = historyMatch_tmp.Player2(id1);

id2 = id_winner == 2;
name_loser2 = historyMatch_tmp.Player1(id2);

name_looser = [name_loser1; name_loser2];

for j = 1:length(name_looser)
    name_looser_j = name_looser(j);
    id_tmp = strcmp(tablePlayers_forTournament.name, name_looser_j) == 1;
    if tablePlayers_forTournament.first_Loss(id_tmp) == 0
        tablePlayers_forTournament.first_Loss(id_tmp) = no_round;
    end
end
end

% The Cumulative Tie-break System
function tablePlayers_forTournament = Cumulative_Tie_break (tablePlayers_forTournament, current_round)

nb_player = size(tablePlayers_forTournament,1);

for i = 1:nb_player
    data = tablePlayers_forTournament.historyPoints(i);
    data{1}(current_round) = tablePlayers_forTournament.Points(i);
    tablePlayers_forTournament.historyPoints(i) = data;
    tablePlayers_forTournament.Cumulative_Score(i) = sum(data{1});
end

end



function tablePlayers_forTournament = assignRanking(tablePlayers_forTournament,column2check)

nb_players = size(tablePlayers_forTournament,1);
rank_i = 1;

rank_tmp = zeros(nb_players,1);
tablePlayers_forTournament.Ranking = rank_tmp;

for i = 1:nb_players
    if tablePlayers_forTournament.Ranking(i) == 0
        tablePlayers_forTournament.Ranking(i) = rank_i;
        total = tablePlayers_forTournament(:,column2check);
        T2 = tablePlayers_forTournament(i,column2check);
        idx_i = ismember(total(i+1:end,:),T2);
        logical2id = find(idx_i==1);
        tablePlayers_forTournament.Ranking(i+logical2id) = rank_i;

        rank_i = rank_i+1+size(logical2id,1);
    end
end


end
