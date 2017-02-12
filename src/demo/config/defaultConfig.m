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
option.swissRoundGroup = 'Points';

option.delimiter = ';';
option.additionnalTournamentVariable = {'Series' 'Language' 'email'};
option.timeForARound = 1800; % sec (30 min)
option.timeForRecall = [];
option.periodOfSave = 1;
option.fileNameSaveState = [pwd '\tournamentSave\0_automaticSaveTournament.mat'];
option.nameConfig = 'Default';

% User info
option.userInfo.name  = 'my_name';
option.userInfo.email ='my_adress@adress.com';



column                  = {'name', 'familyName', 'pseudo'};
option.columnTableDB    = ['WSCode', column];
option.verbose          = 1;
option.boolean_Round    = 1;
option.no_maxRound      = 6;
option.no_round         = 0;
option.columnTablePairing = {'Flt', 'Round', 'Table', 'Player1', 'Points_P1', 'Player2', 'Points_P2', 'Result'};
option.bool_Tournamentstarted = 0;
option.caseInsensitiveOption = true;
option.searchPlayer = [];
option.imageLogo = 'wsi_logo.jpg';
option.columnCapitalLetters = {'name', 'familyName', 'pseudo'};
option.turnOnOffGUI = true;
option.tmp.createTournamentBool = false;
option.sortOrderDB              = 'ascend';
option.sortOrderTournament      = 'ascend';
option.column2sortDB            = 'Sort By';
option.column2sortTournament    = 'Sort By';
option.tmp.bool_createTournament = false;
option.default_DBOnline         = 'fileforsw.csv';
option.default_DBLocal          = 'NewPlayers_local.csv';


end

