function [ answer ] = dlboxQuit( )
%DLBOXQUIT Summary of this function goes here
%   Detailed explanation goes here

% Construct a questdlg with three options
choice = questdlg('Do you want to close this window?', ...
	'Question', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        disp([choice ' coming right up.'])
        answer = true;
    case {'No',''}
        disp([choice ' coming right up.'])
        answer = false;
    otherwise
        disp('Case for question to quit not known')
end


end

