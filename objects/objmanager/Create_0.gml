/// @description Startup Initialization

// Macros

#macro BASE_RES_W 1920
#macro BASE_RES_H 1080
#macro BASE_FPS 60

// Global Variables

global.resolutionW = 1920
global.resolutionH = 1080

room_speed = 165;
global.fpsAdjust = BASE_FPS/room_speed;


// Set GUI Resolution

display_set_gui_size(global.resolutionW, global.resolutionH);
surface_resize(application_surface, global.resolutionW, global.resolutionH);

// Smoother

gpu_set_tex_filter(true);

// Init finished

room_goto(rMain);