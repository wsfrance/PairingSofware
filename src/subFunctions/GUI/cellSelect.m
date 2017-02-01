function cellSelect(src,evt)
% get indices of selected rows and make them available for other callbacks
index = evt.Indices;
if any(index)             %loop necessary to surpress unimportant errors.
    rows = index(:,1);
    set(src,'UserData',rows);
end
end

