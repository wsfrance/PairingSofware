function fileName = writeStanding()

global TABLE option

% Ask for fileName
formatOut   = 'yyyymmdd';
date_tmp    = datestr(option.tournamentInfo.dateSerial, formatOut);
[file,path] = uiputfile([date_tmp '_Standing.txt'], 'Save file name for the Standing');

% Set to default if not given
if file == 0
    currentFolder   = pwd;
    fileName        = [currentFolder '/Standing_tmp.txt'];
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