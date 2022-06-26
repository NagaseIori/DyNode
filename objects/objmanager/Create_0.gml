/// @description Startup Initialization

// Macros

#macro BASE_RES_W 1920
#macro BASE_RES_H 1080
#macro BASE_FPS 60
#macro MAXIMUM_DELAY_OF_SOUND 20        // in ms
#macro FMOD_SOUND_DELAY 0
#macro FMOD_SAMPLE_DELAY 0

// Global Variables

global.version = "v0.0.0-Alpha"

global.resolutionW = 1920
global.resolutionH = 1080

room_speed = 165;
global.fpsAdjust = BASE_FPS / room_speed;
global.scaleXAdjust = global.resolutionW / BASE_RES_W;
global.scaleYAdjust = global.resolutionH / BASE_RES_H;

global.difficultyName = ["CASUAL", "NORMAL", "HARD", "MEGA", "GIGA", "TERA"];
global.difficultySprite = [sprCasual, sprNormal, sprHard, sprMega, sprGiga, sprTera];
global.difficultyString = "CNMHGT";

global.noteTypeName = ["NORMAL", "CHAIN", "HOLD", "SUB"];

// Generate Temp Sprite

global.sprLazer = generate_lazer_sprite(2000);

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
        show_message_async("FMOD 未能正确加载，音乐将无法播放。请检查文件完整性。");
        exit;
    }
    
    // Create the system
    FMODGMS_Sys_Create();
    
    // Initialize the system
    FMODGMS_Sys_Initialize(32);
    FMODGMS_Sys_Set_DSPBufferSize(128, 4);
    // FMODGMS_Sys_Set_SoftwareFormat(44100, 0);

// Input Initialization

instance_create(x, y, objInput);
    
// Randomize

randomize();

// Init finished

room_goto(rMain);