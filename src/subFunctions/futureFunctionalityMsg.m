function [ output_args ] = futureFunctionalityMsg( handles )
%FUTUREFUNCTIONALITYMSG Summary of this function goes here
%   Detailed explanation goes here

disp('--------------------------------------------------------------------')
msg  = 'Function will be added in the future' ;
% disp(msg)
% msgbox(msg, 'Error', 'error')
handles_i = handles.TXT_error;
prefix = '';
displayErrorMsg( msg, handles_i, prefix )


end

