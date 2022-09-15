/// @description Input check & Exts update

#region Window frame related

window_frame_update();

if(keycheck_down(vk_f7)) {
	if(keycheck_down(vk_f7))
		global.fullscreen = !global.fullscreen;
	window_frame_set_fakefullscreen(global.fullscreen);
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
    	call_later(2, 1, function() {window_frame_set_fakefullscreen(global.fullscreen);});
    }
}

if(window_command_check(window_command_close)) {
	game_end_confirm();
}

#endregion

if(delta_time / 1000 < 100)
	announcementTime += delta_time / 1000;

camera_set_view_size(view_camera[0], global.resolutionW, global.resolutionH);

var _fmoderr = FMODGMS_Sys_Update();

if(_fmoderr < 0) {
    show_error("FMOD ERROR:\n"+FMODGMS_Util_GetErrorMessage(), false);
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