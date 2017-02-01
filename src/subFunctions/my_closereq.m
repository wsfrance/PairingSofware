function [ output_args ] = my_closereq( handles )
%MY_CLOSEREQ Summary of this function goes here
%   Detailed explanation goes here

% my_closereq.m
% my_closereq 
     % User-defined close request function
     % to display a question dialog box

     selection = questdlg('Close Specified Figure?',...
                          'Close Request Function',...
                          'Yes','No','Yes');
     switch selection,
        case 'Yes',
          delete(get(0,'CurrentFigure'))
        case 'No'
          return
     end


end

