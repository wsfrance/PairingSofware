function [ output_args ] = displayErrorMsg( msg, handles_i, prefix )
%DISPLAYERRORMSG Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    prefix = '';
end

disp([prefix msg])
msgbox(msg,'Error','error');           
set(handles_i,'String',msg);

end

