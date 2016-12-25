function [ output_args ] = turnOnGUI( handles, InterfaceObj, oldpointer, option )
%TURNONGUI Summary of this function goes here
%   Detailed explanation goes here

if option.turnOnOffGUI
    % We turn back on the interface
    set(InterfaceObj,'Enable','on');
    set(handles.figure1, 'pointer', oldpointer)
end

end

