function hhsim

%HHSIM HHsim Hodgkin-Huxley simulator
%   hhsim  starts the simulator
% 
%   Click on the purple Stim1 or Stim2 buttons to inject a depolarizing or
%   hyperpolarizing current stimulus.  Click on the Membrane, Channels,
%   Stimuli or Drugs buttons to view and modify the simulation parameters.

%#function begin_stimulus
%#function call_incrbutton
%#function callbacks
%#function change_varplotlines
%#function channel_current
%#function clear_history
%#function close_all
%#function close_finally
%#function color_button
%#function copy_channel_params
%#function equilib
%#function evalrate
%#function export_data
%#function find_I
%#function find_dV
%#function generate_varplotval
%#function graph_scale
%#function graph_select
%#function help_hhsim
%#function hhsim
%#function hide_window
%#function indicate_drugs_active
%#function init_membrane
%#function iterate
%#function line_click
%#function make_drug
%#function make_gate
%#function make_gate_rate
%#function make_incrbutton
%#function make_ion
%#function make_passive_channel
%#function make_splot
%#function make_stimulus
%#function make_valbox
%#function make_valtext
%#function make_vgated_channel
%#function make_voltage
%#function max_deltaT
%#function move_cursor
%#function moveslider
%#function openurl
%#function print_data
%#function recalc_ECl
%#function recalc_EK
%#function recalc_Eset(h,'ActionPostCallback','disp(''woof!'')')Na
%#function recalc_Vr
%#function recalc_gate_graph
%#function recall_state
%#function redisplay_stim
%#function redisplay_voltage
%#function reset_channel
%#function reset_chanparams
%#function reset_cursor_values
%#function reset_drugs
%#function reset_memparams
%#function reset_stimparams
%#function reset_stimulus
%#function reset_valbox
%#function reset_voltage
%#function resize_main
%#function resize_plots
%#function run_system
%#function set_channel_button
%#function set_cursor_vis
%#function set_drug
%#function set_pronase
%#function set_valbox
%#function set_valtext
%#function set_winvis
%#function set_xaxis_limits
%#function setup_channels
%#function setup_drugs
%#function setup_main
%#function setup_membrane
%#function setup_stimuli
%#function setup_vclamp
%#function splot
%#function splot_single
%#function store_state
%#function switch_mode
%#function toggle_winvis
%#function trim_vc_values
%#function update_drugbox
%#function update_gate
%#function update_slider
%#function update_stimbox
%#function update_stimslider
%#function update_vc_slider
%#function update_vgated_channel
%#function varunits_string
%#function vc_addcurve
%#function vc_clear
%#function vc_delcurve
%#function vc_iterate
%#function vc_line_click
%#function vc_moveslider
%#function vc_movevertslider
%#function vc_reset_cursor_values
%#function vc_resize_plots
%#function vc_set_xaxis_limits
%#function vc_varselect
%#function winloc_load
%#function winloc_save

colordef none

eval('global vars handles')

global vars handles

fprintf('HHsim message window\n');
fprintf('loading ... ');

vars.code_version = '3.6';

vars.vclampmode=0;
vars.time = 0;
vars.stopflag = 0;
vars.quitflag = 0;
vars.pronase = 0;
vars.deltaT_max = max_deltaT(1);
vars.deltaT = vars.deltaT_max;		% integration step in msec
vars.deltaT_plot = max_deltaT(0);
vars.plot_rate = 3;			% plot every 3rd point
vars.V = -63.39/1000;
vars.iteration = 0;
vars.last_time = 1;
vars.nudge_time = 0;
vars.clearflag=0;
vars.recallflag=0;
vars.vc_maxc=8;
vars.vc_cached_voltage=NaN;
vars.vc_cached_current=0;

vars.state_modeswitch=struct;
vars.state_equilibrium=struct;
vars.state_saved=struct;
vars.iterating=0;

vars.write_path = '';
handles.vc_varselected=-1;

close_finally

%disp('setting membrane')
setup_membrane
%disp('setting channels')
setup_channels

%disp('setting stimuli')
setup_stimuli
%disp('setting drugs')
setup_drugs
%disp('setting vclamp window')
setup_vclamp
%disp('setting main window')
setup_main
%disp(' ')
disp('Ready.  Press the purple Stim1 or Stim2 buttons to stimulate the cell.')
disp('Click on the lines in the graph to view specific values.')

handles.zoom_obj = zoom(9);
set(handles.zoom_obj, 'ActionPostCallback', 'slider_val')

vars.iterating = 1; % suppress iteration while we init things
init_membrane
vars.stopflag = 0;
vars.iterating = 0;

vars.debug = 1;

run_system(0);

% Copyright (c) 2000,2001,2002 by David S. Touretzky, 
% Mark V. Albert, Nathaniel D. Daw and Alok Ladsariya.
