function b = saveState(periodOfSave)
% b is the timer
% Execute in background. Doesn't affect current matlab work

b = timer;
% disp(toc(tStart))
set(b,'ExecutionMode','fixedRate')
set(b,'TimerFcn', @(~,~)subSaveState, 'Period', periodOfSave);
start(b)

end


function subSaveState()

global TABLE MATRICE option 
save(option.fileNameSaveState,'TABLE', 'MATRICE', 'option')
% disp('Variable save')

end
