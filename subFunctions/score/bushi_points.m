function [ tablePlayers_forTournament ] = bushi_points( historyMatch, tablePlayers_forTournament, no_current_round, no_maxRound )
%BUSHI_POINTS Summary of this function goes here
%   Detailed explanation goes here
% computes 'MWP', 'Opp_MW', 'Opp_T1'



disp('Computing Bushiroad System Points : MWP, Opp_MW, Opp_T1')
for i = 1:size(tablePlayers_forTournament,1)
    % MWP
    % Opponent Match Win %
    % At the end of the tournament, calculate each fighter's match win %
    % using the following formula :
    % (the fighter’s point total) / (number of rounds ×3).
    tablePlayers_forTournament.MWP(i,1) = tablePlayers_forTournament.Points(i,1)/(3*no_current_round);
    
    % Round down the results to two decimal places. If the result is lower than 0.33, it is calculated as 0.33.
    tmp = round((tablePlayers_forTournament.MWP(i,1)*100))/100;
%     if tmp < 0.33
%         tablePlayers_forTournament.MWP(i,1) = 0.33;
%     else
        tablePlayers_forTournament.MWP(i,1) = tmp;
%     end      
end

for i = 1:size(tablePlayers_forTournament,1)
    % Opp_MW
    % For each fighter, add up each of his or her opponents’match win %
    % and divide by the number of those opponents.
    % The result of this calculation is called the Opponent Match Win %. 
    id_player = tablePlayers_forTournament.playerId(i);
    id_opp = find(historyMatch(id_player,:)>=1);
    id_table = ismember(tablePlayers_forTournament.playerId, id_opp);
    opp_MWP = tablePlayers_forTournament.MWP(id_table,1);
    tablePlayers_forTournament.Opp_MW(i,1) = sum(opp_MWP)/length(opp_MWP);
    if isnan(tablePlayers_forTournament.Opp_MW(i,1))
        disp('Problem')
    end
    
    % Note:
    % The fighter with a higher Opponent Match Win % wins the tiebreaker. 
    % If a fighter had any byes, exclude that round from the calculation.
end
warning('Still need for Opp_MW to exclude byes from calculation')


end

