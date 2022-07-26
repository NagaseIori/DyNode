/// @description Input check & FMOD Update

announcementTime += delta_time / 1000;

camera_set_view_size(view_camera[0], global.resolutionW, global.resolutionH);

var _fmoderr = FMODGMS_Sys_Update();

if(_fmoderr < 0) {
    show_error("FMOD ERROR:\n"+FMODGMS_Util_GetErrorMessage(), false);
}

if(keycheck_down(vk_escape))
    game_end();

if(keycheck_down(vk_f2))
    map_load();

if(keycheck_down(ord("F")))
    window_set_fullscreen(!window_get_fullscreen());
    
if(keycheck_down(vk_f12)) {
	var _file = program_directory + "Screenshots\\" + random_id(9) + ".png"
	screen_save(_file);
	announcement_play("已保存截图到: " + _file)
}
    

if(keycheck_down_ctrl(ord("S")))
    project_save();

if(keycheck_down(vk_f1))
    project_load();

if(keycheck_down_ctrl(ord("N")))
	project_new();

if(keycheck_down(vk_f9))
	theme_next();