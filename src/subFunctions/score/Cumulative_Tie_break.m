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