/// @description Startup Initialization

// Macros

#macro BASE_RES_W 1920
#macro BASE_RES_H 1080
#macro BASE_FPS 60
#macro MAXIMUM_DELAY_OF_SOUND 30        // in ms

// Global Variables

global.resolutionW = 1920
global.resolutionH = 1080

room_speed = 165;
global.fpsAdjust = BASE_FPS / room_speed;
global.scaleXAdjust = global.resolutionW / BASE_RES_W;
global.scaleYAdjust = global.resolutionH / BASE_RES_H;


// Set GUI Resolution

display_set_gui_size(global.resolutionW, global.resolutionH);
surface_resize(application_surface, global.resolutionW, global.resolutionH);

// Smoother

gpu_set_tex_filter(true);

// DerpXML Initialization

DerpXml_Init();

// FMODGMS Initialization

    // Optional: Check to see if FMODGMS has loaded properly
    if (FMODGMS_Util_Handshake() != "FMODGMS is working.") {
        show_message_async("Error! FMODGMS was not loaded properly.");
        exit;
    }
    
    // Create the system
    FMODGMS_Sys_Create();
    
    // Initialize the system
    FMODGMS_Sys_Initialize(32);
    
// In-Variables

// Init finished

room_goto(rMain);