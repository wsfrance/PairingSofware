function classement_final = swissRound (classement_init, no_round)
% Function to make the pairing between players
% Input : 
%   * classement_init : initial record of the players
%   * no_round : the actual round number
% Output :
%   * classement_final : the final record of the players

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1st round

% Divide players into 2 sub-groups
% Au d�but du tournoi, les n joueurs sont class�s selon leur force. 
% Pour le premier tour (appel� ronde dans les tournois d'�checs), les 
% joueurs sont divis�s en deux sous-groupes : un sous-groupe S1 compos� des 
% joueurs 1 � n/2, et un sous-groupe S2 compos� des joueurs (n/2)+1 � n. 
nb_players          = size(classement_init,1);
middle_nbPlayers    = round(nb_players/2);
id_subGroup1        = 1:middle_nbPlayers;
id_subGroup2        = middle_nbPlayers+1:nb_players;

% Si le nombre n'est pas pair, cr�er un joueur appel� NaN

subGroup1 = classement_init(id_subGroup1,:);
subGroup2 = classement_init(id_subGroup2,:);

% Le premier de S1 joue contre le premier de S2, le deuxi�me de S1 contre 
% le deuxi�me de S2, et ainsi de suite de mani�re que le dernier joueur de 
% S1 joue contre le dernier joueur de S2.
pairing = [id_subGroup1' id_subGroup2'];

end