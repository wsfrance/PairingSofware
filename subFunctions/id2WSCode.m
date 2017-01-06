function pairingWSCode = id2WSCode(tablePlayers, pairingID)

[m,n] = size(pairingID);
for i = 1:m
    for j = 1:n
        id = find(tablePlayers.playerId == pairingID(i,j));
        pairingWSCode(i,j) = tablePlayers.WSCode(id);
    end
end


end