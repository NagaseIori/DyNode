/// @description Debug

// Debug

var _debug_str = "";
_debug_str += "FPS: " + string(fps) + "\nRFPS: "+string(fps_real)+"\n";
_debug_str += "DSPD: " + string(animTargetPlaybackSpeed)+"\n";
_debug_str += "MSPD: " + string(musicSpeed)+"\n";
_debug_str += "TIME: " + string(nowTime)+"\n";
if(instance_exists(editor))
	_debug_str += "EDITMODE: " + string(editor.editorMode)+ "\n";
draw_set_font(fDynamix20);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(global.resolutionW/2, 30, _debug_str);
