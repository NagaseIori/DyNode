/// @description Draw some infos

// Time Info

if(topBarTimeA > 0) {
	var _nx = 0.5 * global.resolutionW, _ny = 20;
	var _ntime = musicLength;
	
	if(topBarMouseInbound || topBarMousePressed)
		_ntime = mouse_x / global.resolutionW * musicLength;
	
	draw_set_font(fMono16);
	draw_set_color_alpha(merge_color(c_white, themeColor, topBarTimeGradA * 0.5), topBarTimeA);
	draw_set_halign(fa_center); draw_set_valign(fa_top);
	draw_text(_nx, _ny, (nowTime<0?"-":"") + format_time_string(abs(nowTime)) + " / "+format_time_string(_ntime))
	draw_set_alpha(1);
}

// Chart stats

if(showStats > 0)
scribble("[sprNote] "+stat_string(showStats, 0)
	+" [scale,0.5][sprChain][/s] "+stat_string(showStats, 1)
	+" [scale,0.5][sprHoldEdge][/s] "+stat_string(showStats, 2)
	+ " Total " + stat_string(showStats, 3))
	.starting_format("fMono16", c_white)
	.align(fa_center, fa_bottom)
	.draw(global.resolutionW/2, global.resolutionH-3);

// Debug

if(!showDebugInfo) return;

var _debug_str = "";
_debug_str += "DyNode " + VERSION + "\n";
_debug_str += "by NordLandeW x NagaseIori\n";
_debug_str += "FPS: " + string(fps) + "\nRFPS: "+string(fps_real)+"\n";
_debug_str += "DSPD: " + string(animTargetPlaybackSpeed)+"\n";
_debug_str += "MSPD: " + string(musicSpeed)+"\n";
_debug_str += "TIME: " + string(nowTime)+"\n";
_debug_str += "NCNT: " + string(chartNotesCount)+"\n";
// _debug_str += "MUSICTIME: " + string(FMODGMS_Chan_Get_Position(channel)) + "\n";
// _debug_str += "MUSICDELAY: " + string(sfmod_channel_get_position(channel, sampleRate) - nowTime) + "\n";
_debug_str += "FMOD CPU Usage: " + string(FMODGMS_Sys_Get_CPUUsage()) + "\n";

// var _stat = gc_get_stats();
// _debug_str += "T_TIME: " + string(_stat.traversal_time) + "\n";
// _debug_str += "C_TIME: " + string(_stat.collection_time) + "\n";
_debug_str += "INST_C: " + string(instance_count) + "\n";
_debug_str += "V_STATUS: " + string(video_get_status()) + "\n";
_debug_str += "editorside: " + string(editor_get_editside()) + "\n";
_debug_str += $"SAMPLERATE: {sampleRate}\n";
_debug_str += $"Lst_key: {keyboard_lastkey}\n";
if(instance_exists(editor))
	_debug_str += "EDITMODE: " + string(editor.editorMode)+ "\n";
draw_set_font(fMono16);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color_alpha(c_white, 1);
draw_text(global.resolutionW/2, 50, _debug_str);
