/// @description Draw some infos

// Time Info

if(topBarTimeA > 0) {
	var _nx = 0.5 * global.resolutionW, _ny = 20;
	var _ntime = musicLength;
	
	if(topBarMouseInbound || topBarMousePressed)
		_ntime = mouse_x / global.resolutionW * musicLength;
	
	var _ele = scribble(format_time_string(nowTime) + " / "+format_time_string(_ntime))
		.starting_format("fMono16", c_white)
		.align(fa_center, fa_top)
		.blend(c_white, topBarTimeA)
		.gradient(themeColor, topBarTimeGradA);
	
	_ele.draw(_nx, _ny);
}


// Chart stats

if(showStats)
scribble("[sprNote] "+string(statCount[0])
	+" [scale,0.5][sprChain][/s] "+string(statCount[1])
	+" [scale,0.5][sprHoldEdge][/s] "+string(statCount[2])
	+ " Total " + string(chartNotesCount))
	.starting_format("fMono16", c_white)
	.align(fa_center, fa_bottom)
	.draw(global.resolutionW/2, global.resolutionH-3);

// Debug

if(!showDebugInfo) return;

var _debug_str = "";
_debug_str += "DyNode " + global.version + "\n";
_debug_str += "by NordLandeW x NagaseIori\n";
_debug_str += "FPS: " + string(fps) + "\nRFPS: "+string(fps_real)+"\n";
_debug_str += "DSPD: " + string(animTargetPlaybackSpeed)+"\n";
_debug_str += "MSPD: " + string(musicSpeed)+"\n";
_debug_str += "TIME: " + string(nowTime)+"\n";
_debug_str += "MUSICTIME: " + string(FMODGMS_Chan_Get_Position(channel)) + "\n";
_debug_str += "MUSICDELAY: " + string(sfmod_channel_get_position(channel, sampleRate) - nowTime) + "\n";
// _debug_str += "SAMPLERATE: " + string(sampleRate)+ "\n";
if(instance_exists(editor))
	_debug_str += "EDITMODE: " + string(editor.editorMode)+ "\n";
draw_set_font(fMono16);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color_alpha(c_white, 1);
draw_text(global.resolutionW/2, 50, _debug_str);
