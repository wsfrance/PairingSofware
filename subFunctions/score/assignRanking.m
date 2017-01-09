function tablePlayers_forTournament = assignRanking(tablePlayers_forTournament,column2check, start_no_ranking)

if nargin < 3
    disp('No start_no_ranking putted. Default: 1')
    start_no_ranking = 1;
end

nb_players = size(tablePlayers_forTournament,1);
rank_i = start_no_ranking;

rank_tmp = zeros(nb_players,1);
tablePlayers_forTournament.Ranking = rank_tmp;

for i = 1:nb_players
    if tablePlayers_forTournament.Ranking(i) == 0
        tablePlayers_forTournament.Ranking(i) = rank_i;
        total = tablePlayers_forTournament(:,column2check);
        T2 = tablePlayers_forTournament(i,column2check);
        if i+1<=nb_players
            idx_i = ismember(total(i+1:end,:),T2);
            logical2id = find(idx_i==1);
            tablePlayers_forTournament.Ranking(i+logical2id) = rank_i;

            rank_i = rank_i+1+size(logical2id,1);
        else
            tablePlayers_forTournament.Ranking(i) = rank_i;
            rank_i = rank_i+1+size(logical2id,1);
        end
    end
end


end