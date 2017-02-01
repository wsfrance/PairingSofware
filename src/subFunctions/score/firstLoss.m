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