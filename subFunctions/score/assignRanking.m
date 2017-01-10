function tablePlayers_forTournament = assignRanking(tablePlayers_forTournament,column2check, start_no_ranking)

% Function to assign the ranking for each player.
% Put the same ranking if two players have exactly the same score according
% to the performance metrics used

% Check nargin
if nargin < 3
    % If no start ranking number is given, we suppose that the 1st ranking
    % to give is 1st place.
    disp('No start_no_ranking putted. Default: 1')
    start_no_ranking = 1;
end

% Define parameters
nb_players = size(tablePlayers_forTournament,1);
rank_i = start_no_ranking;

% Allocate matrix
rank_tmp = zeros(nb_players,1);
% Put to all players the ranking zeros so that we are going to give them
% recursively a ranking
tablePlayers_forTournament.Ranking = rank_tmp;

% For each player
for i = 1:nb_players
    % If no ranking is given, we are going to give him a ranking
    if tablePlayers_forTournament.Ranking(i) == 0
        tablePlayers_forTournament.Ranking(i) = rank_i;
        total = tablePlayers_forTournament(:,column2check); % performance metrics to check of other players
        T2 = tablePlayers_forTournament(i,column2check); % performance metrics of the current player
        if i+1<=nb_players
            idx_i = ismember(total(i+1:end,:),T2);
            logical2id = find(idx_i==1);
            tablePlayers_forTournament.Ranking(i+logical2id) = rank_i;

            rank_i = rank_i+1+size(logical2id,1);
        else
            tablePlayers_forTournament.Ranking(i) = rank_i;
            % rank_i = rank_i+1+size(logical2id,1);
        end
    end
end


end