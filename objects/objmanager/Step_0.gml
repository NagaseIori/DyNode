/// @description Input check

camera_set_view_size(view_camera[0], global.resolutionW, global.resolutionH);

// FMODGMS_Sys_Update();

if(keyboard_check_pressed(vk_escape))
    game_end();

if(keyboard_check_pressed(vk_f2))
    map_load();

if(keyboard_check_pressed(ord("F")))
    window_set_fullscreen(!window_get_fullscreen());