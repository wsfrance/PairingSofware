function mat_HistoryMatch = updateHistoryMatch (mat_HistoryMatch,pairingID)
% Update mat_HistoryMatch
    for k = 1:size(pairingID,1)
        extract_match_index = pairingID(k,:);
        mat_HistoryMatch(extract_match_index(1),extract_match_index(2)) = mat_HistoryMatch(extract_match_index(1),extract_match_index(2))+1;
        mat_HistoryMatch(extract_match_index(2),extract_match_index(1)) = mat_HistoryMatch(extract_match_index(2),extract_match_index(1))+1;
    end
end