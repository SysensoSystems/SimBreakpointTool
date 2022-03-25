classdef simBreakPointGUI
% Helpful for setting conditional break point in a given model for
% debugging purpose. 
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.
% 
    properties
        addButtonH;
        removeButtonH;
        clearButtonH;
        runButtonH;
        closeButtonH;
        helpButtonH;
        conditionEditBox;
        callbackEditbox;
    end
    properties (Hidden)
        figH;
        textPanelH;
        refSignalsPanelH;
        refDataTable;
        conditionPanelH;
        callbackPanelH;
        operationPanelH;
    end
    methods
        function obj = simBreakPointGUI(varargin)
            % Create new figure and move it to center
            obj.figH = figure('Name','SimBreakPoint','units','normalized','numberTitle','off','Position',[0 0 0.36 0.6]);
            set(obj.figH,'Tag','Sysenso::SimBreakpoint');
            set(obj.figH,'MenuBar', 'none','ToolBar','none','Resize', 'off');
            % Set the minimum figure size
            %LimitFigSize(obj.figH,'max',[60 60])
            %--------------------------------------------------------------
            % Create uigrid container
            %--------------------------------------------------------------
            mainFrameH = uigridcontainer('v0','Parent',obj.figH);
            set(mainFrameH,'GridSize',[5,1]);
            set(mainFrameH,'VerticalWeight',[0.165 0.45 0.165 0.109 0.08]);
            %--------------------------------------------------------------
            % Create the required panels
            %--------------------------------------------------------------
            % Text Panel
            obj.textPanelH = uipanel('parent',mainFrameH);
            % Reference signals panel
            obj.refSignalsPanelH = uipanel('parent',mainFrameH,'Title','Reference Signals');
            % Condition panel
            obj.conditionPanelH = uipanel('parent',mainFrameH,'Title','Conditional Breakpoint');
            % Callback panel
            obj.callbackPanelH =  uipanel('parent',mainFrameH,'Title','Callback on Breakpoint');
            % Button panel
            obj.operationPanelH = uipanel('parent',mainFrameH);
            %--------------------------------------------------------------
            % Text panel items
            %--------------------------------------------------------------
            textFrame = uiflowcontainer('v0',obj.textPanelH,'units','normalized');
            infoText{1,1} = [char(10) 'Helps to debug the model using conditional breakpoint. Condition can be framed by referring multiple signals and '];
            infoText{1,2} = 'simulation time(SimulationTime).';
            infoText{1,3} = 'When the condition was true during simulation, the assigned callback(if added) will be triggered.';
            infoText{1,4} = 'As of now, only one conditional breakpoint can be added at a time.';
            infoText{1,5} = 'This can be used as a model verification tool to verifiy the simulation scenario without adding model blocks.';
            infoText{1,6} =  [char(10) 'Contact: contactus@sysenso.com, https://sysenso.com/'];
            % Create text string
            textPanelH_Text = uicontrol(textFrame,'Style','text','String',char(infoText),'units','normalized',...
                'HorizontalAlignment','left','FontSize',9);
            %--------------------------------------------------------------
            % Reference signals panel items
            %--------------------------------------------------------------
            referenceFrame = uigridcontainer('v0',obj.refSignalsPanelH,'units','normalized');
            set(referenceFrame,'GridSize',[3,1]);
            set(referenceFrame,'VerticalWeight',[0.07 0.73 0.1]);
            % Text box
            referenceText = 'Add Reference Signals from the Model and Label them';
            refSignalsPanelH_Text = uicontrol(referenceFrame,'Style','text','String',referenceText,'units','normalized',...
                'HorizontalAlignment','left','FontSize',10);
            tableColumnNames = {'Signal Path', 'OutPort Number', 'Name'};
            tableColumnWidth = {380,100,170};
            % Table
            obj.refDataTable = uitable(referenceFrame,'units','normalized','ColumnEditable',[false false true],'ColumnName',tableColumnNames,...
                'ColumnWidth',tableColumnWidth);
            % Buttons
            buttonFame = uiflowcontainer('v0','parent',referenceFrame);
            leftEmpty = uicontainer(buttonFame);
            set(leftEmpty, 'HeightLimits',[25,35], 'WidthLimits',[60,inf]);
            obj.addButtonH = uicontrol(buttonFame,'style','pushbutton','String','Add');
            set(obj.addButtonH, 'HeightLimits',[25,35], 'WidthLimits',[60,100]);
            center1Empty = uicontainer(buttonFame);
            set(center1Empty, 'HeightLimits',[25,35], 'WidthLimits',[60,inf]);
            obj.removeButtonH = uicontrol(buttonFame,'style','pushbutton','String','Remove');
            set(obj.removeButtonH, 'HeightLimits',[25,35], 'WidthLimits',[60,100]);
            center2Empty = uicontainer(buttonFame);
            set(center2Empty, 'HeightLimits',[25,35], 'WidthLimits',[60,inf]);
            obj.clearButtonH =  uicontrol(buttonFame,'style','pushbutton','String','Clear');
            set(obj.clearButtonH, 'HeightLimits',[25,35], 'WidthLimits',[60,100]);
            rightEmpty = uicontainer(buttonFame);
            set(rightEmpty, 'HeightLimits',[25,35], 'WidthLimits',[60,inf]);
            %--------------------------------------------------------------
            % Condition panel items
            %--------------------------------------------------------------
            conditionFrame = uiflowcontainer('v0',obj.conditionPanelH,'units','normalized');
            set(conditionFrame,'FlowDirection','TopDown');
            % Text box
            conditionText{1,1} = 'Enter the condition for Breakpoint. To refer model simulation time "SimulationTime" label can be used.';
            conditionText{1,2} = 'Examples:';
            conditionText{1,3} = '1. SimulationTime >= 2, To pause model when simulation time reaches 2.';
            conditionText{1,4} = '2. (Signal <= Signal2) && (SimulationTime > 5)';
            conditionText{1,5} = '3. (Signal <= Signal2) || (SimulationTime > 5)';
            conditionPanelH_Text = uicontrol(conditionFrame,'Style','text','String',char(conditionText),'units','normalized',...
                'HorizontalAlignment','left','FontSize',9);
            set(conditionPanelH_Text, 'HeightLimits',[10,70], 'WidthLimits',[60,inf]);
            % Edit box
            obj.conditionEditBox = uicontrol(conditionFrame,'Style','Edit','String','','units','normalized',...
                'HorizontalAlignment','center','FontSize',10);
            set(obj.conditionEditBox, 'HeightLimits',[10,25]);
            %--------------------------------------------------------------
            % Callback panel items
            %--------------------------------------------------------------
            callbackFrame = uiflowcontainer('v0',obj.callbackPanelH,'units','normalized');
            set(callbackFrame,'FlowDirection','TopDown');
            callbackText = ['Enter the callback function. For example, msgbox(''Simulation Paused'')'];
            % Text box
            callbackPanelH_Text = uicontrol(callbackFrame,'Style','text','String',callbackText,'units','normalized',...
                'HorizontalAlignment','left','FontSize',10);
            set(callbackPanelH_Text, 'HeightLimits',[10,30], 'WidthLimits',[60,inf]);
            % Edit box
            obj.callbackEditbox = uicontrol(callbackFrame,'Style','Edit','String','','units','normalized',...
                'HorizontalAlignment','center','FontSize',10);
            set(obj.callbackEditbox, 'HeightLimits',[10,25]);
            %--------------------------------------------------------------
            % Button panel items
            %--------------------------------------------------------------
            % Buttons
            operationFrame = uiflowcontainer('v0','parent',obj.operationPanelH,'Position',[0.01 0.01 0.98 0.85]);
            set(operationFrame,'FlowDirection','LeftToRight');
            leftEmpty = uicontainer(operationFrame);
            set(leftEmpty, 'HeightLimits',[20,30], 'WidthLimits',[60,inf]);
            obj.runButtonH = uicontrol(operationFrame,'style','pushbutton','String','Run');
            set(obj.runButtonH, 'HeightLimits',[20,30], 'WidthLimits',[60,100]);
            center1Empty = uicontainer(operationFrame);
            set(center1Empty, 'HeightLimits',[20,30], 'WidthLimits',[60,inf]);
            obj.closeButtonH = uicontrol(operationFrame,'style','pushbutton','String','Close');
            set(obj.closeButtonH, 'HeightLimits',[17,30], 'WidthLimits',[60,100]);
            center2Empty = uicontainer(operationFrame);
            set(center2Empty, 'HeightLimits',[20,30], 'WidthLimits',[60,inf]);
            obj.helpButtonH =  uicontrol(operationFrame,'style','pushbutton','String','Help');
            set(obj.helpButtonH, 'HeightLimits',[20,30], 'WidthLimits',[60,100]);
            rightEmpty = uicontainer(operationFrame);
            set(rightEmpty, 'HeightLimits',[20,30], 'WidthLimits',[60,inf]);
            %--------------------------------------------------------------
            % Move gui to center of screen
            movegui(obj.figH,'center');
            setappdata(obj.figH,'lineHandles','');
            %--------------------------------------------------------------
            % Set callbacks
            set(obj.addButtonH,'CallBack',@(hObject,event)Add_Button_Callback(obj,hObject,event));
            set(obj.removeButtonH,'CallBack',@(hObject,event)Remove_button_Callback(obj,hObject,event));
            set(obj.clearButtonH,'CallBack',@(hObject,event)Clear_button_Callback(obj,hObject,event));
            set(obj.refDataTable,'CellSelectionCallback',@(hObject,event)Table_CellSelectionCallback(obj,hObject,event));
            set(obj.runButtonH,'CallBack',@(hObject,event)Run_button_Callback(obj,hObject,event));
            set(obj.closeButtonH,'CallBack',@(hObject,event)Close_button_Callback(obj,hObject,event));
            set(obj.helpButtonH,'CallBack',@(hObject,event)Help_button_Callback(obj,hObject,event));
            Add_Button_Callback(obj, [], []);
            set(obj.figH,'UserData',obj.addButtonH);
            %--------------------------------------------------------------
            % Add button
            function obj = Add_Button_Callback(obj,hObject, eventdata)
                % Add the selected lines in the current system.
                currentSystem = gcs;
                % Check if the model is opened.
                if isempty(currentSystem)
                    warndlg('Please Open a model to proceed');
                    return;
                end
                selectedLines = getSelectedLines(currentSystem);
                if isempty(selectedLines)
                    % Open the Model
                    open_system(bdroot(gcs));
                    selectDialogHandle = questdlg('Select the signals and press OK to add those to the SimBreakpoint Tool.',...
                        'Select Signals', ...
                        'OK', 'Close','OK');
                    % Wait for the user to select the signal.
                    waitfor(selectDialogHandle);
                    switch(selectDialogHandle)
                        case 'OK'
                            currentSystem = gcs;
                            selectedLines = getSelectedLines(currentSystem);
                            if isempty(selectedLines)
                                return;
                            end
                        case 'Close'
                            return;
                        case ''
                            return;
                    end
                end
                % Set the CurrentSystem in appdata.
                setappdata(obj.runButtonH,'currentSystem',currentSystem);
                %----------------------------------------------------------
                % Get the current tableData information.
                tableData = get(obj.refDataTable,'Data');
                signalCount = size(tableData,1)+1;
                % Validate the Data.
                if isempty(tableData)
                    % Initialize Data.
                    signalPathData = {};
                    portData = {};
                    nameData = {};
                else
                    signalPathData = {tableData{:,1}};
                    portData = {tableData{:,2}};
                    nameData = {tableData{:,3}};
                end
                %----------------------------------------------------------
                % Get the current line Handles
                currentHandles = getappdata(obj.figH,'lineHandles');
                if(isempty(currentHandles))
                    lineHandles = {};
                else
                    lineHandles = currentHandles;
                end
                %----------------------------------------------------------
                % Get the selected line
                for ii = 1:length(selectedLines)
                    % Set the Data logging on.
                    set(selectedLines(ii),'DataLogging',true);
                    signalPortHandle = get(selectedLines(ii),'SourcePort');
                    % Get the signal path.
                    signalBlockHandle = get(selectedLines(ii),'SrcBlockHandle');
                    signalPath = getfullname(signalBlockHandle);
                    % Get port number.
                    portNumber = signalPortHandle((strfind(signalPortHandle,':')+1):length(signalPortHandle));
                    % Get the name of the signal.
                    signalName = get(selectedLines(ii),'Name');
                    if(~isempty(signalPortHandle))
                        % Set the signal source name.
                        signalPathData{signalCount} = signalPath;
                        % Set the portData.
                        portData{signalCount} = portNumber;
                        % Set the name of the signal.
                        nameData{signalCount} = signalName;
                        lineHandles{signalCount} = selectedLines(ii);
                        signalCount = signalCount+1;
                    end
                end
                %----------------------------------------------------------
                % Set the new table data, use unique information.
                tableData = [signalPathData' portData' nameData'];
                tableString = {};
                for ii = 1:size(tableData,1)
                    tableString{ii} = [tableData{ii,1} '/' tableData{ii,2}];
                end
                [C,index] = unique(tableString,'stable');
                set(obj.refDataTable,'Data',tableData(index,:));
                setappdata(obj.figH,'lineHandles',lineHandles(index));
                
            end
            %==============================================================
            function selectedLines = getSelectedLines(currentSystem)
                % Gets the selected lines in the current system.
                selectedLines = [];
                % Find the selected lines for data logging.
                selectedLines = find_system(currentSystem,'LookUnderMasks','all','FollowLinks','on','SearchDepth',1,'FindAll','on','type','line','Selected','on');
            end
            %==============================================================
            % Remove button
            function obj = Remove_button_Callback(obj,hObject, eventdata)
                % Remove the selected signal from the table.
                % Get the current table Data.
                tableData = get(obj.refDataTable,'Data');
                if isempty(tableData)
                    return;
                end
                rowSize =  size(tableData,1);
                selectedRow = getappdata(obj.refDataTable,'selectedRow');
                if isempty(selectedRow)
                    selectedRow = rowSize;
                elseif(selectedRow > rowSize)
                    return;
                end
                % Remove selected row.
                tableData(selectedRow,:) = [];
                %----------------------------------------------------------
                % Get the current line handles and update it.
                lineHandles = getappdata(obj.figH,'lineHandles');
                try
                    % Disable datalogging.
                    currentHandle = lineHandles{selectedRow};
                    set(currentHandle,'DataLogging',false);
                    signalName = get(currentHandle,'DataLoggingNameMode');
                    if(strcmp(signalName,'Custom'))
                        set(currentHandle,'UserSpecifiedLogName','');
                        set(currentHandle,'Name','');
                        set(currentHandle,'DataLoggingNameMode','Use signalPortHandle Name');
                    end
                catch
                    % Do nothing. We will be handling it when the GUI will be closed.
                end
                lineHandles(selectedRow) = [];
                %----------------------------------------------------------
                % Set the new data.
                setappdata(obj.figH,'lineHandles',lineHandles);
                set(obj.refDataTable,'Data',tableData);
            end
            %==============================================================
            % Clear button
            function obj = Clear_button_Callback(obj,hObject,eventdata)
                % Clear the selected signal in the table.
                % Get the Data Logging Enabled Signals
                lineHandles = getappdata(obj.figH,'lineHandles');
                for j = 1:length(lineHandles)
                    try
                        % Disable Data logging.
                        set(lineHandles{j},'DataLogging',0);
                        signalName = get(lineHandles{j},'DataLoggingNameMode');
                        % Remove custom name.
                        if(strcmp(signalName,'Custom'))
                            set(lineHandles{j},'UserSpecifiedLogName','');
                            set(lineHandles{j},'Name','');
                            set(lineHandles{j},'DataLoggingNameMode','Use signalPortHandle Name');
                        end
                    catch
                        % Do nothing. We will be handling it when the GUI will be closed.
                    end
                end
                % Set the empty data.
                set(obj.refDataTable,'Data',{});
                setappdata(obj.figH,'lineHandles',[]);
            end
            %==============================================================
            function Table_CellSelectionCallback(obj,hObject, eventdata)
                if(~isempty(eventdata.Indices))
                    selectedRow = eventdata.Indices(1);
                    setappdata(obj.refDataTable,'selectedRow',selectedRow);
                end
            end
            %==============================================================
            function obj = Run_button_Callback(obj,hObject, eventdata)
                % Set the model to run with conditional breakpoint.
                currentSystem = getappdata(obj.runButtonH,'currentSystem');
                try
                    instrumentedSignals = get_param(currentSystem,'InstrumentedSignals');
                    setappdata(obj.figH,'instrumentedSignals',instrumentedSignals);
                catch
                end
                %----------------------------------------------------------
                % Enable the data logging in the signals.
                lineHandles = getappdata(obj.figH,'lineHandles');
                tableData = get(obj.refDataTable,'Data');
                if ~isempty(tableData)
                    signalData = {tableData{:,1}};
                    portData = {tableData{:,2}};
                    namesData = {tableData{:,3}};
                    for ind = 1:length(namesData)
                        try
                            signalName = get(lineHandles{ind},'Name');
                        catch
                            warndlg('Model handles are invalid');
                            return;
                        end
                        if isempty(signalName)
                            % Set custom name for signal
                            set(lineHandles{ind},'DataLoggingNameMode','custom');
                            % Get the name from the tableNameData
                            if ~isempty(namesData{ind})
                                customName = namesData{ind};
                            else
                                warndlg(['Please Enter the Name for ' signalData{ind} ':' portData{ind} ' signalPortHandle']);
                                return;
                            end
                            % Set the Name to signal name
                            set(lineHandles{ind},'Name',customName);
                            % Set the LogName
                            set(lineHandles{ind},'UserSpecifiedLogName',customName);
                        else
                            % Set the LogName as signal name
                            set(lineHandles{ind},'UserSpecifiedLogName',signalName);
                        end
                    end
                else
                    warndlg('Please add signal data');
                    return;
                end
                %----------------------------------------------------------
                % Check for condition availability.
                conditionStatement = get(obj.conditionEditBox,'String');
                if ~isempty(conditionStatement)
                    setappdata(0,'conditionStatement',conditionStatement);
                else
                    warndlg('Please enter a condition statement.');
                    return;
                end
                %----------------------------------------------------------
                % Get the callback function if provided.
                callbackFunction = get(obj.callbackEditbox,'String');
                setappdata(0,'callbackFunction',callbackFunction);
                %----------------------------------------------------------
                % Call the custom simulation function.
                currentSystem = getappdata(obj.runButtonH,'currentSystem');
                if ~isempty(currentSystem)
                    open_system(currentSystem);
                    % Change the signalLogging Name to logsout in the configuration
                    % property.
                    currentlogName = get_param(currentSystem,'SignalLoggingName');
                    if isempty(currentlogName)
                        currentlogName = 'logsout';
                    end
                    set_param(currentSystem,'SignalLoggingName',currentlogName);
                    setappdata(0,'SignalLoggingName',currentlogName);
                    runDeuggingSimulation(currentSystem);
                end
                
            end
            %==============================================================
            % Cancel button
            function obj = Close_button_Callback(obj,hObject, eventdata)
                if isappdata(0,'conditionStatement')
                    rmappdata(0,'conditionStatement');
                    setappdata(obj.figH,'lineHandles','');
                end
                if isappdata(0,'callbackFunction')
                    rmappdata(0,'callbackFunction');
                end
                % Revert the instrumented signals.
                if isappdata(obj.figH,'instrumentedSignals')
                    instrumentedSignals = getappdata(obj.figH,'instrumentedSignals');
                    currentSystem = getappdata(obj.runButtonH,'currentSystem');
                    set_param(currentSystem,'InstrumentedSignals',instrumentedSignals);
                end
                close(obj.figH);
            end
            %==============================================================
            % Help button
            function obj = Help_button_Callback(obj,hObject, eventdata)
                filePath = mfilename('fullpath');
                folderpath = fileparts(filePath);
                readmePath = [folderpath filesep 'readme.txt'];
                open(readmePath);
            end
            %==============================================================
        end
    end
    
end
%==========================================================================