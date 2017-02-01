function [ files ] = listDBPlayers( )
%LISTDBPLAYERS Summary of this function goes here
%   Detailed explanation goes here

dirName = '../data/playerDB';               %# folder path
files = dir( fullfile(dirName,'*.csv') );   %# list all *.xyz files
files = {files.name}';                      %'# file names

end

