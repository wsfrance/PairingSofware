function [ InterfaceObj, oldpointer ] = turnOffGUI( handlesFigure, option )
%TURNOFFGUI Summary of this function goes here
%   Detailed explanation goes here

if option.turnOnOffGUI
    % We turn the interface off for processing.
    InterfaceObj=findobj(handlesFigure,'Enable','on');
    set(InterfaceObj,'Enable','off');
    oldpointer = get(handlesFigure, 'pointer'); 
    set(handlesFigure, 'pointer', 'watch') 
    drawnow;
else
    InterfaceObj = [];
    oldpointer = [];
end


end

