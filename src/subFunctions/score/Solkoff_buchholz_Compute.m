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