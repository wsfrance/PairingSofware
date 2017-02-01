function [ pairingID, pairingWSCode, mat_HistoryMatch ] = singleElimination( tablePlayers, mat_HistoryMatch, option)
%SINGLEELIMINATION Summary of this function goes here
%   Detailed explanation goes here


disp('Starting')

% Allocate/Extract informations
classement_init = tablePlayers.Ranking;
winNumber       = tablePlayers.winNumber;
playersID       = tablePlayers.playerId;

nb_players      = size(classement_init,1);

%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------


% Convert pairingID to WSCode
pairingWSCode = id2WSCode(tablePlayers, pairingID);

% Update mat_HistoryMatch
mat_HistoryMatch = updateHistoryMatch (mat_HistoryMatch,pairingID);

    
end

