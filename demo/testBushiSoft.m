%% Bushiroad re-code software pairing
% Author: Cao Tri DO
% Date: 2016-12-01

%% Matlab clean up
clear
close all
clc

%% Add path
pathstr = addPath_bushisoft ();

%% Generate Tables
[ tablePlayers_fromDB, tablePlayers_forTournament ] = generateTable();

%% Main core
FinalRanking = bushiMain( tablePlayers_fromDB, tablePlayers_forTournament );
