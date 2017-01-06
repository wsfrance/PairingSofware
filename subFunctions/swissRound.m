function [pairingID, pairingWSCode, mat_HistoryMatch] = swissRound (tablePlayers, mat_HistoryMatch, option)
% Function to make the pairing between players
% Input : 
%   * tablePlayers      : initial record of the players
%   * mat_HistoryMatch  : 
%   * option            : structure containing
%           - no_round : the actual round number
% Output :
%   * classement_final  : the final record of the players

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = 0;

% Allocate/Extract informations
classement_init = tablePlayers.Ranking;
winNumber       = tablePlayers.winNumber;
playersID       = tablePlayers.playerId;

nb_players      = size(classement_init,1);

%% 1st round
if option.no_round == 1
    % Divide players into 2 sub-groups
    % Au début du tournoi, les n joueurs sont classés selon leur force. 
    % Pour le premier tour (appelé ronde dans les tournois d'échecs), les 
    % joueurs sont divisés en deux sous-groupes : un sous-groupe S1 composé des 
    % joueurs 1 à n/2, et un sous-groupe S2 composé des joueurs (n/2)+1 à n.    
    
    middle_nbPlayers = nb_players/2; % middle position of the ranking
    
    if mod(nb_players,2) == 1
        % Si le nombre n'est pas pair, créer un joueur appelé bye
        nb_players = nb_players+1;
        byePlayer = nb_players;
        classement_init = 1:nb_players;
    end

    id_subGroup1        = playersID(1:middle_nbPlayers);
    id_subGroup2        = playersID(middle_nbPlayers+1:nb_players);
    id_subGroup1 = id_subGroup1';
    id_subGroup2 = id_subGroup2';
    
    % Le premier de S1 joue contre le premier de S2, le deuxième de S1 contre 
    % le deuxième de S2, et ainsi de suite de manière que le dernier joueur de 
    % S1 joue contre le dernier joueur de S2.
    pairingID = [id_subGroup1' id_subGroup2'];


else
    switch option.swissRoundType
        case 'Score_Group'
            % Allocate
            %     pairingID = zeros(middle_nbPlayers,2);
            % Players play against of same number of wins
            pairingID = []; % Allocation to change

            totalCurrentWins = unique(winNumber);                 % Extract total of unique wins 
            totalCurrentWins = sort(totalCurrentWins,'descend');  % sort the numbers of win
            rest_tmp = [];                                        % allocate 1st iteration

            % For each same number of wins
            for id = 1:length(totalCurrentWins)         
                score_tmp = totalCurrentWins(id);       % extract current number of wins from index
                id_tmp = find(winNumber==score_tmp);    % find all wins in table equal to currect extract wins
                currentPlayersID = [rest_tmp; playersID(id_tmp)]; % extract the players and add from last

                if size(currentPlayersID,1)==1
                    % If I have only one player, put it into the next group of players
                    rest_tmp = currentPlayersID;
                else
                    % Otherwise (several players), separate Odd and even cases of number of players
                    [currentPlayersID, rest_tmp] = separate_OddEven_case(currentPlayersID);

                    % Check if a player hasn't already played against a player
                    bool = 1;
                    counter = 1;
                    counter_maxShuffle = 10;

                    while bool == 1 && counter<=counter_maxShuffle                
                        % Make the pairing from same number of wins
                        pairingID_tmp = reshape(currentPlayersID,2, size(currentPlayersID,1)/2); 
                        pairingID_tmp = pairingID_tmp';
                        % For each pairing generated, check if it has already be done
                        bool_mat = checkAlreadyDonePairing (pairingID_tmp,mat_HistoryMatch, verbose);

                        id_test = find(bool_mat==1);
                        if isempty (id_test) == 0
                            bool = 1;
                            counter = counter+1;
                            if verbose
                                disp('le match a déjà eu lieu. Re-pairing by re-shuffle')
                            end
                            currentPlayersID=currentPlayersID(randperm(length(currentPlayersID)));
                        else
                            bool = 0;
                            if verbose
                                disp(['Tout le pairing est ok pour le score win = ' num2str(score_tmp) '. Continuing'])
                            end
                        end
                    end

                    pairingID = [pairingID; pairingID_tmp]; % Add to already done pairing
                end
            end
            
        case 'Monrad'
            boolPlayer = false(nb_players,1);
            counter = 1;
            pairingID = []; % Allocation to change
            for i = 1:nb_players
                if boolPlayer(i)==0
                    pairingID(counter,1) = playersID(i);
                    boolPlayer(i)=true;
                    bool_opponent=false;
                    % find opponent
                    j = 1;
                    while bool_opponent==false
                        if boolPlayer(j)==0
                            % check if the players have already played
                            % against each other. If not paired them
                            mini = min(mat_HistoryMatch(playersID(i),:));
                            if mat_HistoryMatch(playersID(i), playersID(j)) == mini || j==nb_players                      
                                pairingID(counter,2) = playersID(j);
                                boolPlayer(j)=true;
                                bool_opponent=true;
                            else
                                disp('le match a déjà eu lieu. Continue')
                                j = j+1;
                            end
                        else
                            j = j+1;
                        end
                    end
                    counter = counter+1;
                else
                    disp('Player is already paired. Continue')
                end
            end
            
        otherwise
            error('Case not known')
    end
            
end

% Convert pairingID to WSCode
pairingWSCode = id2WSCode(tablePlayers, pairingID);

% Update mat_HistoryMatch
mat_HistoryMatch = updateHistoryMatch (mat_HistoryMatch,pairingID);


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADDED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [currentPlayersID, rest_tmp] = separate_OddEven_case(currentPlayersID)
    % Separate Odd and even cases of number of players
    if mod(size(currentPlayersID,1),2) == 0
        % Do nothing, number of players is odd
        rest_tmp = [];
    else
        % number of players is even
        rest_tmp = currentPlayersID(end);
        currentPlayersID(end) = [];
    end
end

function bool_mat = checkAlreadyDonePairing (pairingID_tmp,mat_HistoryMatch, verbose)
    % For each pairing generated, check if it has already be done
    bool_mat = zeros(size(pairingID_tmp,1),1)+Inf;
    for j = 1:size(pairingID_tmp,1)
        extract_match_index = pairingID_tmp(j,:);
        warning ('TO CHANGE CODE')
        if mat_HistoryMatch(extract_match_index) == 0
            if verbose
                disp('le match n a pas encore eu lieu : ok')
            end
            bool_mat(j) = 0;
        else
            if verbose
                disp('le match a déjà eu lieu. Re-pairing')
            end
            bool_mat(j) = 1;
        end
    end
end

% function mat_HistoryMatch = updateHistoryMatch (mat_HistoryMatch,pairingID)
% % Update mat_HistoryMatch
%     for k = 1:size(pairingID,1)
%         extract_match_index = pairingID(k,:);
%         mat_HistoryMatch(extract_match_index(1),extract_match_index(2)) = mat_HistoryMatch(extract_match_index(1),extract_match_index(2))+1;
%         mat_HistoryMatch(extract_match_index(2),extract_match_index(1)) = mat_HistoryMatch(extract_match_index(2),extract_match_index(1))+1;
%     end
% end

% function pairingWSCode = id2WSCode(tablePlayers, pairingID)
% 
% [m,n] = size(pairingID);
% for i = 1:m
%     for j = 1:n
%         id = find(tablePlayers.playerId == pairingID(i,j));
%         pairingWSCode(i,j) = tablePlayers.WSCode(id);
%     end
% end
% 
% 
% end

