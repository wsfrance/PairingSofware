function [Best,idxBest] = findBestResult_Bycolumn (Matrix, method)
% find the best result according to the columns from the 1st to the last
% and the take the first one at the end if there are still multiple min/max
% -------------------------------------------------------------------------
% Input:
%       * Matrix: Matrice m x p where each column is to analyze
%       * method: either 'min' or 'max'
% -------------------------------------------------------------------------
% Output:
%       * Best: Best score of the last column
%       * idxBest: index in the original matrice (line number) that is the
%       best
% -------------------------------------------------------------------------
% Author: DO Cao Tri
% Date: 2015-02-11
% -------------------------------------------------------------------------
% Example 1:
% Matrix = [1 1 3 5 5; 2 1 3 4 5]';
% method = 'min';
% [Best,idxBest] = findBestResult_Bycolumn (Matrix, method)
% Best = 1;
% idx = 2;
%
% Example 2:
% Matrix = [2 1 3 1 1; 2 5 3 3 1]';
% method = 'min';
% [Best,idxBest] = findBestResult_Bycolumn (Matrix, method)
% Best = 1;
% idx = 5;
% -------------------------------------------------------------------------
original_idx     = 1:size(Matrix,1);

if(sum(sum(isnan(Matrix)),2) > 0)
    warning('NaN are present in performance score')
   % error('Can not find the best performance : at least one performance score is NaN');
end

Matrice_Restante = Matrix      ;
idx_Restant      = original_idx;
switch method
    case 'min'
        % find all NaN and put them to +inf
        % Matrice_Restante(isnan(Matrice_Restante))=inf;
        [row, col] = find(isnan(Matrice_Restante));
        Matrice_Restante(row,:) = Inf;
        
        for p=1:size(Matrix,2)
            min_p               = min(Matrice_Restante(:,p));
            idx_p               = find(Matrice_Restante(:,p)==min_p);
            Matrice_Restante    = Matrice_Restante(idx_p,:);
            idx_Restant         = idx_Restant(idx_p);
        end
        Best    = min_p(1);
        idxBest = idx_Restant(1);
    case 'max'
        % find all NaN and put them to -inf
        % Matrice_Restante(isnan(Matrice_Restante))=inf;
        [row, col] = find(isnan(Matrice_Restante));
        Matrice_Restante(row,:) = -Inf;
        
        for p=1:size(Matrix,2)
            max_p               = max(Matrice_Restante(:,p));
            idx_p               = find(Matrice_Restante(:,p)==max_p);
            Matrice_Restante    = Matrice_Restante(idx_p,:);
            idx_Restant         = idx_Restant(idx_p);
        end
        Best    = max_p(1);
        idxBest = idx_Restant(1);
end
