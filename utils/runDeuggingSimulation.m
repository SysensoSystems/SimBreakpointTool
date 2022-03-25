function runDeuggingSimulation(currentSystem)
% Helps to simulate the simulink model in each time step and tests the user
% defined condition to stop the simulation. If condition is true then the
% simulation will be stopped and the signal values can be verified.
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.

%--------------------------------------------------------------------------
% Check if the condition statements are present, else return.
conditionStatement = getappdata(0,'conditionStatement');
if isempty(conditionStatement)
    warndlg('Please enter a Condition');
    return;
end

%--------------------------------------------------------------------------
% Get the current simulation status.
simStatus = get_param(currentSystem,'SimulationStatus');
if strcmp(simStatus,'stopped')
    % Start the simulation.
    set_param(currentSystem,'SimulationCommand','Start','SimulationCommand', 'pause');
    runSimulationTimeStep(currentSystem,conditionStatement);
else
    % If Simulation already running warn the user.
    warndlg('Please stop the Simulation to Proceed');
end

end

%--------------------------------------------------------------------------
function runSimulationTimeStep(currentSystem,conditionStatement)

% Check for simulation to stop.
simStatus = get_param(currentSystem,'SimulationStatus');
% This pause is required only for releases like R2015B. If we remove this
% pause, signal logging is not getting populated during run. in higher
% releases like R2019B, this pause can be removed.
pause(0.5);
while ~strcmp(simStatus,'stopped')
    set_param(currentSystem,'SimulationCommand','step')
    %----------------------------------------------------------------------
    % Get the logging data
    lineNames = getDataLoggingNames(currentSystem);
    % Get the simulation time
    simTime = get_param(currentSystem,'SimulationTime');
    assignin('base','SimulationTime',simTime);
    % Assignin the logging data to the base workspace.
    if(~isempty(lineNames))
        currentlogObjName = getappdata(0,'SignalLoggingName');
        for ind = 1:length(lineNames)
            if ~isempty(lineNames{ind})
                assignin('base',lineNames{ind},evalin('base',[currentlogObjName '.getElement(''' lineNames{ind} ''').Values.data(end)']));
            end
        end
    else
        % Step forward to get next time step.
        set_param(currentSystem,'SimulationCommand','Step');
    end
    %----------------------------------------------------------------------
    % Check the Condition
    try
        conditionStatus = evalin('base',conditionStatement);
    catch
        set_param(currentSystem,'SimulationCommand','Stop');
        return;
    end
    %----------------------------------------------------------------------
    if conditionStatus
        set_param(currentSystem, 'SimulationCommand', 'pause');
        %------------------------------------------------------------------
        % Get the callback and evaluate it. If it produces error, then stop
        % the simulation.
        conditionCallbackFunction = getappdata(0,'callbackFunction');
        try
            eval(conditionCallbackFunction);
        catch exceptionObj
            errordlg(['Error during executing the SimBreakpoint callback' char(10) exceptionObj.message],'Callback Error','modal');
            set_param(currentSystem,'SimulationCommand','Stop');
            return;
        end
        %------------------------------------------------------------------
        % Prompt the user for further actions
        buttonHandle = questdlg('Simulation Paused : Select an action',...
            'Further Action', ...
            'continue', 'stop','stop');
        waitfor(buttonHandle);
        switch(buttonHandle)
            case 'continue'
                set_param(currentSystem,'SimulationCommand','continue','SimulationCommand', 'pause');
                runSimulationTimeStep(currentSystem,conditionStatement);
            case 'stop'
                set_param(currentSystem,'SimulationCommand','Stop');
            case ''
                % If question dialogue is closed, the stop the
                % simulation.
                set_param(currentSystem,'SimulationCommand','Stop');
        end
    end
    %----------------------------------------------------------------------
    simStatus = get_param(currentSystem,'SimulationStatus');
end

end
%--------------------------------------------------------------------------