% --- Executes on button press in BUT_refreshLocalDB.
function BUT_refreshLocalDB(hObject, eventdata, handles, defaultDB_name)
% hObject    handle to BUT_refreshLocalDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option

if nargin < 4
    defaultDB_name = option.default_DBOnline;
end


disp('-- Refreshing the local Databases')
files = listDBPlayers( );

disp(['-- ' num2str(size(files,1)) ' file(s) were found locally: '])
disp(files)
files = ['Select Database'; files];
set(handles.POP_selectDB,'String',files)

loadDefaultPlayer(hObject, eventdata, handles, defaultDB_name)