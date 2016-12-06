% EXAMPLE_PUSHPOP_POPEDIT - demo the pushpop and popedit combined uicontrols
%
%     Demonstrates how to create and utilise the PUSHPOP and POPEDIT 
%      uicontrols that are embedded into the matpigui class
%
%  Takes no input arguments
%
%    EXAMPLE_PUSHPOP_POPEDIT
%
%
%    see also matpigui
%
%  Copyright:  Matpi Ltd
%  Author:     Robert Cumming
%
% $Id$
function example_pushpop_popedit
  %%
  hFig = figure ( 'toolbar', 'none', 'menu', 'none');
  % Set the color of the figure - all tabs/pages will follow this color
  hFig.Color = [1 1 1];
  % create a matpigui object passing in the figure to build it on
  hGui = matpigui(hFig);
  
  % create 2 tabs for placing the uicontrols on
  hGui.addTab ( 'Push Pop', 0.2 );
  hGui.addTab ( 'Pop Edit', 0.2 );
  
  %% Create a PUSHPOP -> this is a push button and a popup menu
  % create a string to be used in the popup menu (the 1st entry is the one defaulted on the button
  str = { 'Button String' 'Other String' 'etc...' };
  % Create the pushpop uicontrol
  %   The str MUST be a cell array of strings
  %   A callback MUST be provided in a CELL format as shown (do not use anonymous functions)
  hGui.addUIC ( 'Push Pop', 'pop1', 'pushpop', 'String', str, 'Position', [0.1 0.8 0.3 0.1], 'Callback', {@pushPopCallback01, hGui } );
  % Create a second pushpop with the additional 'UpdateButton' option set to true.
  %    -> this will cause the button text to be updated when a pop item is selected
  str = { 'Button String (inc Update)' 'Other String' 'etc...' };
  hGui.addUIC ( 'Push Pop', 'pop2', 'pushpop', 'String', str, 'Position', [0.1 0.6 0.3 0.1], 'Callback', {@pushPopCallback02, hGui }, 'UpdateButton', true );
  % Create a text control for providing messages to the user and demo the callback.
  hGui.addUIC ( 'Push Pop', 'info', 'text', 'String', '', 'Position', [0.1 0.1 0.8 0.1] );

  %% Create a POPEDIT - this is a edit contorl and a popup menu
  str = { 'Edit String' 'Other Edit String' 'etc...' };
  % Create the popedit in the same way as before.
  %    - only change the uicontol name
  hGui.addUIC ( 'Pop Edit', 'edt1', 'popedit', 'String', str, 'Position', [0.1 0.8 0.3 0.1], 'Callback', {@pushPopCallback01, hGui } );
  % Again create a second with the updateButton flag set to true
  str = { 'Edit String (inc Update)' 'Other Edit String' 'etc...' };
  hGui.addUIC ( 'Pop Edit', 'edt2', 'popedit', 'String', str, 'Position', [0.1 0.6 0.3 0.1], 'Callback', {@pushPopCallback02, hGui }, 'UpdateEdit', true );
  % Create a text control for providing messages to the user and demo the callback
  hGui.addUIC ( 'Pop Edit', 'info', 'text', 'String', '', 'Position', [0.1 0.1 0.8 0.1] );
  
end
% For this demo both TAB controls use the same callbacks:
%  This is to demostrate
%    How to conpact your code by using common var names
%    How to interrogate the current active tab/page
%    How to update the UIC using dot syntax (all Matlab versions r2008a onwards)
%
%  When callbacks are create the MATPIGUI object will add an extra input
%    argument - this is the uicString - selected from button/edit or popup.
%  
function pushPopCallback01 ( hGui, uicString )
  % Obtain the active tab name (e.g. "Push Pop" or "Pop Edit")
  %   and replace " " with "_"
  %   this is to ensure that it is a valid fieldname
  name = regexprep ( hGui.activeName, ' ', '_' );
  % Update the info (the text uicontrol) String property
  hGui.hUIC.(name).info.String = sprintf ( 'User selected "%s"', uicString );  
end
function pushPopCallback02 ( hGui, uicString )
  % Obtain the active tab name (e.g. "Push Pop" or "Pop Edit")
  %   and replace " " with "_"
  %   this is to ensure that it is a valid fieldname
  name = regexprep ( hGui.activeName, ' ', '_' );
  % Update the info (the text uicontrol) String property
  hGui.hUIC.(name).info.String = sprintf ( 'User selected "%s" and button text was updated.', uicString );  
end