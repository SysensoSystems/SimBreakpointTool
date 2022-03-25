function lineNames = getDataLoggingNames(currentSystem)
% Helps to get the list of datalogging names on the signals for the given
% model.
%
% Developed by: Sysenso Systems, www.sysenso.com
%

% Get the selected lines.
lineHandles = find_system(currentSystem,'LookUnderMasks','all','FollowLinks','on','FindAll','on','type','line');

% Initialization
ind = 1;
lineNames = {};
for ii = 1:length(lineHandles)
    % Check Datalogging is enabled or not.
    loggingStatus = get(lineHandles(ii),'DataLogging');
    % Store the name if data logging enabled.
    if loggingStatus
        % Get the log name.
        lineNames{ind} = get(lineHandles(ii),'UserSpecifiedLogName'); %#ok<*AGROW>
        ind = ind+1;
    end
end
% Unify the linenames to avoid duplicate names.
lineNames = unique(lineNames);

end
