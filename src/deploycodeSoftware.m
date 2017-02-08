source_dir = 'E:\Cloud\Google Drive\WS\WS Sud France\2_Projet\H_Recode Pairing Software\code';
target_dir = 'E:\Cloud\Google Drive\WS\WS Sud France\2_Projet\H_Recode Pairing Software\PublicRelease_tournamentSoftware';


extension = {'\.txt$', '\.log$', '\.png$', '\.exe$', '\.html$', '\.ico$', '\.csv', '\.fig$', '\.zip$', '\.pdf$', ...
             '\.class$', '\.java$', '\.jpg$', '\.c$', '\.p$', '\.mat$'};

ignoreList = {'^\.git$'};       
         
deploypcode(source_dir,target_dir,'updateOnly',true, 'flattenFileTree', false, 'copyDirectStrings', extension, 'ignoreStrings', ignoreList)
