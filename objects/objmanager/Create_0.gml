/// @description Startup Initialization

// Macros

#macro BASE_RES_W 1920
#macro BASE_RES_H 1080
#macro BASE_FPS 60
#macro MAXIMUM_DELAY_OF_SOUND 20        // in ms
#macro FMOD_SOUND_DELAY 0
#macro FMOD_SAMPLE_DELAY 0
#macro EPS 0.001
#macro MIXER_REACTION_RANGE 0.35			// Mixer's reaction pixel range's ratio of resolutionW

// Global Variables

global.configPath = program_directory + "config.json";

global.version = "v0.1.0"

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

// Themes Init

theme_init();

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
        announcement_error("FMOD 未能正确加载。所有音乐相关功能将无法正常运作。请检查文件完整性。");
        exit;
    }
    
    // Create the system
    if (FMODGMS_Sys_Create() < 0) {
        show_error_async("FMOD 创建系统失败。\n 错误信息：" + FMODGMS_Util_GetErrorMessage(), false);
        exit;
    }
    
    // Initialize the system
    FMODGMS_Sys_Set_DSPBufferSize(512, 4);
    FMODGMS_Sys_Initialize(32);

// Input Initialization

instance_create(x, y, objInput);

// Fonts Initialization

scribble_anim_cycle(0.2, 255, 255);
scribble_font_bake_shadow("fOrbitron48", "fOrbitron48s", 0, 10, c_black, 0.4, 0, true);
scribble_font_bake_shadow("fDynamix16", "fDynamix16s", 0, 2, c_black, 0.3, 0, true);
scribble_font_bake_outline_8dir("fDynamix16", "fDynamix16o", c_white, true);
	// Prefetch Msdf Fonts' Texture (this takes time)
	var _texarr = texturegroup_get_textures("texFonts");
	for(var i=0, l=array_length(_texarr); i<l; i++) {
		texture_prefetch(_texarr[i]);
	}
    
// Randomize

randomize();

// Check For Update

_update_get = http_get("https://api.github.com/repos/NagaseIori/DyNode/releases/latest");
_update_url = "";

// Load Settings

load_config();

// Init finished

room_goto(rMain);

#region Project Properties

	projectPath = "";
	backgroundPath = "";
	musicPath = "";
	chartPath = "";
	
#endregion

#region Inner Variables

	// For Announcement
	announcementString = "";
	announcementLastTime = 0;
	announcementTime = 0;
	announcementAlpha = 0;
	animAnnoSpeed = 1 / room_speed;

#endregion