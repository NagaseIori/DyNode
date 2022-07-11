/// @description Input check & FMOD Update

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
    
if(keycheck_down(vk_f12))
    screen_save(program_directory + "Screenshots\\" + random_id(6) + ".png");

if(keycheck_down_ctrl(ord("S")))
    project_save();

if(keycheck_down(vk_f1))
    project_load();