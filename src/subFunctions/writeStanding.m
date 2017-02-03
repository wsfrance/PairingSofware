function [fileName, fileCSV] = writeStanding()

global TABLE option

% Ask for fileName
formatOut   = 'yyyymmdd';
date_tmp    = datestr(option.tournamentInfo.dateSerial, formatOut);
[file,path] = uiputfile(['../../export/' date_tmp '_Standing.txt'], 'Save file name for the Standing');

% Set to default if not given
if file == 0
    currentFolder   = pwd;
    file            = '/Standing_tmp.txt';
    fileName        = [currentFolder file];
    disp(['Default fileName: ' fileName])
    disp(['File will be saved in : ' fileName])
else
    fileName = [path file];
end

% Write header
fid         = fopen( fileName, 'wt' );
nb_endRound = size(TABLE.HistoryTABLE,1);
tableIn     = TABLE.HistoryTABLE.standing{nb_endRound};

% Write standings
header = ['Standings - Neo Standard - ' option.tournamentInfo.location ' - ' option.tournamentInfo.date ':'];
fprintf( fid, '%s\n\n', header);
for i = 1:size(tableIn,1)
    fprintf( fid, '%d. %s,%s (%s)\n', tableIn.Ranking(i), tableIn.name{i}, tableIn.familyName{i}, tableIn.WSCode{i});
end
fclose(fid);

disp('Export final Standings in .csv')
fileNameCSV = file(1:end-4);
fileCSV = [path fileNameCSV '.csv'];
T = TABLE.tablePlayers_FINAL;
T.playerId = [];
writetable(T,fileCSV,'Delimiter',';');