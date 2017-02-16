function [ tablePlayerOut, bool_byePlayer ] = createByePlayer( tablePlayer )
%CREATEBYEPLAYER Summary of this function goes here
%   Detailed explanation goes here

[nb_player, nb_variable] = size(tablePlayer);

% if mod(nb_player,2) == 1
    disp('-- Odd number of Players. Adding a bye Player ...')
    
    % Allocate a matrix
    byePlayer       = tablePlayer;
    variableName    = byePlayer.Properties.VariableNames;
    tmp             = cell(1,nb_variable);

    % Repeat '**BYE**' in each column of the table
    for j = 1:nb_variable
        tmp{1,j} = '**BYE**';
    end
    byePlayer       = array2table(tmp,'VariableNames',variableName);

    % Assign to the new table
    tablePlayerOut  = [tablePlayer; byePlayer];
    bool_byePlayer  = true;
% else
%     disp('-- Even number of player. All is ok. Continue ...')
%     tablePlayerOut  = tablePlayer;
%     bool_byePlayer  = false;

% end

