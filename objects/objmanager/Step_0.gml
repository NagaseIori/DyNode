/// @description Input check & FMOD Update

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


if(keycheck_down(vk_f7))
    window_set_fullscreen(!window_get_fullscreen());
    
if(keycheck_down(vk_f12)) {
	var _file = program_directory + "Screenshots\\" + random_id(9) + ".png"
	screen_save(_file);
	announcement_play("已保存截图到: " + _file)
}
if(keycheck_down(vk_f8))
	switch_autosave();

if(keycheck_down(vk_f9))
	theme_next();