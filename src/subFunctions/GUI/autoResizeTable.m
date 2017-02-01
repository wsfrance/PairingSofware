function [ output_args ] = autoResizeTable( UITable )
%AUTORESIZE Summary of this function goes here
%   Detailed explanation goes here

% source : http://undocumentedmatlab.com/blog/uitable-cell-colors/

% handles.TAB_standing
% Second pass – auto-resizing that actually works…
jScroll = findjobj(UITable);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

end

