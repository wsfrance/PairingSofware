function [ InterfaceObj, oldpointer ] = turnOffGUI( handles, option )
%TURNOFFGUI Summary of this function goes here
%   Detailed explanation goes here

if option.turnOnOffGUI
    % We turn the interface off for processing.
    InterfaceObj=findobj(handles.figure1,'Enable','on');
    set(InterfaceObj,'Enable','off');
    oldpointer = get(handles.figure1, 'pointer'); 
    set(handles.figure1, 'pointer', 'watch') 
    drawnow;
else
    InterfaceObj = [];
    oldpointer = [];
end


end

