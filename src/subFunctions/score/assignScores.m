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
        
        switch option.typeRound
            case 'Round'
                tablePlayers_forTournament.Points(id_winner) = tablePlayers_forTournament.Points(id_winner)+ option.winningPoint;
                tablePlayers_forTournament.Points(id_loser) = tablePlayers_forTournament.Points(id_loser)+ option.losePoint;
            case 'Top'
                tablePlayers_forTournament.PointsOfTop(id_winner) = tablePlayers_forTournament.PointsOfTop(id_winner)+ option.winningPoint;
                tablePlayers_forTournament.PointsOfTop(id_loser) = tablePlayers_forTournament.PointsOfTop(id_loser)+ option.losePoint;
            otherwise
                disp('Case not known')
        end
    
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