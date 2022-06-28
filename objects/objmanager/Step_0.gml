/// @description Input check

camera_set_view_size(view_camera[0], global.resolutionW, global.resolutionH);

// FMODGMS_Sys_Update();

if(keycheck_down(vk_escape))
    game_end();

if(keycheck_down(vk_f2))
    map_load();

if(keycheck_down(ord("F")))
    window_set_fullscreen(!window_get_fullscreen());
    
if(keycheck_down(vk_f12))
    screen_save(program_directory + "Screenshots\\" + random_id(6) + ".png");