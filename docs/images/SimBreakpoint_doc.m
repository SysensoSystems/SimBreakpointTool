%% *|SimBreakpoint Tool|*
%
% This tool will be helpful for setting conditional break point in a given model for debugging purpose.
% model for debugging purpose.
%
%
% Developed by: Sysenso Systems, https://sysenso.com/
%
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.
%
%
% *|Steps to use this tool|*
%%
%
% * |Download and move the files into the required path and add it to MATLAB path|
%
% <<\images\path.png>>
%
%%
%
% * |Open the Simulink model that has to be debugged.|
%
% * |Ensure that in Simulink Tools menu has a menu item 'SimBreakpoint' is present. If not, run the command ">> sl_refresh_customizations" in the MATLAB command window|
%
% <<\images\toolsmenu.png>>
%
%%
% * |SimBreakpoint tool can be launched from Tools/SimBreakpoint menu or from the model context menu.|
%
% <<\images\contextmenu.png>>
%
%%
% * |Select the signal and add it to the GUI(Reference Signals Panel). User have to give a unique signal label for every entry.|
%
% <<\images\addsignal.png>>
%
%%
% * |Enter the breakpoint condition (Example : SimulationTime == 1 && signalA < signalB). signalA and signalB should present in the Reference Signals Panel. 
% SimulationTime will refer the model simulation time.|
%
% <<\images\condition.png>>
%
%%
%
% * |Use "Run" button to initiate simulation in the custom debugging model.|
%
%%
%
% * |The breakpoint condition will be evaluated during every timestep. If it is true then the simulation will be paused for the user to explore the model.|
%
% <<\images\breakpoint.png>>
%
%%
%
% * |Either user can stop the simulation or continue the simulation with the breakpoint condition.|
%
% <<\images\useraction.png>>
%
%%
%
% * |Optional: User can add a callback function which will be evaluated when the breakpoint scenario happens.|
%
% <<\images\callback.png>>
%
