function b = saveState(periodOfSave)
% b is the timer

b = timer;
% disp(toc(tStart))
set(b,'ExecutionMode','fixedRate')
set(b,'TimerFcn', @(~,~)subSaveState, 'Period', periodOfSave);
start(b)

end


function subSaveState()

global TABLE MATRICE option 
filename = '/config/tmp_variable.mat';
save(filename,'TABLE', 'MATRICE', 'option')
disp('Variable save')

end
