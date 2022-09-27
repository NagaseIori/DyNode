/// @description Input check & Exts update

#region Window frame related

window_frame_update();

_set_window_frame_rect = function () {
	var _ratio = min(display_get_width() / global.resolutionW, display_get_height() / global.resolutionH) * 0.7;
    window_frame_set_rect(
		(display_get_width() - global.resolutionW * _ratio) * 0.5,
		(display_get_height() - global.resolutionH * _ratio) * 0.5,
		global.resolutionW * _ratio,
		global.resolutionH * _ratio
		);
}


if(keycheck_down(vk_f7)) {
	if(keycheck_down(vk_f7))
		global.fullscreen = !global.fullscreen;
	window_frame_set_fakefullscreen(global.fullscreen);
	if(!global.fullscreen)
		_set_window_frame_rect();
	
}

if (window_frame_get_visible() && window_has_focus()) {
	var w, h;
	w = window_frame_get_width();
	h = window_frame_get_height();
	if(window_get_width() != w || window_get_height() != h || window_get_x() != 320) {
		window_frame_set_region(0, 0, w, h);
	}
    if(!_windowframe_inited) {
    	_windowframe_inited = true;
    	window_command_hook(window_command_close);
    	call_later(2, 1, function() {
    		if(global.fullscreen)
    			window_frame_set_fakefullscreen(global.fullscreen);
    		else {
				_set_window_frame_rect();
    		}
    	});
    }
}

if(window_command_check(window_command_close)) {
	game_end_confirm();
}

#endregion

#region Announcement update

// Clear removed annos
for(var i=0, l=array_length(announcements); i<l; i++) {
	if(!instance_exists(announcements[i])) {
		array_delete(announcements, i, 1);
		i--;
		l--;
	}
}

// Caculate annos' Y
var _h = 0;
var _margin = 10;
var _l = array_length(announcements);
for(var i=array_length(announcements)-1; i>=0; i--) {
	with(announcements[i]) {
		targetY = _h;
		_h += element.get_height() + _margin;
		
		if(_l - i > objManager.annoThresholdNumber)
			lastTime = min(lastTime, timer + objManager.annoThresholdTime);
	}
}


#endregion


camera_set_view_size(view_camera[0], global.resolutionW, global.resolutionH);

var _fmoderr = FMODGMS_Sys_Update();

if(_fmoderr < 0) {
    show_error("FMOD ERROR:\n"+FMODGMS_Util_GetErrorMessage(), false);
}

if(keycheck_down(vk_f10)) {
	load_config();
	announcement_play("配置已重载。一部分配置可能需要重启游戏来生效。");
}
	

if(room == rMain) {
	if(keycheck_down(vk_f2))
    	map_load();
    if(keycheck_down_ctrl(ord("S")))
    	project_save();
	if(keycheck_down(vk_f1))
	    project_load();
	if(keycheck_down_ctrl(ord("N")))
		project_new();
	
	
	
	// If there is a init struct
	if(initVars != undefined) {
		var _str = initVars;
		with(objMain) {
			chartTitle = _str.title;
			chartSideType[0] = _str.ltype;
			chartSideType[1] = _str.rtype;
			chartDifficulty = difficulty_char_to_num(string_char_at(_str.diff, 1));
		}
		music_load(_str.mus);
		if(_str.bg != "") image_load(_str.bg);
		if(_str.chart != "") map_load(_str.chart);
		initVars = undefined;
	}
	
	// Or there is a init project
	if(initWithProject) {
		initWithProject = false;
		
		if(!project_load()) room_goto(rStartPage);
	}
}    
    
if(keycheck_down(vk_f12)) {
	var _file = program_directory + "Screenshots\\" + random_id(9) + ".png"
	screen_save(_file);
	announcement_play(i18n_get("screenshot_save") + _file)
}
if(keycheck_down(vk_f8))
	switch_autosave();

if(keycheck_down(vk_f9))
	theme_next();