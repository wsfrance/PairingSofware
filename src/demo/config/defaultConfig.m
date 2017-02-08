function [  ] = defaultConfig(  )
%DEFAULTCONFIG Summary of this function goes here
%   Detailed explanation goes here

global option

option.winningPoint     = 3;
option.losePoint        = 0;
option.tiePoint         = 0.5;

% option.column2ranking = {'Points', 'Modified_Median', 'Cumulative_Score', 'Solkoff'};
% option.column2ranking = {'Points', 'Opp_MW'};
% option.column2sort = {'Points', 'Modified_Median', 'Solkoff', 'Cumulative_Score', 'first_Loss'};
% option.sortType = {'descend', 'descend', 'descend', 'descend', 'descend'};
% option.column2sort = {'Points', 'Opp_MW'};
% option.sortType = {'descend', 'descend'};
option.column2sort  = {'Points' , 'Opp_MW' , 'Modified_Median', 'Solkoff', 'Cumulative_Score', 'first_Loss'};
option.sortType     = {'descend', 'descend', 'descend'        , 'descend', 'descend'         , 'descend'};
option.swissRoundType = 'Monrad';

option.delimiter = ';';
option.additionnalTournamentVariable = {'Series' 'Language' 'email'};
option.timeForARound = 1800; % sec (30 min)
option.periodOfSave = 1;
option.fileNameSaveState = [pwd '\config\tmp_variable.mat'];
option.nameConfig = 'Default';

end

