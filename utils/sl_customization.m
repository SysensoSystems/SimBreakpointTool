function sl_customization(cm)
% Simulink Customization for the SimBreakpoint Tool.
%
% Developed by: Sysenso Systems, www.sysenso.com
%

%% Register custom menu item in the tool menu
cm.addCustomMenuFcn('Simulink:ToolsMenu', @setToolsMenuItems);
cm.addCustomMenuFcn('Simulink:PreContextMenu', @setModelContextMenuItems);

end

%% Define the custom menu function.
function schemaFcns = setToolsMenuItems(callbackInfo)
% Define the Item in Menu
schemaFcns = {@setSimBreakPointMenu};
end
function schemaFcns = setModelContextMenuItems(callbackInfo)
% Define the Item in Menu
schemaFcns = {@setSimBreakPointMenu};
end

%%
function schema = setSimBreakPointMenu(callbackInfo)
schema = sl_action_schema;
schema.label = 'SimBreakpoint';
schema.callback = @SimBreakPoint_Callback;
end

function SimBreakPoint_Callback(callbackInfo)
% Launch the SimBreakpoint tool.

toolHandle = findall(groot,'Tag','Sysenso::SimBreakpoint');
if isempty(toolHandle)
    simBreakPointGUI;
else
    addButtonH = get(toolHandle,'UserData');
    addCallback = get(addButtonH,'Callback');
    addCallback(addButtonH,[]);
    figure(toolHandle);
end

end