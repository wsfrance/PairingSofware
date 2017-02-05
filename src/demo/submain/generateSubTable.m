function [rankTable, playerIdTable, historyMatch, historyMatch_tmp, indexMat] = generateSubTable(nb_players, no_maxRound)

zerosMat = zeros(nb_players,1);
indexMat = [1:nb_players]';
cell_zerosMat = {zeros(1,no_maxRound)};

rankTable = table(...
    zerosMat,...
    zerosMat-1,...
    indexMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    zerosMat,...
    repmat(cell_zerosMat,nb_players,1),...
    'VariableName', {'Points', 'PointsOfTop', 'Ranking', 'winNumber', 'tieNumber', 'lossNumber', 'Modified_Median', 'Solkoff' , 'Cumulative_Score', 'first_Loss', 'Buchholz', 'MWP', 'Opp_MW', 'Opp_T1','historyPoints'});

playerIdTable = table(...
    indexMat, ...
    'VariableName', {'playerId'});

historyMatch = table(...
               {'temp'},...
               {'temp'},...
               {'temp'},...
               {'temp'},...
               1,...
               1,...
               'VariableName', {'Player1', 'Player2', 'WSCode1', 'WSCode2', 'Round', 'winner'});

historyMatch_tmp = table(...
               {'temp'},...
               {'temp'},...
               {'temp'},...
               {'temp'},...
               1,...
               1,...
               'VariableName', {'Player1', 'Player2', 'WSCode1', 'WSCode2', 'Round', 'winner'});            

historyMatch(1,:) = [];           
% historyMatch_tmp(1,:) = [];    

end