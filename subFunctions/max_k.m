function [C,Index] = max_k(A,dim,k)
% returns the k largest elements along different dimensions of an array.
%--------------------------------------------------------------------------
% Input:
%       * A : matrix where to take the max
%       * dim : if dim==1, take on the column, if dim==2, take on the line
%       (default dim == 1)
%       * k : number of max to take (default : 1)
%--------------------------------------------------------------------------
% Output:
%       * C : matrix containing the max (on line or column)
%       * Index : the index of the max
%--------------------------------------------------------------------------
% Date: 2014-05-28
% Author: DO Cao Tri
%--------------------------------------------------------------------------
% Example:
% a=[10 5  6; 
%     4 11 3; 
%     2 3  12];
%
% [C,Index] = max_k(a,1,2)
% C = [10 11 12;
%       4  5  6];
% Index = [1 2 3;
%          2 1 1];
%           
% [C,Index] = max_k(a,2,2)
% C = [10 6;
%      11 4;
%      12 3];
% Index = [1 3;
%          2 1;
%          3 2];         
%--------------------------------------------------------------------------

% Check the input
if nargin < 2
    dim = 1;
end

if nargin < 3
    k = 1;
end

% Compute the k maximum and their index
if dim == 1 % Column
    [tmp,IX] = sort(A, 1, 'descend');
    C        = tmp(1:k,:);
    Index    = IX(1:k,:);
elseif dim == 2 % Line
    [tmp,IX] = sort(A, 2, 'descend');
    C = tmp(:,1:k);
    Index    = IX(:,1:k);
else
    disp('Error: dimension not known')
end

end