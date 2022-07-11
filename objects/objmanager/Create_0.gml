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
global.difficultyCount = string_length(global.difficultyString);

global.noteTypeName = ["NORMAL", "CHAIN", "HOLD", "SUB"];

// Generate Temp Sprite

global.sprLazer = generate_lazer_sprite(2000);

// Set GUI Resolution

surface_resize(application_surface, global.resolutionW, global.resolutionH);
display_set_gui_size(global.resolutionW, global.resolutionH);

// Smoother

gpu_set_tex_filter(true);

// DyCore Initialization

// if(DyCore_Init() != "success") {
//     show_error("DyCore 核心初始化失败。", true);
// }

// DerpXML Initialization

DerpXml_Init();

// FMODGMS Initialization

    // Optional: Check to see if FMODGMS has loaded properly
    if (FMODGMS_Util_Handshake() != "FMODGMS is working.") {
        show_message_async("FMOD 未能正确加载。请检查文件完整性。");
        exit;
    }
    
    // Create the system
    if (FMODGMS_Sys_Create() < 0) {
        show_message_async("FMOD 创建系统失败。\n 错误信息：" + FMODGMS_Util_GetErrorMessage());
        exit;
    }
    
    // Initialize the system
    FMODGMS_Sys_Set_DSPBufferSize(512, 4);
    FMODGMS_Sys_Initialize(32);

// Input Initialization

instance_create(x, y, objInput);
    
// Randomize

randomize();

// Check For Update

_update_get = http_get("https://api.github.com/repos/NagaseIori/DyNode/releases/latest");

// Init finished

room_goto(rMain);

#region Project Properties

	projectPath = "";
	backgroundPath = "";
	musicPath = "";
	chartPath = "";
	
#endregion