function quitApplication ()
disp('- Quit Excel')
try
	% See if there is an existing instance of Excel running.
	% If Excel is NOT running, this will throw an error and send us to the catch block below.
	Excel = actxGetRunningServer('Excel.Application');
	% If there was no error, then we were able to connect to it.
	Excel.Quit; % Shut down Excel.
    
    Quit(Excel)
    delete(Excel)
    
    % Just to be sure
    % dos('taskkill /F /IM Excel.exe');
    
    disp('-- Success')
catch
	% No instance of Excel is currently running.
    disp('-- Fail')
end

disp('- Quit Acrobat')
try
    dos('taskkill /F /IM Acrobat.exe');
    disp('-- Success')
catch
    disp('-- Fail')
end