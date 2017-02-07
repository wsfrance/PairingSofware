%----------------------------------------------------------------------------
function StopTimer(handles)
try
	fprintf('Entering StopTimer...\n');
	listOfTimers = timerfindall % List all timers, just for info.
	% Get handle to the one timer that we should have.
	if isempty(listOfTimers)
		% Exit if there is no timer to turn off.
		fprintf('There are no timers to turn off. Leaving StopTimer().\n');
		return;
	end
	% handleToTimer = getappdata(handles.timerGUI, 'timerObj');
	% Stop that timer.
	% stop(handleToTimer);
	% Delete all timers from memory.
	listOfTimers = timerfindall;
	if ~isempty(listOfTimers)
		delete(listOfTimers(:));
	end
	fprintf('Left StopTimer and turned off all timers.\n');
catch ME
	errorMessage = sprintf('Error in StopTimer().\nThe error reported by MATLAB is:\n\n%s', ME.message);
	fprintf('%s\n', errorMessage);
	% WarnUser(errorMessage);
end
return; % from btnStopTimer_Callback